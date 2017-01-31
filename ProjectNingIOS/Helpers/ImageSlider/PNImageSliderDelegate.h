//
//  PNImageSliderDelegate.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/30/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PNImageSliderDelegate <NSObject>

- (void)imageSliderViewSingleTap:(UITapGestureRecognizer *)tap;
- (void)imageSliderViewImageDidSwitchToIndex:(NSInteger)index totalCount:(NSInteger)count;

@end


/* PNImageSliderDelegate_h */
