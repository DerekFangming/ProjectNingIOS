//
//  FriendDetailController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 11/11/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PNService.h"
#import "Utils.h"
#import "FriendOverviewCell.h"
#import "ChatBtnCell.h"
#import "MomentsCell.h"
#import "FriendMomentController.h"

@interface FriendDetailController : UITableViewController{
    UIImageView *tempAvatar;
    UIImageView *fullScreenAvatar;
}

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *displayedName;
@property (nonatomic, strong) UIImage *avatar;

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *gender;

@property (nonatomic, strong) NSMutableArray *friendDetails;

@end
