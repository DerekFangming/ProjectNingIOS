//
//  MomentViewController.h
//  ProjectNingIOS
//
//  Created by Cyan Xie on 2/15/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNService.h"
#import "Utils.h"
#import "QBImagePickerController.h"
#import "MomentCoverCell.h"
#import "MomentTextHeaderCell.h"
#import "PNImageSliderView.h"
#import "PNImageSliderDelegate.h"

@interface MomentViewController : UITableViewController<PNImageSliderDelegate,
                                                        QBImagePickerControllerDelegate,
                                                        UINavigationControllerDelegate,
                                                        UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImage *coverImg;

@property (nonatomic, strong) NSMutableArray *feedList;

@property (strong, nonatomic) UIView *sliderHolder;
@property (strong, nonatomic) PNImageSliderView *imageSliderView;

@end
