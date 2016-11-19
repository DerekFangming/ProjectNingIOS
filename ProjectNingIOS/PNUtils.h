//
//  PNUtils.h
//  ProjectNingIOS
//
//  Created by NingFangming on 10/31/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>

#define requestBaseURL             @"http://fmning.com:8080/projectNing/"
#define pathForDetailedFriendList  @"get_sorted_friend_list"
#define pathForUserAvatar          @"get_avatar"
#define pathForSaltRegistration    @"register_for_salt"
#define pathForUserRegistration    @"register"
#define pathForSaltLogin           @"login_for_salt"
#define pathForUserLogin           @"login"
#define pathForGettingUserDetail   @"get_user_detail"

@interface PNUtils : NSObject

@end
