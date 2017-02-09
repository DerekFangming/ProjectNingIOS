//
//  PNImage.h
//  ProjectNingIOS
//
//  Created by NingFangming on 2/8/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PNImage : NSObject

@property (strong, nonatomic) NSNumber *imageId;
@property (strong, nonatomic) UIImage *image;

- (id)initWithImageId:(NSNumber *) imageId andImage:(UIImage *) image;

@end
