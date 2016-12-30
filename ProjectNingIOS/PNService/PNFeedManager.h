//
//  PNFeedManager.h
//  ProjectNingIOS
//
//  Created by NingFangming on 12/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNUser.h"
#import "PNUtils.h"
#import "PNFeed.h"

@interface PNFeedManager : NSObject

/**
 Get a list of most recent feeds for a user.
 All feeds are created before the date and will be limited by the limit input.
 If entering nil, for date and limit, they will be defaulted to now and 10.
 @param userId the owner of the feeds
 @param date the check point date
 @param limit this will limit the number of feeds that are retrived at a time
 */
+ (void) getRecentFeedListForUser:(NSNumber *) userId
                          beforeDte:(NSDate *) date
                          withLimit:(NSNumber *) limit
                           response:(void(^)(NSError *, NSArray *, NSDate *)) response;

+ (void) getFeedCoverImgForUser:(NSNumber *) userId
                         onFeed:(NSNumber *) feedId
                         response:(void(^)(NSError *, UIImage *)) response;

+ (void) getFeedPreviewImageIdListForUser:(NSNumber *) userId
                                   response:(void(^)(NSError *, NSArray *)) response;

@end
