//
//  PNMomentManager.h
//  ProjectNingIOS
//
//  Created by NingFangming on 12/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNUser.h"
#import "PNUtils.h"
#import "PNMoment.h"

@interface PNMomentManager : NSObject

/**
 Get a list of most recent moments for a user.
 All moments are created before the date and will be limited by the limit input.
 If entering nil, for date and limit, they will be defaulted to now and 10.
 @param userId the owner of the moments
 @param date the check point date
 @param limit this will limit the number of moments that are retrived at a time
 */
+ (void) getRecentMomentListForUser:(NSNumber *) userId
                          beforeDte: (NSDate *) date
                          withLimit: (NSNumber *) limit
                           response:(void(^)(NSError *, NSArray *, NSDate *)) response;

@end
