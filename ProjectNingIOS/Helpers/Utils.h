//
//  Utils.h
//  ProjectNingIOS
//
//  Created by NingFangming on 9/20/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define ACCEPT_ACTION     @"friend"
#define DENY_ACTION       @"deny"
#define NO_AVATAR_ERR_MSG @"The user does not have an avatar."
#define NO_DETAIL_ERR_MSG @"The user does not have detail information."

#define NULL_VC           -1
#define HOME_VC           0
#define FRIEND_VC         1

#define GRAY_COLOR        [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]

@interface Utils : NSObject

+ (void)rotateLayerInfinite:(CALayer *)layer;

@end
