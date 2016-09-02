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
    NSString *pathForSalt = @"upload_image";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user accessToken] forKey:@"accessToken"];
    [parameters setObject:title forKey:@"title"];
}

@end
