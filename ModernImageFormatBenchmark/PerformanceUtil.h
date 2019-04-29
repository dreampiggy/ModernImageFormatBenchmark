//
//  PerformanceUtil.h
//  WebImagePerformance
//
//  Created by Liu on 2019/1/22.
//  Copyright © 2019年 Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PerformanceUtil : NSObject

+ (double)memoryUsage;
+ (double)usedMemory;
+ (double)totalMemory;
+ (double)availabelMemory;

+ (float)cpuUsage;

@end

NS_ASSUME_NONNULL_END
