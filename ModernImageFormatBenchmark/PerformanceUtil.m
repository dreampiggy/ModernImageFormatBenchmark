//
//  PerformanceUtil.m
//  WebImagePerformance
//
//  Created by Liu on 2019/1/22.
//  Copyright © 2019年 Liu. All rights reserved.
//

#import "PerformanceUtil.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

typedef struct bdg_app_cpu_usage {
    long user_time;          /* user run time */
    long system_time;        /* system run time */
    float cpu_usage;         /* cpu usage percentage */
}bdg_app_cpu_usage;

typedef struct {
    u_int64_t appMemory;
    u_int64_t usedMemory;
    u_int64_t totalMemory;
    u_int64_t availabelMemory;
}bdg_MemoryBytes;


@implementation PerformanceUtil

#pragma mark - APP 内存计算

+ (double)memoryUsage {
    bdg_MemoryBytes memoryBytes = bdg_getMemoryBytes();
    return memoryBytes.appMemory / 1024.0 / 1024.0;
}

+ (double)usedMemory {
    bdg_MemoryBytes memoryBytes = bdg_getMemoryBytes();
    return memoryBytes.usedMemory / 1024.0 / 1024.0;
}

+ (double)totalMemory {
    bdg_MemoryBytes memoryBytes = bdg_getMemoryBytes();
    return memoryBytes.totalMemory / 1024.0 / 1024.0;
}

+ (double)availabelMemory {
    bdg_MemoryBytes memoryBytes = bdg_getMemoryBytes();
    return memoryBytes.availabelMemory / 1024.0 / 1024.0;
}


static bdg_MemoryBytes bdg_getMemoryBytes(void) {
    bdg_MemoryBytes memory = {0,0,0,0};
    
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    
    kern_return_t kr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
        return memory;
    }
    
    vm_statistics64_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kr = host_statistics(mach_host_self(),
                         HOST_VM_INFO,
                         (host_info_t)&vmStats,
                         &infoCount);
    
    if (kr != KERN_SUCCESS) {
        return memory;
    }
    
    memory.appMemory = bdg_getAppMemoryBytes();
    memory.usedMemory = (vmStats.active_count + vmStats.wire_count + vmStats.inactive_count)*vm_kernel_page_size;
    memory.totalMemory = [NSProcessInfo processInfo].physicalMemory;
    memory.availabelMemory = (vmStats.free_count+vmStats.inactive_count)*vm_kernel_page_size;
    
    return memory;
}

static u_int64_t bdg_getAppMemoryBytes(void) {
    if (@available(iOS 9.0, *)) {
        return bdg_getAppMemoryBytesAfterIOS9();
    } else {
        return bdg_getAppMemoryBytesBeforIOS9();
    }
}

static u_int64_t bdg_getAppMemoryBytesAfterIOS9(void) {
    u_int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
    }
    return memoryUsageInByte;
}

static u_int64_t bdg_getAppMemoryBytesBeforIOS9(void) {
    int64_t memoryUsageInByte = 0;
    struct task_basic_info taskBasicInfo;
    mach_msg_type_number_t size = sizeof(taskBasicInfo);
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t) &taskBasicInfo, &size);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) taskBasicInfo.resident_size;
    }
    return memoryUsageInByte;
}

#pragma mark - APP CPU计算

+ (float)cpuUsage {
    bdg_app_cpu_usage cup_usage = [self bdgAppCpuInfo];
    return cup_usage.cpu_usage*100;
}

+ (bdg_app_cpu_usage)bdgAppCpuInfo
{
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_basic_info_t basic_info_th;
    bdg_app_cpu_usage app_cpu_usage = {};
    // get threads in the task
    kern_return_t kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return app_cpu_usage;
    }
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    // for each thread
    for (int idx = 0; idx < (int)thread_count; idx++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[idx], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return app_cpu_usage;
        }
        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            app_cpu_usage.user_time += basic_info_th->user_time.seconds;
            app_cpu_usage.system_time += basic_info_th->system_time.seconds;
            app_cpu_usage.cpu_usage += basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return app_cpu_usage;
}

@end
