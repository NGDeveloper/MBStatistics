//
//  Created by Nikolay Galkin on 31.07.15.
//  Copyright (c) 2015 Nikolay Galkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (NGAdditions)

+ (NSInteger)ng_randomIntegerFrom:(NSInteger)from to:(NSInteger)to;

- (NSString *)ng_numeralStringFor1:(NSString *)oneString
                            for234:(NSString *)ttfString
                          forOther:(NSString *)otherString
                        withNumber:(BOOL)withNumber;

@end
