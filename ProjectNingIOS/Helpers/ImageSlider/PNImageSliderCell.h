//
//  PNImageSliderCell.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/29/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PNImageSliderCell : UIView<UIScrollViewDelegate>

@property(copy, nonatomic) NSString *imageUrl;
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UIScrollView *scrollView;

//@property(weak, nonatomic) id<ZMImageSliderCellDelegate> delegate;

- (instancetype)initWithImageUrl:(NSString *)imageUrl;
//- (void)loadImage;

@end
