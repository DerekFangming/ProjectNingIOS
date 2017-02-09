//
//  PNImage.m
//  ProjectNingIOS
//
//  Created by NingFangming on 2/8/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import "PNImage.h"

@implementation PNImage

- (id)initWithImageId:(NSNumber *) imageId andImage:(UIImage *) image{
    self = [super init];
    
    if(self){
        self.imageId = imageId;
        self.image = image;
    }
    
    return self;
}

@end
