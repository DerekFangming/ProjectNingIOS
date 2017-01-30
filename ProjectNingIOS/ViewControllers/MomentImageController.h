//
//  MomentImageController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/27/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNService.h"
#import "PNImageSliderView.h"

@interface MomentImageController : UIViewController

@property(strong, nonatomic) NSArray *imageIds;

@property(strong, nonatomic) PNImageSliderView *imageSliderView;
@property(strong, nonatomic) UILabel *displayLabel;

@end
