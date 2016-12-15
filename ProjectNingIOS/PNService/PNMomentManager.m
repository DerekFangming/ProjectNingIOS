//
//  PNMomentManager.m
//  ProjectNingIOS
//
//  Created by NingFangming on 12/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNMomentManager.h"

@implementation PNMomentManager

+ (void) getRecentMomentListForUser:(NSNumber *) userId
                          beforeDte: (NSDate *) date
                          withLimit: (NSNumber *) limit
                           response:(void(^)(NSError *, NSArray *, NSDate *)) response{
    NSError *error = [PNUser checkUserLoginStatus];
    if(error != nil){
        response(error, nil, nil);
    }
    
    PNUser *user = [PNUser currentUser];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user accessToken] forKey:@"accessToken"];
    [parameters setObject:userId forKey:@"userId"];
    if(date != nil){
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
        [parameters setObject:[formatter stringFromDate:date] forKey:@"checkPoint"];
    }
    if(limit != nil)
        [parameters setObject:limit forKey:@"limit"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForRecentMomentList
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (![[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  //NSMutableDictionary* details = [NSMutableDictionary dictionary];
                  //[details setValue:[responseObject objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
                  //NSError *error = [NSError errorWithDomain:@"PN" code:200 userInfo:details];
                  response(error,nil,nil);
              }else{
                  response(nil,nil,nil);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(error,nil,nil);
              
          }];
}
@end
