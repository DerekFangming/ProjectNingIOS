//
//  PNFriend.m
//  ProjectNingIOS
//
//  Created by NingFangming on 11/3/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNFriend.h"

@implementation PNFriend

- (id)initWithName:(NSString *) name andId:(NSNumber *) userId{
    self = [super init];
    
    if(self){
        self.name = name;
        self.userId = userId;
    }
    
    return self;
}

@end
