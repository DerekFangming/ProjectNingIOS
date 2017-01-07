//
//  PNComment.m
//  ProjectNingIOS
//
//  Created by NingFangming on 1/5/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import "PNComment.h"

@implementation PNComment

- (id)initWithCommentId:(NSNumber *) commentId
                andBody:(NSString *) commentBody
                andType:(NSString *) type
           andMappingId:(NSNumber *)mappingId
             andOwnerId:(NSNumber *) ownerId
                andDate:(NSDate *) createdAt{
    self = [super init];
    
    if(self){
        self.commentId = commentId;
        self.commentBody = commentBody;
        self.type = type;
        self.typeMappingId = mappingId;
        self.ownerId = ownerId;
        self.createdAt = createdAt;
    }
    
    return self;
}

@end
