//
//  PNUser.m
//  ProjectNingIOS
//
//  Created by NingFangming on 2/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNUser.h"



@implementation PNUser


+ (instancetype)currentUser {
    
    static PNUser *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PNUser alloc] init];
    });
    return sharedInstance;
}




+(void) registerUserWithUsername:(NSString *)loginUsername
                     andPassword:(NSString *)loginPassword
                        response:(void (^)(PNUser *, NSError *))response{
    
    NSString *baseURL = @"http://fmning.com:8080/projectNing/";
    NSString *pathForSalt = @"register_for_salt";
    NSString *pathForRegister = @"register";
    
    NSMutableDictionary *saltParameters = [NSMutableDictionary dictionary];
    [saltParameters setObject:loginUsername forKey:@"username"];
    [saltParameters setObject:[NSNumber numberWithInt:[[NSTimeZone localTimeZone] secondsFromGMT] / 3600] forKey:@"offset"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForSalt
       parameters:saltParameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                  [parameters setObject:loginUsername forKey:@"username"];
                  [parameters setObject:[self getMd5:[NSString stringWithFormat:@"%@%@", loginPassword, [responseObject objectForKey:@"salt"]]]
                                 forKey:@"password"];
                  [manager POST:pathForRegister
                     parameters:parameters
                       progress:nil
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                                ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
                                
                                PNUser *user = [PNUser currentUser];
                                user->username = [responseObject objectForKey:@"username"];
                                user->accessToken = [responseObject objectForKey:@"accessToken"];
                                user->expDate = [formatter dateFromString:[responseObject objectForKey:@"expire"]];
                                user->emailConfirmed = [[responseObject objectForKey:@"emailConfirmed"] isEqualToString:@"true"];
                                
                                response(user, nil);
                            }else{
                                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                                [details setValue:[responseObject objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
                                NSError *error = [NSError errorWithDomain:@"PN" code:200 userInfo:details];
                                response(nil, error);

                            }
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            response(nil, error);
                        }];
              }else{
                  NSMutableDictionary* details = [NSMutableDictionary dictionary];
                  [details setValue:[responseObject objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
                  NSError *error = [NSError errorWithDomain:@"PN" code:200 userInfo:details];
                  response(nil, error);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(nil, error);
              
          }];
}

+ (void) loginUserWithUsername:(NSString *)loginUsername
                   andPassword:(NSString *)loginPassword
                      response:(void (^)(PNUser *, NSError *))response{
    NSString *baseURL = @"http://fmning.com:8080/projectNing/";
    NSString *pathForSalt = @"login_for_salt";
    NSString *pathForLogin = @"login";
    
    NSMutableDictionary *saltParameters = [NSMutableDictionary dictionary];
    [saltParameters setObject:loginUsername forKey:@"username"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForSalt
       parameters:saltParameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                  [parameters setObject:loginUsername forKey:@"username"];
                  [parameters setObject:[self getMd5:[NSString stringWithFormat:@"%@%@", loginPassword, [responseObject objectForKey:@"salt"]]]
                                 forKey:@"password"];
                  [manager POST:pathForLogin
                     parameters:parameters
                       progress:nil
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                                ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
                                
                                PNUser *user = [PNUser currentUser];
                                user->username = [responseObject objectForKey:@"username"];
                                user->accessToken = [responseObject objectForKey:@"accessToken"];
                                user->expDate = [formatter dateFromString:[responseObject objectForKey:@"expire"]];
                                user->emailConfirmed = [[responseObject objectForKey:@"emailConfirmed"] isEqualToString:@"true"];
                                
                                response(user, nil);
                            }else{
                                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                                [details setValue:[responseObject objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
                                NSError *error = [NSError errorWithDomain:@"PN" code:200 userInfo:details];
                                response(nil, error);
                            }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            response(nil, error);
                        }];
              }else{
                  NSMutableDictionary* details = [NSMutableDictionary dictionary];
                  [details setValue:[responseObject objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
                  NSError *error = [NSError errorWithDomain:@"PN" code:200 userInfo:details];
                  response(nil, error);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(nil, error);
          }];
    
}

+ (void) logoutCurrentUser{
    PNUser *user = [PNUser currentUser];
    user->username = nil;
    user->accessToken = nil;
    user->expDate = nil;
    user->accessToken = nil;
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

- (NSString *) username{
    return self->username;
}

- (NSDate *) expDate{
    return self->expDate;
}

- (BOOL) emailConfirmed{
    return self->emailConfirmed;
}

-(NSString *) accessToken{
    return self->accessToken;
}


@end
