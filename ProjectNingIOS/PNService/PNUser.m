//
//  PNUser.m
//  ProjectNingIOS
//
//  Created by Cyan Xie on 2/13/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import "PNUser.h"

@implementation PNUser

- (id)initWithUserId:(NSNumber *) userId andUsername:(NSString *) username andAccessToken:(NSString *) accessToken{
    self = [super init];
    
    if(self){
        _userId = userId;
        _username = username;
        _accessToken = accessToken;
    }
    
    return self;
}

@end
