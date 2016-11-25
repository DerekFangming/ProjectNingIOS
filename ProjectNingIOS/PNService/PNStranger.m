//
//  PNStranger.m
//  ProjectNingIOS
//
//  Created by NingFangming on 9/9/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNStranger.h"

@implementation PNStranger

/**
    Init method for PNStranger.
    @param newAvatar the avatar image of the stranger
    @param newUserId the internal user id of the stranger
 */
- (id)initWithAvatar:(UIImage *) newAvatar andUserId:(NSNumber *) newUserId{
    self = [super init];
    
    if(self){
        avatar = newAvatar;
        userId = newUserId;
    }
    
    return self;
}

/**
 Method to retrieve the avatar of a stranger object
 */
- (UIImage *) avatar{
    return self->avatar;
}

/**
 Method to retrieve the user id of a stranger object
 */
- (NSNumber *) userId{
    return self->userId;
}

@end
