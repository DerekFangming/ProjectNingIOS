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

@interface MomentViewController : UITableViewController<QBImagePickerControllerDelegate,
                                                        UINavigationControllerDelegate,
                                                        UIImagePickerControllerDelegate>{
    NSInteger row;
}

@property (nonatomic, strong) UIImage *coverImg;

@end
