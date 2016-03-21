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

- (void) uploadImage:(UIImage *) img{
    
}

@end
