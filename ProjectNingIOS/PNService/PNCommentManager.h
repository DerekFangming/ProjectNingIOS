//
//  PNCommentManager.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/5/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNUserManager.h"
#import "PNUtils.h"
#import "PNComment.h"

@interface PNCommentManager : NSObject
/**
    Create and save a comment to the server with basic information
    @param commentBody the body of the comment
    @param type the type of the comment
    @param mappingId the mapping id for the comment type
    @param mentionedUserId the mentioned user for this comment, if there is one
 */
+ (void) createComment:(NSString *) commentBody
        forCommentType:(NSString *) type
          andMappingId:(NSNumber *) mappingId
          mentionsUser:(NSNumber *) mentionedUserId
              response:(void(^)(NSError *, NSNumber *)) response;

/**
    Delete a comment base on comment id. Only the owner of the comment can delete the comment
    @param commentId the id of the comment
 */
+ (void) deleteCommentWithId:(NSNumber *) commentId response:(void(^)(NSError *)) response;

/**
    Get all comments for a comment type that are from a friend of the current user
    Comments will be ordered by date desc
    Get a bool value showing if the current user liked the comment
    @type the type of the comment
    @mappingIf the mapping id for the comment type
 */
+ (void) getRecentCommentsForCurrentUserWithCommentType:(NSString *) type
                                           andMappingId:(NSNumber *) mappingId
                                               response:(void(^)(NSError *, NSMutableArray *, BOOL)) response;
/**
    Get the count of text comments and then the like comments
    Get a bool value showing if the current user liked the comment
    @mappingIf the mapping id for the comment type. Type is specific to Feed and Feed Like as this is a specific method
 */
+ (void) getCommentCountForCommentMappingId:(NSNumber *) mappingId
                                   response:(void (^)(NSError *, NSNumber * ,NSNumber *, BOOL, NSNumber *)) response;

@end
