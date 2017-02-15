//
//  PNUserManager.m
//  ProjectNingIOS
//
//  Created by NingFangming on 2/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNUserManager.h"



@implementation PNUserManager


+ (instancetype)sharedInstance {
    
    static PNUserManager *sharedInstance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PNUserManager alloc] init];
    });
    return sharedInstance;
}

+ (PNUser *)currentUser {
    PNUserManager *manager = [self sharedInstance];
    return manager.currentUser;
}


+(void) registerUserWithUsername:(NSString *)loginUsername
                     andPassword:(NSString *)loginPassword
                        response:(void (^)(PNUser *, NSError *))response{
    
    NSMutableDictionary *saltParameters = [NSMutableDictionary dictionary];
    [saltParameters setObject:loginUsername forKey:@"username"];
    [saltParameters setObject:[NSNumber numberWithInt:[[NSTimeZone localTimeZone] secondsFromGMT] / 3600] forKey:@"offset"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForSaltRegistration
       parameters:saltParameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                  [parameters setObject:loginUsername forKey:@"username"];
                  [parameters setObject:[self getMd5:[NSString stringWithFormat:@"%@%@", loginPassword, [responseObject objectForKey:@"salt"]]]
                                 forKey:@"password"];
                  [manager POST:pathForUserRegistration
                     parameters:parameters
                       progress:nil
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                                ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
                                
                                PNUser *user = [[PNUser alloc] initWithUserId:[responseObject objectForKey:@"userId"]
                                                                  andUsername:[responseObject objectForKey:@"username"]
                                                               andAccessToken:[responseObject objectForKey:@"accessToken"]];
                                
                                user.expDate = [formatter dateFromString:[responseObject objectForKey:@"expire"]];
                                user.emailConfirmed = [[responseObject objectForKey:@"emailConfirmed"] boolValue];
                                PNUserManager *manager = [self sharedInstance];
                                manager.currentUser = user;
                                response(user, nil);
                            }else{
                                response(nil, [PNUtils createNSError:responseObject]);

                            }
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            response(nil, error);
                        }];
              }else{
                  response(nil, [PNUtils createNSError:responseObject]);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(nil, error);
              
          }];
}

+ (void) loginUserWithUsername:(NSString *)loginUsername
                   andPassword:(NSString *)loginPassword
                      response:(void (^)(PNUser *, NSError *))response{
    
    NSMutableDictionary *saltParameters = [NSMutableDictionary dictionary];
    [saltParameters setObject:loginUsername forKey:@"username"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForSaltLogin
       parameters:saltParameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                  [parameters setObject:loginUsername forKey:@"username"];
                  [parameters setObject:[self getMd5:[NSString stringWithFormat:@"%@%@", loginPassword, [responseObject objectForKey:@"salt"]]]
                                 forKey:@"password"];
                  [manager POST:pathForUserLogin
                     parameters:parameters
                       progress:nil
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                                ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
                                
                                PNUser *user = [[PNUser alloc] initWithUserId:[responseObject objectForKey:@"userId"]
                                                                  andUsername:[responseObject objectForKey:@"username"]
                                                               andAccessToken:[responseObject objectForKey:@"accessToken"]];
                                
                                user.expDate = [formatter dateFromString:[responseObject objectForKey:@"expire"]];
                                user.emailConfirmed = [[responseObject objectForKey:@"emailConfirmed"] boolValue];
                                PNUserManager *manager = [self sharedInstance];
                                manager.currentUser = user;
                                response(user, nil);
                            }else{
                                response(nil, [PNUtils createNSError:responseObject]);
                            }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            response(nil, error);
                        }];
              }else{
                  response(nil, [PNUtils createNSError:responseObject]);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(nil, error);
          }];
    
}

+ (void) getDetailInfoForUser:(NSNumber *)userId
                     response:(void (^)(PNUser *, NSError *))response{
    
    NSError *error = [self checkUserLoginStatus];
    if(error != nil){
        response(nil, error);
    }
    
    PNUser *user = [PNUserManager currentUser];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user accessToken] forKey:@"accessToken"];
    [parameters setObject:userId forKey:@"userId"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForGettingUserDetail
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  PNUser *user = [[PNUser alloc] initWithUserId:userId];
                  user.nickname = [responseObject objectForKey:@"nickname"];
                  user.gender = [responseObject objectForKey:@"gender"];
                  user.name = [responseObject objectForKey:@"name"];
                  user.age = [responseObject objectForKey:@"age"];
                  user.location = [responseObject objectForKey:@"location"];
                  user.whatsUp = [responseObject objectForKey:@"whatsUp"];
                  
                  response(user, nil);
                  
              }else{
                  response(nil, [PNUtils createNSError:responseObject]);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(nil, error);
          }];
    
}
+ (void) logoutCurrentUser{
    PNUser *user = [PNUserManager currentUser];
    user = nil;
}

+ (NSError *) checkUserLoginStatus{
    PNUser *user = [PNUserManager currentUser];
    //NSLog(user->accessToken); // TODO CHECK SESSION TIMEOUT
    if(user.accessToken == nil){
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"No user logged in" forKey:NSLocalizedDescriptionKey];
        return [NSError errorWithDomain:@"PN" code:200 userInfo:details];
    }
    return nil;
}

+ (NSString *) getCurrentUserAccessToken{
    PNUser *user = [PNUserManager currentUser];
    if (user == nil) return nil;
    return user.accessToken;
}

+ (NSString *) getMd5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
