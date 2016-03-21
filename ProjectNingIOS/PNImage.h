//
//  PNImage.h
//  ProjectNingIOS
//
//  Created by NingFangming on 3/18/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface PNImage : NSObject

+ (instancetype)imageManager;

- (void) uploadImage:(UIImage *) img;

@end
