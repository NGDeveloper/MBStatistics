//
//  Created by Nikolay Galkin on 20.04.15.
//  Copyright (c) 2015 Nikolay Galkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NGColorAdditions)

+ (UIColor *)ng_colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

+ (UIColor *)ng_colorWithRGBHexString:(NSString *)hexString;

@end
