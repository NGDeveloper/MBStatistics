//
//  Created by Nikolay Galkin on 20.04.15.
//  Copyright (c) 2015 Nikolay Galkin. All rights reserved.
//

#import "UIColor+NGAdditions.h"

@implementation UIColor (NGColorAdditions)


/**
 Creates and returns a color object using the specified RGB component values

 @param red The red value of the color object, specified as a value from 0 to 255.
 @param green The green value of the color object, specified as a value from 0 to 255.
 @param blue The blue value of the color object, specified as a value from 0 to 255.
 @param alpha The opacity value of the color object, specified as a value from 0.0 to 1.0.
 @return The color object.
 */
+ (UIColor *)ng_colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
    return color;
}


/**
 Creates and returns a color object using the specified RGB component values represented in hexadecimal string format (#RRGGBB).

 @param hexString RGB component values represented in hexadecimal string format (#RRGGBB).
 @return The color object.
 */
+ (UIColor *)ng_colorWithRGBHexString:(NSString *)hexString {
    unsigned int rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];    // bypass # character
    [scanner scanHexInt:&rgbValue];
    CGFloat red = (rgbValue & 0xFF0000) >> 16;
    CGFloat green = (rgbValue & 0xFF00) >> 8;
    CGFloat blue = (rgbValue & 0xFF);
    UIColor *color = [UIColor ng_colorWithR:red G:green B:blue A:1.0];
    return color;
}

@end
