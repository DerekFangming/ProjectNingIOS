//
//  PNAlertHelper.m
//  ProjectNingIOS
//
//  Created by NingFangming on 9/28/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNAlertHelper.h"

@implementation UIAlertController (Helpers)

+(void)showErrorAlertWithErrorMessage:(NSString *)message
                                 from:(UIViewController *)controller{
    [self showAlertWithTitle:@"Error" andMessage:message from:controller];
}

+(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message from:(UIViewController*)controller{
    [self showDialogWithTitle:title andMessage:message from:controller andActions:@[@"OK"] completionHandler:^(NSInteger selected) {}];
}

+(void)showDialogWithTitle:(NSString*)title andMessage:(NSString*)message from:(UIViewController*)controller andActions:(NSArray<NSString*>*)buttonTitles completionHandler:(void (^)(NSInteger selected))handler{
    if(!controller)
    {
        controller = [UIViewController topViewController];
    }
    
    if(!controller)
    {
        return;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSInteger index = 0;
    for(NSString * title in buttonTitles)
    {
        //set the style to cancel for the last button
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if([title isEqual:buttonTitles.lastObject])
        {
            style = UIAlertActionStyleCancel;
        }
        
        [alert addAction:[UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            handler(index);
        }]];
        
        index++;
    }
    
    [UIViewController present:alert on:controller];
    
}

@end
