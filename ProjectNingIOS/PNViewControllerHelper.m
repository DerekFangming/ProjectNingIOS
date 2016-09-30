//
//  PNViewControllerHelper.m
//  ProjectNingIOS
//
//  Created by NingFangming on 9/28/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNViewControllerHelper.h"

@implementation UIViewController (Helpers)

+(UIViewController*)topViewController
{
    UIWindow * window = [[UIApplication sharedApplication]keyWindow];
    return [self topViewController:window.rootViewController];
}

+(UIViewController*)topViewController:(UIViewController*)root
{
    //check to see if there is a view controller presented on top
    if(root.presentedViewController != nil)
    {
        return [self topViewController:root.presentedViewController];
    }
    
    //check to see if this is a tab controller
    if([root isKindOfClass:[UITabBarController class]])
    {
        UITabBarController * tab = (UITabBarController*)root;
        return [self topViewController:tab.selectedViewController];
    }
    
    //check to see if this is a nav controller
    if([root isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * nav = (UINavigationController*)root;
        return [self topViewController:nav.topViewController];
    }
    
    //otherwise, this is the root VC.
    return root;
}


+(void)present:(nonnull UIViewController* )newVC on:(nullable UIViewController*)source
{
    
    if(source == nil)
    {
        source = [UIViewController topViewController];
    }
    
    //if there is a view controller currently presenting, dismiss it first so we can show the login.
    if(source.presentingViewController)
    {
        [[source presentedViewController] dismissViewControllerAnimated:NO completion:nil];
    }
    
    if(source)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [source presentViewController:newVC animated:YES completion:nil];
        });
    }
}

@end
