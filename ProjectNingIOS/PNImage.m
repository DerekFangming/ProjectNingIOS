//
//  PNImage.m
//  ProjectNingIOS
//
//  Created by NingFangming on 3/18/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNImage.h"

@implementation PNImage

+ (instancetype)imageManager{
    static PNImage *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PNImage alloc] init];
    });
    return sharedInstance;
    
}

+ (void) uploadImage:(UIImage *) img
              inType:(NSString *) type
            response:(void (^)(NSError *))response{
    [self uploadImage:img inType:type withTitle:@"Others" response:response];
}

+ (void) uploadImage:(UIImage *) img
              inType:(NSString *) type
           withTitle:(NSString *) title
            response:(void (^)(NSError *))response{
    NSError *error = [PNUser checkUserLoginStatus];
    if(error != nil){
        response(error);
    }
    
    PNUser *user = [PNUser currentUser];
    NSString *baseURL = @"http://fmning.com:8080/projectNing/";
    NSString *pathForImgUpload = @"upload_image";
    
    NSData *imageData = UIImagePNGRepresentation(img);;
    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user accessToken] forKey:@"accessToken"];
    [parameters setObject:type forKey:@"type"];
    [parameters setObject:title forKey:@"title"];
    [parameters setObject:base64 forKey:@"image"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForImgUpload
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (![[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSMutableDictionary* details = [NSMutableDictionary dictionary];
                  [details setValue:[responseObject objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
                  NSError *error = [NSError errorWithDomain:@"PN" code:200 userInfo:details];
                  response(error);
              }else{
                  response(nil);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(error);
              
          }];
}

+ (void) deleteImageWithId:(NSNumber *) imageId
                  response:(void (^)(NSError *))response{
    NSError *error = [PNUser checkUserLoginStatus];
    if(error != nil){
        response(error);
    }
    
    PNUser *user = [PNUser currentUser];
    NSString *baseURL = @"http://fmning.com:8080/projectNing/";
    NSString *pathForDeleteImg = @"delete_image";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user accessToken] forKey:@"accessToken"];
    [parameters setObject:imageId forKey:@"imageId"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForDeleteImg
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (![[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSMutableDictionary* details = [NSMutableDictionary dictionary];
                  [details setValue:[responseObject objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
                  NSError *error = [NSError errorWithDomain:@"PN" code:200 userInfo:details];
                  response(error);
              }else{
                  response(nil);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(error);
              
          }];
}

+(void) getImageIdListByType:(NSString *) type
                    response:(void (^)(NSMutableArray *list, NSError *error))response{
    NSError *error = [PNUser checkUserLoginStatus];
    if(error != nil){
        response(nil, error);
    }
    
    PNUser *user = [PNUser currentUser];
    NSString *baseURL = @"http://fmning.com:8080/projectNing/";
    NSString *pathForImgIdList = @"get_image_ids_by_type";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user accessToken] forKey:@"accessToken"];
    [parameters setObject:type forKey:@"type"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForImgIdList
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSMutableArray *result = [[NSMutableArray alloc] init];
                  result = [responseObject objectForKey:@"idList"];
                  response(result, nil);
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

+ (void) downloadImageWithId:(NSNumber *) imageId
                    response:(void (^)(UIImage *, NSError *))response{
    NSError *error = [PNUser checkUserLoginStatus];
    if(error != nil){
        response(nil, error);
    }
    
    PNUser *user = [PNUser currentUser];
    NSString *baseURL = @"http://fmning.com:8080/projectNing/";
    NSString *pathForDownloadImg = @"download_image_by_id";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user accessToken] forKey:@"accessToken"];
    [parameters setObject:imageId forKey:@"imageId"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForDownloadImg
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSData* imgData = [[NSData alloc] initWithBase64EncodedString:[responseObject objectForKey:@"image"] options:0];
                  UIImage* image = [UIImage imageWithData:imgData];
                  response(image, nil);
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

+ (void) getAvatarForUser:(NSNumber *) userId
                 response:(void (^)(UIImage *, NSError *))response{
    NSError *error = [PNUser checkUserLoginStatus];
    if(error != nil){
        response(nil, error);
    }
    
    PNUser *user = [PNUser currentUser];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user accessToken] forKey:@"accessToken"];
    [parameters setObject:userId forKey:@"userId"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForUserAvatar
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSData* imgData = [[NSData alloc] initWithBase64EncodedString:[responseObject objectForKey:@"image"] options:0];
                  UIImage* image = [UIImage imageWithData:imgData];
                  
                  response(image, nil);
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

+ (void) getNextAvatarWithAction:(NSString *) action
            forCurrentUserWithId:(NSNumber *) userId
                        response:(void (^)(PNStranger *, bool, NSError *))response{
    NSError *error = [PNUser checkUserLoginStatus];
    if(error != nil){
        response(nil, nil, error);
    }
    
    PNUser *user = [PNUser currentUser];
    NSString *pathForNextAvatar = @"get_next_avatar";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user accessToken] forKey:@"accessToken"];
    if (action != nil && userId != nil) {
        [parameters setObject:action forKey:@"action"];
        [parameters setObject:userId forKey:@"userId"];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForNextAvatar
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSData* imgData = [[NSData alloc] initWithBase64EncodedString:[responseObject objectForKey:@"image"] options:0];
                  UIImage* image = [UIImage imageWithData:imgData];
                  
                  PNStranger *stranger = [[PNStranger alloc]
                                          initWithAvatar:image
                                               andUserId:
                                          [NSNumber numberWithInt:[[responseObject objectForKey:@"userId"] intValue]]];
                  response(stranger, [responseObject objectForKey:@"status"], nil);
              }else{
                  NSMutableDictionary* details = [NSMutableDictionary dictionary];
                  [details setValue:[responseObject objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
                  NSError *error = [NSError errorWithDomain:@"PN" code:200 userInfo:details];
                  response(nil, nil, error);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(nil, nil, error);
              
          }];
}

@end
