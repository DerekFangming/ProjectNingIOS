//
//  VCHolder.h
//  ProjectNingIOS
//
//  Created by NingFangming on 10/24/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VCHolder : NSObject{
    UIViewController *homeViewController;
}

+ (instancetype)sharedInstance;

- (UIViewController *)getHomeVC;

- (void) setHomeVC:(UIViewController *) homeVC;

@end
