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
#import "SlideNavigationController.h"

@interface VCHolder : NSObject{
    NSInteger currentVC;
    
    UIViewController *homeViewController;
    UIViewController *chatViewController;
    UIViewController *friendViewController;
    UIViewController *momentViewController;
    UIViewController *profileViewController;
}

+ (instancetype)sharedInstance;

- (UIViewController *)getVC:(NSInteger) VCIndicator;

@end
