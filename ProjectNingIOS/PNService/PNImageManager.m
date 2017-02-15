//
//  PNImageManager.m
//  ProjectNingIOS
//
//  Created by NingFangming on 3/18/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNImageManager.h"

@implementation PNImageManager

+ (void) uploadImage:(UIImage *) img
              inType:(NSString *) type
   withTypeMappingId:(NSNumber *) typeMappingId
            response:(void (^)(NSError *))response{
    [self uploadImage:img inType:type withTypeMappingId:typeMappingId withTitle:@"" response:response];
}

+ (void) uploadImage:(UIImage *) img
              inType:(NSString *) type
   withTypeMappingId:(NSNumber *) typeMappingId
           withTitle:(NSString *) title
            response:(void (^)(NSError *))response{
    NSError *error = [PNUserManager checkUserLoginStatus];
    if(error != nil){
        response(error);
    }
    
    NSData *imageData = UIImagePNGRepresentation(img);;
    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PNUserManager getCurrentUserAccessToken] forKey:@"accessToken"];
    [parameters setObject:title forKey:@"title"];
    [parameters setObject:base64 forKey:@"image"];
    if(type != nil){
        [parameters setObject:type forKey:@"type"];
        [parameters setObject:typeMappingId forKey:@"typeMappingId"];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initJSONManagerWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    
    [manager POST:pathForImgUpload
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (![[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  response([PNUtils createNSError:responseObject]);
              }else{
                  response(nil);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(error);
              
          }];
}

+ (void) deleteImageWithId:(NSNumber *) imageId
                  response:(void (^)(NSError *))response{
    NSError *error = [PNUserManager checkUserLoginStatus];
    if(error != nil){
        response(error);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PNUserManager getCurrentUserAccessToken] forKey:@"accessToken"];
    [parameters setObject:imageId forKey:@"imageId"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initJSONManagerWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    
    [manager POST:pathForImgDelete
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (![[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  response([PNUtils createNSError:responseObject]);
              }else{
                  response(nil);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(error);
              
          }];
}

+(void) getImageIdListByType:(NSString *) type
                     forUser:(NSNumber *) userId
                    response:(void (^)(NSMutableArray *list, NSError *error))response{
    NSError *error = [PNUserManager checkUserLoginStatus];
    if(error != nil){
        response(nil, error);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PNUserManager getCurrentUserAccessToken] forKey:@"accessToken"];
    [parameters setObject:type forKey:@"type"];
    [parameters setObject:userId forKey:@"userId"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initJSONManagerWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    
    [manager POST:pathForImgIdList
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSMutableArray *result = [[NSMutableArray alloc] init];
                  result = [responseObject objectForKey:@"idList"];
                  response(result, nil);
              }else{
                  response(nil, [PNUtils createNSError:responseObject]);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(nil, error);
              
          }];
}

+ (void) downloadImageWithId:(NSNumber *) imageId
                    response:(void (^)(UIImage *, NSError *))response{
    NSError *error = [PNUserManager checkUserLoginStatus];
    if(error != nil){
        response(nil, error);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PNUserManager getCurrentUserAccessToken] forKey:@"accessToken"];
    [parameters setObject:imageId forKey:@"imageId"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initJSONManagerWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    
    [manager POST:pathForImgDownload
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  UIImage* image = [PNUtils base64ToImage:[responseObject objectForKey:@"image"]];
                  response(image, nil);
              }else{
                  response(nil, [PNUtils createNSError:responseObject]);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(nil, error);
              
          }];
}

+ (void) getSingletonImgForUser:(NSNumber *) userId
                    withImgType:(NSString *) imgType
                       response:(void (^)(UIImage *, NSError *))response{
    NSError *error = [PNUserManager checkUserLoginStatus];
    if(error != nil){
        response(nil, error);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PNUserManager getCurrentUserAccessToken] forKey:@"accessToken"];
    [parameters setObject:userId forKey:@"userId"];
    [parameters setObject:imgType forKey:@"imgType"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initJSONManagerWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    
    [manager POST:pathForSingletonTypeImg
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  UIImage* image = [PNUtils base64ToImage:[responseObject objectForKey:@"image"]];
                  
                  response(image, nil);
              }else{
                  response(nil, [PNUtils createNSError:responseObject]);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(nil, error);
              
          }];
}

+ (void) getNextAvatarWithAction:(NSString *) action
            forCurrentUserWithId:(NSNumber *) userId
                        response:(void (^)(PNUser *, bool, NSError *))response{
    NSError *error = [PNUserManager checkUserLoginStatus];
    if(error != nil){
        response(nil, nil, error);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[PNUserManager getCurrentUserAccessToken] forKey:@"accessToken"];
    if (action != nil && userId != nil) {
        [parameters setObject:action forKey:@"action"];
        [parameters setObject:userId forKey:@"userId"];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initJSONManagerWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    
    [manager POST:pathForNextAvatar
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  UIImage* image = [PNUtils base64ToImage:[responseObject objectForKey:@"image"]];
                  PNUser *user = [[PNUser alloc] initWithUserId:[responseObject objectForKey:@"userId"]];
                  user.avatar = image;
                  
                  response(user, [responseObject objectForKey:@"status"], nil);
              }else{
                  response(nil, nil, [PNUtils createNSError:responseObject]);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(nil, nil, error);
              
          }];
}

@end
