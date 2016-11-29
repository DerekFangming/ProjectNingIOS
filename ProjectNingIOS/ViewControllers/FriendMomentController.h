//
//  FriendMomentController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 11/27/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentCoverCell.h"
#import "Utils.h"

@interface FriendMomentController : UITableViewController

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *displayedName;
@property (nonatomic, strong) UIImage *avatar;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end
