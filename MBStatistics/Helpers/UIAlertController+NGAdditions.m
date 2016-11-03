//
//  Created by Nikolay Galkin on 07.06.16.
//  Copyright © 2016 Nikolay Galkin. All rights reserved.
//

#import "UIAlertController+NGAdditions.h"

@implementation UIAlertController (NGAdditions)

+ (UIAlertController *)showAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                         inViewController:(UIViewController *)viewController {
    if (viewController) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        // OK button.
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        
        [viewController presentViewController:alertController animated:YES completion:nil];
        return alertController;
    }
    NSLog(@"Error. Parameter viewController must not be nil.");
    return nil;
}

@end
