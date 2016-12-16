//
//  FriendMomentController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 11/27/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <stdlib.h>
#import "MomentCoverCell.h"
#import "MomentPostCell.h"
#import "Utils.h"
#import "PNService.h"

@interface FriendMomentController : UITableViewController

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *displayedName;
@property (nonatomic, strong) UIImage *avatar;

@property (nonatomic, strong) UIImage *coverImg;

@property (nonatomic, strong) NSDate *checkPoint;
@property (nonatomic, strong) NSMutableArray *momentList;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end
