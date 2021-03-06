//
//  PNUserManager.h
//  ProjectNingIOS
//
//  Created by NingFangming on 2/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#import "AFNetworking.h"
#import "PNDateFormater.h"
#import "PNUtils.h"
#import "PNUser.h"


@interface PNUserManager : NSObject

@property (strong, nonatomic) PNUser *currentUser;


+ (instancetype)sharedInstance;

+ (PNUser *)currentUser;

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
    Get detailed information for current user and update the fields
 */
+ (void) getDetailInfoForCurrentUser:(void (^)(NSError *))response;

/**
    Method to get detailed information for a user
    @param userId the id of them user
 */
+ (void) getDetailInfoForUser:(NSNumber *)userId
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
    Return the access token string of the current user
    Return nil if there is no user logged in
 */
+ (NSString *) getCurrentUserAccessToken;

@end
