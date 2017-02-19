//
//  MomentViewController.h
//  ProjectNingIOS
//
//  Created by Cyan Xie on 2/15/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNService.h"
#import "QBImagePickerController.h"
#import "MomentCoverCell.h"

@interface MomentViewController : UITableViewController<QBImagePickerControllerDelegate,
                                                        UINavigationControllerDelegate,
                                                        UIImagePickerControllerDelegate>{
    NSInteger row;
}

@end
