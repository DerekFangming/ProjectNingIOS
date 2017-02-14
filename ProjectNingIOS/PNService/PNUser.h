//
//  PNUser.h
//  ProjectNingIOS
//
//  Created by Cyan Xie on 2/13/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNUser : NSObject

@property (strong, nonatomic, readonly) NSNumber* userId;
@property (strong, nonatomic, readonly) NSString* username;
@property (strong, nonatomic, readonly) NSString* accessToken;

@property (strong, nonatomic) NSDate *expDate;
@property (assign, nonatomic) BOOL emailConfirmed;


- (id)initWithUserId:(NSNumber *) userId andUsername:(NSString *) username andAccessToken:(NSString *) accessToken;

@end
