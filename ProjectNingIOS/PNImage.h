//
//  PNImage.h
//  ProjectNingIOS
//
//  Created by NingFangming on 3/18/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 
#import "PNUser.h"

@interface PNImage : NSObject

+ (instancetype)imageManager;

+ (void) uploadImage:(UIImage *) img
              inType:(NSString *) type
            response:(void (^)(NSError *))response;

+ (void) uploadImage:(UIImage *) img
              inType:(NSString *) type
           withTitle:(NSString *) title
            response:(void (^)(NSError *))response;

+ (void) deleteImage:(NSNumber *) imageId
            response:(void (^)(NSError *))response;

@end
