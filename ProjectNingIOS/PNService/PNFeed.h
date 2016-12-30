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

@property (nonatomic, strong)NSMutableArray *imgList;

@property (nonatomic, assign)BOOL hasCoverImg;
@property (nonatomic, strong)UIImage *coverImg;

@property (nonatomic, assign)BOOL isLastFeedOfTheDay;
@property (nonatomic, strong)NSMutableAttributedString *dateText;

- (id)initWithFeedId:(NSNumber *) feedId
               andBody:(NSString *) feedBody
               andDate:(NSDate *) createdAt;



@end
