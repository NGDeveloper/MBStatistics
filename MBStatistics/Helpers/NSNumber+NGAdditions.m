//
//  Created by Nikolay Galkin on 31.07.15.
//  Copyright (c) 2015 Nikolay Galkin. All rights reserved.
//

#import "NSNumber+NGAdditions.h"

@implementation NSNumber (NGAdditions)

+ (NSInteger)ng_randomIntegerFrom:(NSInteger)from to:(NSInteger)to {
    NSInteger random = 0;
    
    NSInteger minValue, maxValue;
    if (from <= to) {
        minValue = from;
        maxValue = to;
    } else {
        minValue = to;
        maxValue = from;
    }
    
    NSInteger difference = maxValue - minValue;
    
    random = (arc4random_uniform((u_int32_t)(difference + 1)) + minValue);
    return random;
}

- (NSString *)ng_numeralStringFor1:(NSString *)oneString
                            for234:(NSString *)ttfString
                          forOther:(NSString *)otherString
                        withNumber:(BOOL)withNumber {
    NSInteger number = [self integerValue];

    int dozens = (number / 10) % 10;
    int ones = number % 10;

    NSString *form = nil;

    if (dozens == 1) {
        form = otherString;
    } else {
        if (ones == 1) {
            form = oneString;
        } else if (ones == 2 || ones == 3 || ones == 4 ) {
            form = ttfString;
        } else {
            form = otherString;
        }
    }

    NSString *result = @"";
    if (withNumber) {
        NSString *countText = [NSString stringWithFormat:@"%ld", (long)number];
        result = [NSString stringWithFormat:@"%@ %@", countText, form];
    } else {
        result = form;
    }

    return result;
}

@end
