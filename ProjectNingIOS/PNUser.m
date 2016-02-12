//
//  PNUser.m
//  ProjectNingIOS
//
//  Created by NingFangming on 2/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNUser.h"

@implementation PNUser

-(id) initWithUsername:(NSString *)username andPassword :(NSString *)password{
    self = [super init];
    if(self){
        NSLog(username);
        NSLog(password);
    }
    return self;
}

@end
