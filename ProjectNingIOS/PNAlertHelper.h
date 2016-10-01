//
//  PNAlertHelper.h
//  ProjectNingIOS
//
//  Created by NingFangming on 9/28/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNViewControllerHelper.h"

@interface UIAlertController (Helpers)

/**
 */
+(void)showErrorAlertWithErrorMessage:(NSString *)message
                                 from:(UIViewController *)controller;

+(void)showAlertWithTitle:(NSString *)title
               andMessage:(NSString *)message
                     from:(UIViewController*)controller;

+(void)showDialogWithTitle:(NSString *)title
                andMessage:(NSString *)message
                      from:(UIViewController *)controller
                andActions:(NSArray<NSString *> *)buttonTitles
         completionHandler:(void (^)(NSInteger selected))handler;


@end
