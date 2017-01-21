//
//  PNCommentManager.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/5/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNUser.h"
#import "PNUtils.h"
#import "PNComment.h"

@interface PNCommentManager : NSObject

+ (void) createComment:(NSString *) commentBody
        forCommentType:(NSString *) type
          andMappingId:(NSNumber *) mappingId
          mentionsUser:(NSNumber *) mentionedUserId
              response:(void(^)(NSError *)) response;

+ (void) getRecentCommentsForCurrentUserWithCommentType:(NSString *) type
                                           andMappingId:(NSNumber *) mappingId
                                               response:(void(^)(NSError *, NSMutableArray *)) response;


@end
