//
//  PNRelationship.h
//  ProjectNingIOS
//
//  Created by NingFangming on 10/31/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNUserManager.h"
#import "PNUtils.h"

@interface PNRelationship : NSObject

+ (void) getDetailedFriendListWithResponse:(void (^)(NSArray *,NSError *))response;

@end
