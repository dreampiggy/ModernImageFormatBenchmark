//
//  TesterUtil.m
//  ModernImageFormatBenchmark
//
//  Created by lizhuoli on 2019/5/9.
//  Copyright © 2019 dreampiggy. All rights reserved.
//

#import "TesterUtil.h"
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#import <SDWebImageBPGCoder/SDWebImageBPGCoder.h>
#import <SDWebImageHEIFCoder/SDWebImageHEIFCoder.h>
#import <SDWebImageFLIFCoder/SDWebImageFLIFCoder.h>
#import <SDWebImageAVIFCoder/SDWebImageAVIFCoder.h>

@implementation TesterUtil

+ (NSString *)typeForFormat:(SDImageFormat)format {
    switch (format) {
        case SDImageFormatJPEG:
            return @"JPEG";
        case SDImageFormatPNG:
            return @"PNG";
        case SDImageFormatGIF:
            return @"GIF";
        case SDImageFormatHEIC:
            return @"HEIC";
        case SDImageFormatHEIF:
            return @"HEIF";
        case SDImageFormatTIFF:
            return @"TIFF";
        case SDImageFormatWebP:
            return @"WebP";
        case SDImageFormatBPG:
            return @"BPG";
        case SDImageFormatFLIF:
            return @"FLIF";
        case SDImageFormatAVIF:
            return @"AVIF";
        default:
            return @"Unknown";
    }
}

@end
