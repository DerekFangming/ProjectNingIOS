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

@property (nonatomic, strong)UIImage *coverImg;


- (id)initWithMomentId:(NSNumber *) momentId andBody:(NSString *) momentBody andDate:(NSDate *) createdAt;

@end
