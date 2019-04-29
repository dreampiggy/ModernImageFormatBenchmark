//
//  ViewController.m
//  ModernImageFormatBenchmark
//
//  Created by lizhuoli on 2019/2/2.
//  Copyright © 2019 dreampiggy. All rights reserved.
//

#import "ViewController.h"
#import "DecodingTester.h"
#import "EncodingTester.h"
#import <SDWebImage/SDWebImage.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"lena-512x512" ofType:@"png"];
    NSData *bundleData = [NSData dataWithContentsOfFile:bundlePath];
    UIImage *image = [UIImage imageWithData:bundleData];
    UIImage *outputImage = [image sd_roundedCornerImageWithRadius:1 corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil];
    
    [DecodingTester testDecodingName:@"lena-512x512"];
    [EncodingTester testEncodingName:@"lena-512x512"];
}

@end
