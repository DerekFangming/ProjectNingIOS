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


/**
    Method to register a user to project ning
    In the call back block, either PNuser or NSError is nil. Certain action can then start after checking the result of the register.
    If there is an error, the error message can be accessed by calling [NSError localizedDescription]
    After the login, current user will have three attributs : username, expDate and emailConfirmed
    @param loginUsername the username of the user
    @param loginPassword the password of the user
 */
+ (void) registerUserWithUsername:(NSString *)loginUsername
                      andPassword:(NSString *)loginPassword
                         response:(void (^)(PNUser *, NSError *))response;
/**
    Method to log in a user by username and password
    @param loginUsername the username of the user
    @param loginPassword the password of the user
 */
+ (void) loginUserWithUsername:(NSString *)loginUsername
                   andPassword:(NSString *)loginPassword
                      response:(void (^)(PNUser *, NSError *))response;

/**
    Method to log out a user. Remove all the infomation of singleton current user.
 */
+ (void) logoutCurrentUser;

/**
    Method to check if there is currently user logged in
    Return friendly error if no user logged in
    Return nil if there is a current user
 */
+ (NSError *) checkUserLoginStatus;

/**
    Method to retrieve the username of a user object
 */
- (NSString *) username;

/**
    Method to retrieve the session expiration date of a user object
 */
- (NSDate *) expDate;

/**
    Method to check if the email of the user is confirmed
 */
- (BOOL) emailConfirmed;

/**
    Method to retrieve the accessToken of a user object
 */
-(NSString *) accessToken;

@end
