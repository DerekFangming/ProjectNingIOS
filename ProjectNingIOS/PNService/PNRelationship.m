//
//  PNRelationship.m
//  ProjectNingIOS
//
//  Created by NingFangming on 10/31/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNRelationship.h"

@implementation PNRelationship

+ (void) getDetailedFriendListWithResponse:(void (^)(NSArray *,NSError *))response{
    NSError *error = [PNUserManager checkUserLoginStatus];
    if(error != nil){
        response(nil, error);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[PNUserManager currentUser] accessToken] forKey:@"accessToken"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initJSONManagerWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    
    [manager POST:pathForDetailedFriendList
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSArray *friendList = [responseObject objectForKey:@"friendList"];
                  NSMutableArray *result = [[NSMutableArray alloc] init];
                  
                  for(NSDictionary *d in friendList){
                      PNFriend *friend = [[PNFriend alloc] initWithName:[d objectForKey:@"name"]
                                                                  andId:[d objectForKey:@"id"]];
                      [result addObject:friend];
                  }
                  
                  response(result, nil);
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
}

@end
