//
//  TesterUtil.h
//  ModernImageFormatBenchmark
//
//  Created by lizhuoli on 2019/5/9.
//  Copyright © 2019 dreampiggy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImage.h>

@interface TesterUtil : NSObject

NS_ASSUME_NONNULL_BEGIN

+ (NSString *)typeForFormat:(SDImageFormat)format;

NS_ASSUME_NONNULL_END

@end
