//
//  PNRelationship.m
//  ProjectNingIOS
//
//  Created by NingFangming on 10/31/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNRelationship.h"

@implementation PNRelationship

+ (void) getDetailedFriendListWithResponse:(void (^)(NSDictionary *,NSError *))response{
    NSError *error = [PNUser checkUserLoginStatus];
    if(error != nil){
        response(nil, error);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[PNUser currentUser] accessToken] forKey:@"accessToken"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForDetailedFriendList
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              //
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              //
          }];
}

@end
