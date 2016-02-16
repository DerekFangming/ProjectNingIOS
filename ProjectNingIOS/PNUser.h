//
//  PNUser.h
//  ProjectNingIOS
//
//  Created by NingFangming on 2/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#import "AFNetworking.h"
#import "PNDateFormater.h"

//typedef void (^PNBlock)(BOOL success);

//PNUser *(^PNBlock)(int) = ^(int num) {
//    return @"Test";
//};

@interface PNUser : NSObject{
    NSString *password;
}

@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *accessToken;
@property (nonatomic, readonly) NSDate *expDate;
@property (nonatomic, readonly) BOOL emailConfirmed;


-(id) initWithUsername:(NSString *)username andPassword :(NSString *)password;

-(void) registerUserWithUsername:(NSString *)loginUsername
                     andPassword:(NSString *)loginPassword
                        response:(void (^)(PNUser *, NSError *))response;


@end
