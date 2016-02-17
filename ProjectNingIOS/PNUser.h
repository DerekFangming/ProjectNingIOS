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


@interface PNUser : NSObject{
    @protected NSString *username;
    @protected NSString *accessToken;
    @protected NSDate *expDate;
    @protected BOOL emailConfirmed;
}


+ (instancetype)currentUser;


+ (void) registerUserWithUsername:(NSString *)loginUsername
                     andPassword:(NSString *)loginPassword
                        response:(void (^)(PNUser *, NSError *))response;

- (NSString *) username;

- (NSDate *) expDate;

- (BOOL) emailConfirmed;

@end
