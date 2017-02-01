//
//  PNImageSliderView.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/29/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNImageSliderCell.h"
#import "PNImageSliderDelegate.h"

@interface PNImageSliderView : UIView<UIScrollViewDelegate, PNImageSliderDelegate>

@property(assign) BOOL isUpdatingCellFrames;

@property(assign) NSInteger currentIndex;
@property(strong, nonatomic) NSMutableArray *sliderCells;
@property(strong, nonatomic) UIScrollView *scrollView;

@property(weak, nonatomic) id<PNImageSliderDelegate> delegate;

- (instancetype)initWithInitialIndex:(NSInteger)currentIndex imageIds:(NSArray *)imageIds;

@end
