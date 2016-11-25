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
    Show error message with an error message. The title is fixed
    @param message the error message
    @param controller the controller to display the alert
 */
+ (void)showErrorAlertWithErrorMessage:(NSString *)message
                                 from:(UIViewController *)controller;

/**
 Show confirm message showing connected status with stranger. Title is fixed
 @param name the name of the stranger
 @param controller the controller to display the alert
 */
+ (void)showFriendConfirmAlertForStranger:(NSString *)name
                                     from:(UIViewController *)controller
                        completionHandler:(void (^)(NSInteger selected))handler;

/**
    Show alert with customized title and error message
    @param title the title of the alert
    @param message the error message
    @param controller the controller to display the alert
 */
+ (void)showAlertWithTitle:(NSString *)title
               andMessage:(NSString *)message
                     from:(UIViewController*)controller;

/**
    Show alert dialog with customized title, message and button controls
    @param title the title of the alert
    @param message the error message
    @param controller the controller to display the alert
    @param burronTitles an array of strings containing button texts
    @param handler the complete handler block
 */
+ (void)showDialogWithTitle:(NSString *)title
                andMessage:(NSString *)message
                      from:(UIViewController *)controller
                andActions:(NSArray<NSString *> *)buttonTitles
         completionHandler:(void (^)(NSInteger selected))handler;


@end
