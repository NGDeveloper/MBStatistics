//
//  Created by Nikolay Galkin on 07.06.16.
//  Copyright © 2016 Nikolay Galkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (NGAdditions)

+ (UIAlertController *)showAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                         inViewController:(UIViewController *)viewController;

@end
