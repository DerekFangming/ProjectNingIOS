//
//  PNComment.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/5/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PNComment : NSObject

@property (nonatomic, strong)NSNumber *commentId;
@property (nonatomic, strong)NSString *commentBody;
@property (nonatomic, strong)NSNumber *mentionedUserId;
@property (nonatomic, strong)NSString *mentionedUserName;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSNumber *typeMappingId;
@property (nonatomic, strong)NSNumber *ownerId;
@property (nonatomic, strong)NSDate *createdAt;

@property (nonatomic, strong)NSString *ownerDisplayedName;
@property (nonatomic, strong)UIImage *ownerAvatar;

@property (nonatomic, assign)NSInteger cellHeight;

- (id)initWithCommentId:(NSNumber *) commentId
                andBody:(NSString *) commentBody
                andType:(NSString *) type
           andMappingId:(NSNumber *)mappingId
             andOwnerId:(NSNumber *) ownerId
                andDate:(NSDate *) createdAt;
@end
