//
//  DecodingTester.m
//  ModernImageFormatBenchmark
//
//  Created by lizhuoli on 2019/3/17.
//  Copyright © 2019 dreampiggy. All rights reserved.
//

#import "DecodingTester.h"
#import "PerformanceUtil.h"
#import "CGImageInternal.h"
#import <SDWebImage/SDWebImage.h>
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#import <SDWebImageBPGCoder/SDWebImageBPGCoder.h>
#import <SDWebImageHEIFCoder/SDWebImageHEIFCoder.h>
#import <SDWebImageFLIFCoder/SDWebImageFLIFCoder.h>
#import <SDWebImageAVIFCoder/SDWebImageAVIFCoder.h>

@implementation DecodingTester

+ (void)testDecodingName:(NSString *)name {
    size_t formatCount = 6;
    SDImageFormat formats[] = {SDImageFormatHEIC, SDImageFormatHEIF, SDImageFormatWebP, SDImageFormatBPG, SDImageFormatFLIF, SDImageFormatAVIF};
    
    for (int i = 0; i < formatCount; i++) {
        SDImageFormat format = formats[i];
        id<SDImageCoder> coder;
        NSString *type;
        switch (format) {
            case SDImageFormatHEIC:
                coder = SDImageIOCoder.sharedCoder;
                type = @"heic";
                break;
            case SDImageFormatHEIF:
                coder = SDImageHEIFCoder.sharedCoder;
                type = @"heif";
                break;
            case SDImageFormatWebP:
                coder = SDImageWebPCoder.sharedCoder;
                type = @"webp";
                break;
            case SDImageFormatBPG:
                coder = SDImageBPGCoder.sharedCoder;
                type = @"bpg";
                break;
            case SDImageFormatFLIF:
                coder = SDImageFLIFCoder.sharedCoder;
                type = @"flif";
                break;
            case SDImageFormatAVIF:
                coder = SDImageAVIFCoder.sharedCoder;
                type = @"avif";
                break;
            default:
                break;
        }
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
        NSData *bundleData = [NSData dataWithContentsOfFile:bundlePath];
        NSParameterAssert(bundleData);
        
        [self testDecoder:coder data:bundleData];
    }
}

+ (void)testDecoder:(id<SDImageCoder>)decoder data:(NSData *)data {
    CFAbsoluteTime before = CFAbsoluteTimeGetCurrent();
    double memoryUsage = [PerformanceUtil memoryUsage];
    SDImageCoderOptions *decodeOptions = nil;
    UIImage *decodedImage = [decoder decodedImageWithData:data options:decodeOptions];
    NSParameterAssert(decodedImage);
    CFAbsoluteTime after = CFAbsoluteTimeGetCurrent();
    NSLog(@"Decode:  %@, Time: %.2f ms, RAM: %.3fMB", decoder, (after - before) * 1000, [PerformanceUtil memoryUsage] - memoryUsage);
}

@end
