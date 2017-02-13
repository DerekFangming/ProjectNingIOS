//
//  PNImageSliderView.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/29/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNImage.h"
#import "PNImageSliderCell.h"
#import "PNImageSliderDelegate.h"

@interface PNImageSliderView : UIView<UIScrollViewDelegate, PNImageSliderDelegate>

@property(assign) BOOL isUpdatingCellFrames;

@property(assign) NSInteger currentIndex;
@property(strong, nonatomic) NSMutableArray *sliderCells;
@property(strong, nonatomic) UIScrollView *scrollView;

@property(weak, nonatomic) id<PNImageSliderDelegate> delegate;

- (instancetype)initWithInitialIndex:(NSInteger)currentIndex imageIds:(NSArray *)imageIds;

- (instancetype)initWithInitialIndex:(NSInteger)currentIndex pnImages:(NSArray *)imageIds;

/**
    Gather as many imgaes as possible for the given image id list
    Return an array of PNImage, with image IDs
    If the image is already loaded, add the UIImage to PNImage object
 */
- (NSArray *)gatherAllImagesOrIds;

- (UIImage *)getCurrentImage;

@end
