//
//  HomeViewController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SlideNavigationController.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"

@interface HomeViewController : UIViewController
//
//@property (nonatomic, strong) IBOutlet UISwitch *limitPanGestureSwitch;
//@property (nonatomic, strong) IBOutlet UISwitch *slideOutAnimationSwitch;
//@property (nonatomic, strong) IBOutlet UISwitch *shadowSwitch;
//@property (nonatomic, strong) IBOutlet UISwitch *panGestureSwitch;
//@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *avatarView;

@end
