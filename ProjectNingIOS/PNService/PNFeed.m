//
//  PNFeed.m
//  ProjectNingIOS
//
//  Created by NingFangming on 12/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNFeed.h"

@implementation PNFeed

- (id)initWithFeedId:(NSNumber *) feedId andBody:(NSString *) feedBody andDate:(NSDate *) createdAt{
    self = [super init];
    
    if(self){
        self.feedId = feedId;
        self.feedBody = feedBody;
        self.createdAt = createdAt;
    }
    
    return self;
}


@end
