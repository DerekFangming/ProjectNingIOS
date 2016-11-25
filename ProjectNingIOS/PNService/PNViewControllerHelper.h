//
//  PNViewControllerHelper.h
//  ProjectNingIOS
//
//  Created by NingFangming on 9/28/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Helpers)

+(nullable UIViewController*)topViewController;

+(void)present:(nonnull UIViewController* )newVC on:(nullable UIViewController*)source;

@end
