//
//  VCHolder.m
//  ProjectNingIOS
//
//  Created by NingFangming on 10/24/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "VCHolder.h"

@implementation VCHolder

+ (instancetype)sharedInstance {
    
    static VCHolder *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[VCHolder alloc] init];
        sharedInstance -> currentVC = NULL_VC;
    });
    return sharedInstance;
}

- (UIViewController *)getVC:(NSInteger) VCIndicator{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *vc;
    
    if(currentVC != NULL_VC){
        [self preserveVCState];
    }else{
        homeViewController = [mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
        currentVC = HOME_VC;
        return homeViewController;
    }
    
    switch (VCIndicator)
    {
        case HOME_VC:
            vc = homeViewController;
            break;
            
        case CHAT_VC:
            
            break;
            
        case FRIEND_VC:
            if(friendViewController == nil){
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"FriendsViewController"];
                friendViewController = vc;
            }else{
                vc = friendViewController;
            }
            break;
            
        case MOMENT_VC:
            //[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
            //[[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
            //return;
            break;
            
        case ME_VC:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
            //			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
            //			[[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
            //			return;
            break;
    }
    currentVC = VCIndicator;
    return vc;
}

- (void) preserveVCState{
    
    UIViewController *vc = [[SlideNavigationController sharedInstance] visibleViewController];
    
    switch (currentVC) {
        case HOME_VC:
            homeViewController = vc;
            break;
            
        case FRIEND_VC:
            friendViewController = vc;
            break;
    }
}

- (void) setHomeVC:(UIViewController *) homeVC{
    homeViewController = homeVC;
}

- (UIViewController *)getFriendVC{
    return friendViewController;
}

- (void) setFriendVC:(UIViewController *) friendVC{
    friendViewController = friendVC;
}

@end
