//
//  PNMoment.m
//  ProjectNingIOS
//
//  Created by NingFangming on 12/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNMoment.h"

@implementation PNMoment

- (id)initWithMomentId:(NSNumber *) momentId andBody:(NSString *) momentBody andDate:(NSDate *) createdAt{
    self = [super init];
    
    if(self){
        self.momentId = momentId;
        self.momentBody = momentBody;
        self.createdAt = createdAt;
    }
    
    return self;
}

@end
