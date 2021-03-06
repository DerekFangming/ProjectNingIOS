//
//  PNFeed.h
//  ProjectNingIOS
//
//  Created by NingFangming on 12/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PNFeed : NSObject

@property (nonatomic, strong)NSNumber *feedId;
@property (nonatomic, strong)NSString *feedBody;
@property (nonatomic, strong)NSDate *createdAt;
@property (nonatomic, strong)NSNumber *ownerId;
@property (nonatomic, strong)NSString *ownerName;
@property (nonatomic, strong)UIImage *ownerAvatar;

@property (nonatomic, strong)NSMutableArray *imgList;
@property (nonatomic, strong)NSMutableArray *commentList;
@property (nonatomic, strong)NSMutableArray *commentLikeList;

@property (nonatomic, assign)BOOL hasCoverImg;
@property (nonatomic, strong)UIImage *coverImg;
@property (nonatomic, assign)BOOL likedByCurrentUser;
@property (nonatomic, assign)NSInteger headerCellHeight;
@property (nonatomic, assign)NSInteger commentLikeCellHeight;
@property (nonatomic, assign)NSInteger indexOffset;
@property (nonatomic, assign)NSInteger rowCount;

@property (nonatomic, assign)BOOL isLastFeedOfTheDay;
@property (nonatomic, strong)NSMutableAttributedString *dateText;
@property (nonatomic, strong)NSMutableAttributedString *likeUserText;


- (id)initWithFeedId:(NSNumber *) feedId
               andBody:(NSString *) feedBody
               andDate:(NSDate *) createdAt;



@end
