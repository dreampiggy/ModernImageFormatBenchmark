//
//  EncodingTester.m
//  ModernImageFormatBenchmark
//
//  Created by lizhuoli on 2019/3/17.
//  Copyright © 2019 dreampiggy. All rights reserved.
//

#import "EncodingTester.h"
#import "PerformanceUtil.h"
#import "CGImageInternal.h"
#import <SDWebImage/SDWebImage.h>
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#import <SDWebImageBPGCoder/SDWebImageBPGCoder.h>
#import <SDWebImageHEIFCoder/SDWebImageHEIFCoder.h>
#import <SDWebImageFLIFCoder/SDWebImageFLIFCoder.h>
#import <SDWebImageAVIFCoder/SDWebImageAVIFCoder.h>

@implementation EncodingTester

+ (void)testEncodingName:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    NSData *bundleData = [NSData dataWithContentsOfFile:bundlePath];
    UIImage *originalImage = [UIImage imageWithData:bundleData];
    NSParameterAssert(originalImage);
    
    // Pre-load bitmap buffer into memory, to avoid CGImage's lazy decoding effect the test result
    CGDataProviderRef provider = CGImageGetDataProvider(originalImage.CGImage);
    CGDataProviderRetainBytePtr(provider);
    
    double quality = 0.75;
    size_t formatCount = 6;
    
    SDImageFormat formats[] = {SDImageFormatHEIC, SDImageFormatHEIF, SDImageFormatWebP, SDImageFormatBPG, SDImageFormatFLIF, SDImageFormatAVIF};
    for (int i = 0; i < formatCount; i++) {
        SDImageFormat format = formats[i];
        id<SDImageCoder> coder;
        switch (format) {
            case SDImageFormatHEIC:
                coder = SDImageIOCoder.sharedCoder;
                break;
            case SDImageFormatHEIF:
                coder = SDImageHEIFCoder.sharedCoder;
                break;
            case SDImageFormatWebP:
                coder = SDImageWebPCoder.sharedCoder;
                break;
            case SDImageFormatBPG:
                coder = SDImageBPGCoder.sharedCoder;
                break;
            case SDImageFormatFLIF:
                coder = SDImageFLIFCoder.sharedCoder;
                break;
            case SDImageFormatAVIF:
                coder = SDImageAVIFCoder.sharedCoder;
                break;
            default:
                break;
        }
        
        [self testEncoder:coder image:originalImage format:format quality:quality];
    }
}

+ (void)testEncoder:(id<SDImageCoder>)encoder image:(UIImage *)image format:(SDImageFormat)format quality:(double)quality {
    CFAbsoluteTime before = CFAbsoluteTimeGetCurrent();
    double memoryUsage = [PerformanceUtil memoryUsage];
    SDImageCoderOptions *encodeOptions = @{SDImageCoderEncodeCompressionQuality : @(quality)};
    NSData *encodedData = [encoder encodedDataWithImage:image format:format options:encodeOptions];
    NSParameterAssert(encodedData);
    CFAbsoluteTime after = CFAbsoluteTimeGetCurrent();
    NSLog(@"Encode:  %@, Time: %.2f ms, RAM: %.3fMB", encoder, (after - before) * 1000, [PerformanceUtil memoryUsage] - memoryUsage);
}

@end
