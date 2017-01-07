//
//  PNComment.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/5/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNComment : NSObject

@property (nonatomic, strong)NSNumber *commentId;
@property (nonatomic, strong)NSString *commentBody;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSNumber *typeMappingId;
@property (nonatomic, strong)NSNumber *ownerId;
@property (nonatomic, strong)NSDate *createdAt;

@property (nonatomic, strong)NSString *ownerDisplayedName;

- (id)initWithCommentId:(NSNumber *) commentId
                andBody:(NSString *) commentBody
                andType:(NSString *) type
           andMappingId:(NSNumber *)mappingId
             andOwnerId:(NSNumber *) ownerId
                andDate:(NSDate *) createdAt;
@end
