//
//  MomentImageController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/27/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "PNService.h"
#import "PNImageSliderView.h"
#import "PNImageSliderDelegate.h"

@interface MomentImageController : UIViewController<PNImageSliderDelegate>{
    UIView *floatingView;
    UITextView *momentTextView;
    
    NSString *dateText;
    UILabel *dateLabel;
}

@property(strong, nonatomic) NSArray *imageIdList;

@property(strong, nonatomic) PNImageSliderView *imageSliderView;

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *displayedName;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) NSNumber *momentId;
@property (nonatomic, strong) NSString *momentBody;
@property (nonatomic, strong) NSDate *createdAt;

@end
