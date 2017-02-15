//
//  PNUser.h
//  ProjectNingIOS
//
//  Created by Cyan Xie on 2/13/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PNUser : NSObject

@property (strong, nonatomic, readonly) NSNumber* userId;
@property (strong, nonatomic, readonly) NSString* username;
@property (strong, nonatomic, readonly) NSString* accessToken;

@property (strong, nonatomic) NSDate *expDate;
@property (assign, nonatomic) BOOL emailConfirmed;

@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickname;
@property (strong, nonatomic) NSString *displayedName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *whatsUp;

- (id)initWithUserId:(NSNumber *) userId;

- (id)initWithUserId:(NSNumber *) userId andUsername:(NSString *) username andAccessToken:(NSString *) accessToken;

@end
