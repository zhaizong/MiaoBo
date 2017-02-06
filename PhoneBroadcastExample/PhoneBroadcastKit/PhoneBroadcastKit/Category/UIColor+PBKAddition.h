//
//  UIColor+PBKAddition.h
//  PhoneBroadcastKit
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIColor (PBKAddition)

/**
 *  从16进制颜色转成UIColor
 *
 *  @param hexString 十六进制颜色，例如 "dc8310" 或 "#dc8310"
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  颜色转成十六进制
 *
 *  @param color 颜色
 *
 *  @return 十六进制描述string
 */
+ (NSString *)hexValuesFromUIColor:(UIColor *)color;

/**
 *  颜色转成十六进制
 *
 *  @param rgbValue 颜色
 *
 *  @return 十六进制Code, eg. 0x0088cc
 */
+ (UIColor *)colorWithHexRGB:(unsigned)rgbValue;

@end
NS_ASSUME_NONNULL_END

