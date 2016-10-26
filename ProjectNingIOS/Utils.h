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
#define NULL_VC           -1
#define HOME_VC           0
#define FRIEND_VC         1

@interface Utils : NSObject

+ (void)rotateLayerInfinite:(CALayer *)layer;

@end
