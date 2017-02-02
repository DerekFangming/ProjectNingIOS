//
//  Utils.h
//  ProjectNingIOS
//
//  Created by NingFangming on 9/20/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define ACCEPT_ACTION       @"friend"
#define DENY_ACTION         @"deny"
#define NO_AVATAR_ERR_MSG   @"The user does not have an avatar."
#define NO_DETAIL_ERR_MSG   @"The user does not have detail information."
#define NO_COMMENT_ERR_MSG  @"The comment you are looking for does not exist."

#define AVATAR              @"Avatar"
#define COVER_IMG           @"Cover Image"
#define MOMENT              @"Moment"

#define NULL_VC             -1
#define HOME_VC             0
#define FRIEND_VC           1

#define GRAY_BG_COLOR       [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define PURPLE_COLOR        [UIColor colorWithRed:87/255.0 green:107/255.0 blue:149/255.0 alpha:1]
@interface Utils : NSObject

+ (void)rotateLayerInfinite:(CALayer *)layer;

+ (NSString *) processDateToText: (NSDate *) date withAbbreviation:(BOOL) abbrev;

+ (NSString *) monthToString:(NSInteger) intMonth withAbbreviation:(BOOL) abbrev;

@end
