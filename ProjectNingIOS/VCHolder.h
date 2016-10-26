//
//  VCHolder.h
//  ProjectNingIOS
//
//  Created by NingFangming on 10/24/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Utils.h"

@interface VCHolder : NSObject{
    UIViewController *homeViewController;
    UIViewController *friendViewController;
}

+ (instancetype)sharedInstance;

- (UIViewController *)getHomeVCFromVC: (NSInteger) VCIndicator;

- (void) setHomeVC:(UIViewController *) homeVC;

- (UIViewController *)getFriendVC;

- (void) setFriendVC:(UIViewController *) friendVC;

@end
