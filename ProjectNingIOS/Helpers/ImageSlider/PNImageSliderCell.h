//
//  PNImageSliderCell.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/29/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNService.h"
#import "PNImageSliderDelegate.h"

@interface PNImageSliderCell : UIView<UIScrollViewDelegate, PNImageSliderDelegate>

@property(strong, nonatomic) NSNumber *imageId;
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UIScrollView *scrollView;

@property(weak, nonatomic) id<PNImageSliderDelegate> delegate;

@property(assign, nonatomic) BOOL isImageLoading;

- (instancetype)initWithPNImageId:(NSNumber *)imageId;

- (instancetype)initWithPNImage:(PNImage *)image;

- (void)loadImage;

@end
