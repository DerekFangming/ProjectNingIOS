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
            if(chatViewController == nil){
                vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
                chatViewController = vc;
            }else{
                vc = chatViewController;
            }
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
            if(momentViewController == nil){
                vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MomentViewController"];
                momentViewController = vc;
            }else{
                vc = momentViewController;
            }
            break;
            
        case ME_VC:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
            // log out method
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
