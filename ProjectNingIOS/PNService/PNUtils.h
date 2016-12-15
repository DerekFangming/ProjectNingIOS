//
//  PNUtils.h
//  ProjectNingIOS
//
//  Created by NingFangming on 10/31/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>

#define requestBaseURL              @"http://fmning.com:8080/projectNing/"
#define pathForDetailedFriendList   @"get_sorted_friend_list"
#define pathForSaltRegistration     @"register_for_salt"
#define pathForUserRegistration     @"register"
#define pathForSaltLogin            @"login_for_salt"
#define pathForUserLogin            @"login"
#define pathForGettingUserDetail    @"get_user_detail"
#define pathForImgUpload            @"upload_image"
#define pathForImgDelete            @"delete_image"
#define pathForImgIdList            @"get_image_ids_by_type"
#define pathForImgDownload          @"download_image_by_id"
#define pathForSingletonTypeImg     @"get_singleton_img_by_type"
#define pathForRecentMomentList     @"get_recent_moments"


@interface PNUtils : NSObject

+ (NSError *) createNSError:(NSDictionary *) dic;

@end
