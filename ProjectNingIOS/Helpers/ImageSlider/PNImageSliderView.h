//
//  PNImageSliderView.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/29/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNImageSliderCell.h"

@interface PNImageSliderView : UIView<UIScrollViewDelegate>

@property(assign) BOOL isUpdatingCellFrames;

@property(assign) NSInteger currentIndex;
@property(strong, nonatomic) NSMutableArray *sliderCells;
@property(strong, nonatomic) UIScrollView *scrollView;

//@property(weak, nonatomic) id<ZMImageSliderViewDelegate> delegate;

- (instancetype)initWithInitialIndex:(NSInteger)currentIndex imageIds:(NSArray *)imageIds;

@end
