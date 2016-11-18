//
//  FriendsDetailViewController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 11/11/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PNService.h"
#import "FriendDetailTableCell.h"

@interface FriendsDetailViewController : UITableViewController

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *avatar;




@end
