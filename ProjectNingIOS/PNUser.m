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

//+ (instancetype)initWithUsername:(NSString *) username
//                        andToken:(NSString *) token
//                          andExp:(NSDate *)exp
//               andEmailConfirmed:(BOOL) emailCondirmed{
//    static PNUser *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[PNUser alloc] init];
//    });
//    return sharedInstance;
//}
//
//-(id) initWithUsername:(NSString *)usernamei andPassword :(NSString *)password{
//    PNUser *user = [PNUser currentUser];
//    user->temp = @"readonly!";
//    return user;
//}



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
              int code = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
              if (code == 404) {
                  NSMutableDictionary* details = [NSMutableDictionary dictionary];
                  [details setValue:@"Server is not started. Please contact me at synfm123@gmail.com" forKey:NSLocalizedDescriptionKey];
                  response(nil, [NSError errorWithDomain:@"PN" code:404 userInfo:details]);
              }else if(code == 500){
                  NSMutableDictionary* details = [NSMutableDictionary dictionary];
                  [details setValue:@"Internal server error. Please contact me at synfm123@gmail.com" forKey:NSLocalizedDescriptionKey];
                  response(nil, [NSError errorWithDomain:@"PN" code:500 userInfo:details]);
              }else{
                  response(nil, error);
              }
              
          }];
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


@end
