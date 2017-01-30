//
//  PNImageSliderCell.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/29/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNService.h"

@interface PNImageSliderCell : UIView<UIScrollViewDelegate>

@property(strong, nonatomic) NSNumber *imageId;
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UIScrollView *scrollView;

//@property(weak, nonatomic) id<ZMImageSliderCellDelegate> delegate;

@property(assign, nonatomic) BOOL isImageLoading;

- (instancetype)initWithPNImageId:(NSNumber *)imageId;
- (void)loadImage;

@end
