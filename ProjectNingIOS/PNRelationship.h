//
//  PNRelationship.h
//  ProjectNingIOS
//
//  Created by NingFangming on 10/31/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNUser.h"
#import "PNUtils.h"

@interface PNRelationship : NSObject

+ (void) getDetailedFriendListWithResponse:(void (^)(NSDictionary *,NSError *))response;

@end
