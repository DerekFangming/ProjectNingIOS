//
//  FriendsDetailViewController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 11/11/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PNService.h"
#import "Utils.h"
#import "FriendDetailTableCell.h"

@interface FriendsDetailViewController : UITableViewController

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *displayedName;
@property (nonatomic, strong) UIImage *avatar;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *whatsUp;

@property (nonatomic, strong) NSMutableArray *friendDetails;

@end
