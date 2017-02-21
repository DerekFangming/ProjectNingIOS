//
//  PNFeedManager.m
//  ProjectNingIOS
//
//  Created by NingFangming on 12/14/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNFeedManager.h"

@implementation PNFeedManager

+ (void) createFeedForCurrentUserWithFeedBody:(NSString *) feedBody
                                    response :(void(^)(NSError *, NSNumber *)) response{
    NSError *error = [PNUserManager checkUserLoginStatus];
    if(error != nil){
        response(error, nil);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PNUserManager getCurrentUserAccessToken] forKey:@"accessToken"];
    [parameters setObject:feedBody forKey:@"feedBody"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initJSONManagerWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    
    [manager POST:pathForCreatingFeed
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  response(nil, [responseObject objectForKey:@"feedId"]);
              }else{
                  response([PNUtils createNSError:responseObject], nil);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(error,nil);
              
          }];
}

+ (void) getRecentFeedListForUser:(NSNumber *) userId
                          beforeDte: (NSDate *) date
                          withLimit: (NSNumber *) limit
                           response:(void(^)(NSError *, NSArray *, NSDate *)) response{
    NSError *error = [PNUserManager checkUserLoginStatus];
    if(error != nil){
        response(error, nil, nil);
    }
    
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PNUserManager getCurrentUserAccessToken] forKey:@"accessToken"];
    [parameters setObject:userId forKey:@"userId"];
    if(date != nil)
        [parameters setObject:[formatter stringFromDate:date] forKey:@"checkPoint"];

    if(limit != nil)
        [parameters setObject:limit forKey:@"limit"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initJSONManagerWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    
    [manager POST:pathForRecentFeedList
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSArray *array = [responseObject objectForKey:@"feedList"];
                  NSMutableArray *feedList = [[NSMutableArray alloc] init];
                  for(NSDictionary * dic in array){
                      PNFeed *feed = [[PNFeed alloc] initWithFeedId:[dic objectForKey:@"feedId"]
                                                                    andBody:[dic objectForKey:@"feedBody"]
                                                                    andDate:[formatter dateFromString:[dic objectForKey:@"createdAt"]]];
                      feed.hasCoverImg = [[dic objectForKey:@"hasImage"] boolValue];
                      if(feed.hasCoverImg){
                          feed.imgIdList = [dic objectForKey:@"imageIdList"];
                      }
                      [feedList addObject:feed];
                  }
                  
                  NSDate *checkPoint = [formatter dateFromString:[responseObject objectForKey:@"checkPoint"]];
                  response(nil, feedList,checkPoint);
              }else{
                  response([PNUtils createNSError:responseObject], nil, nil);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(error,nil,nil);
              
          }];
}

+ (void) getFeedCoverImgForUser:(NSNumber *) userId
                         onFeed: (NSNumber *) feedId
                          response:(void(^)(NSError *, UIImage *)) response{
    NSError *error = [PNUserManager checkUserLoginStatus];
    if(error != nil){
        response(error, nil);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PNUserManager getCurrentUserAccessToken] forKey:@"accessToken"];
    [parameters setObject:userId forKey:@"userId"];
    [parameters setObject:feedId forKey:@"feedId"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initJSONManagerWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    
    [manager POST:pathForFeedCoverImg
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  UIImage* image = [PNUtils base64ToImage:[responseObject objectForKey:@"image"]];
                  response(nil, image);
              }else{
                  response([PNUtils createNSError:responseObject], nil);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(error,nil);
              
          }];
}

+ (void) getFeedPreviewImageIdListForUser:(NSNumber *) userId
                                   response:(void(^)(NSError *, NSArray *)) response{
    NSError *error = [PNUserManager checkUserLoginStatus];
    if(error != nil){
        response(error, nil);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PNUserManager getCurrentUserAccessToken] forKey:@"accessToken"];
    [parameters setObject:userId forKey:@"userId"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initJSONManagerWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    
    [manager POST:pathForFeedPreviewIds
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  response(nil, [responseObject objectForKey:@"idList"]);
              }else{
                  response([PNUtils createNSError:responseObject], nil);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(error,nil);
              
          }];
}

@end
