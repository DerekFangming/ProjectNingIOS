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
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user accessToken] forKey:@"accessToken"];
    [parameters setObject:userId forKey:@"userId"];
    if(date != nil)
        [parameters setObject:[formatter stringFromDate:date] forKey:@"checkPoint"];

    if(limit != nil)
        [parameters setObject:limit forKey:@"limit"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForRecentMomentList
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSDate *checkPoint = [formatter dateFromString:[responseObject objectForKey:@"checkPoint"]];
                  response(nil, nil,checkPoint);
              }else{
                  response([PNUtils createNSError:responseObject], nil, nil);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(error,nil,nil);
              
          }];
}
@end
