//
//  PNMoment.h
//  ProjectNingIOS
//
//  Created by NingFangming on 12/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PNMoment : NSObject

@property (nonatomic, strong)NSNumber *momentId;
@property (nonatomic, strong)NSString *momentBody;
@property (nonatomic, strong)NSDate *createdAt;

@property (nonatomic, strong)NSMutableArray *imgList;

@property (nonatomic, assign)BOOL hasCoverImg;
@property (nonatomic, strong)UIImage *coverImg;

@property (nonatomic, assign)BOOL isLastMomentOfTheDay;
@property (nonatomic, strong)NSMutableAttributedString *dateText;

- (id)initWithMomentId:(NSNumber *) momentId
               andBody:(NSString *) momentBody
               andDate:(NSDate *) createdAt;



@end
