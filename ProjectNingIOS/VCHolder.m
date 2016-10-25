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
    });
    return sharedInstance;
}

- (UIViewController *)getHomeVC{
    return homeViewController;
}

- (void) setHomeVC:(UIViewController *) homeVC{
    homeViewController = homeVC;
}

@end
