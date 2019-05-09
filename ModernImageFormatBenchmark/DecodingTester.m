//
//  DecodingTester.m
//  ModernImageFormatBenchmark
//
//  Created by lizhuoli on 2019/3/17.
//  Copyright © 2019 dreampiggy. All rights reserved.
//

#import "DecodingTester.h"
#import "PerformanceUtil.h"
#import "TesterUtil.h"
#import "CGImageInternal.h"
#import <SDWebImage/SDWebImage.h>
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#import <SDWebImageBPGCoder/SDWebImageBPGCoder.h>
#import <SDWebImageHEIFCoder/SDWebImageHEIFCoder.h>
#import <SDWebImageFLIFCoder/SDWebImageFLIFCoder.h>
#import <SDWebImageAVIFCoder/SDWebImageAVIFCoder.h>

@implementation DecodingTester

+ (void)testDecodingName:(NSString *)name {
    size_t formatCount = 8;
    SDImageFormat formats[] = {SDImageFormatPNG, SDImageFormatJPEG, SDImageFormatHEIC, SDImageFormatHEIF, SDImageFormatWebP, SDImageFormatBPG, SDImageFormatFLIF, SDImageFormatAVIF};
    
    for (int i = 0; i < formatCount; i++) {
        SDImageFormat format = formats[i];
        id<SDImageCoder> coder;
        switch (format) {
            case SDImageFormatPNG:
            case SDImageFormatJPEG:
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
        NSString *type = [TesterUtil typeForFormat:format].lowercaseString;
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
        NSData *bundleData = [NSData dataWithContentsOfFile:bundlePath];
        NSParameterAssert(bundleData);
        
        [self testDecoder:coder data:bundleData format:format];
    }
}

+ (void)testDecoder:(id<SDImageCoder>)decoder data:(NSData *)data format:(SDImageFormat)format {
    CFAbsoluteTime before = CFAbsoluteTimeGetCurrent();
    double memoryUsage = [PerformanceUtil memoryUsage];
    SDImageCoderOptions *decodeOptions = nil;
    UIImage *decodedImage = [decoder decodedImageWithData:data options:decodeOptions];
    NSParameterAssert(decodedImage);
    CFAbsoluteTime after = CFAbsoluteTimeGetCurrent();
    NSString *type = [TesterUtil typeForFormat:format];
    printf("<Decode> [%s]: Time: %.2f ms, RAM: %.3f MB\n", [type cStringUsingEncoding:NSASCIIStringEncoding], (after - before) * 1000, [PerformanceUtil memoryUsage] - memoryUsage);
}

@end
