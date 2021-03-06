//
//  PNUtils.h
//  ProjectNingIOS
//
//  Created by NingFangming on 10/31/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
#define pathForNextAvatar           @"get_next_avatar"
#define pathForCreatingFeed         @"create_feed"
#define pathForRecentFeedList       @"get_recent_feeds"
#define pathForRecentFeeds          @"get_recent_feeds_from_friends"
#define pathForFeedCoverImg         @"get_feed_cover_img"
#define pathForFeedPreviewIds       @"get_feed_preview_images"
#define pathForCreatingComment      @"create_comment"
#define pathForDeletingComment      @"delete_comment"
#define pathForRecentComments       @"get_recent_comment_from_friends"
#define pathForCommentsCount        @"get_comment_counts_from_friends"


@interface PNUtils : NSObject

+ (NSError *) createNSError:(NSDictionary *) dic;

+ (UIImage *) base64ToImage:(NSString *) base64Str;

@end
