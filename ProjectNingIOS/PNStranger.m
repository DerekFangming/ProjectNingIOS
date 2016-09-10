//
//  PNStranger.m
//  ProjectNingIOS
//
//  Created by NingFangming on 9/9/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNStranger.h"

@implementation PNStranger

- (id)initWithAvatar:(UIImage *) newAvatar andUserId:(NSNumber *) newUserId{
    self = [super init];
    
    if(self){
        avatar = newAvatar;
        userId = newUserId;
    }
    
    return self;
}

@end
