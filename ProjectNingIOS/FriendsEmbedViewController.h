//
//  FriendsEmbedViewController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 11/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsEmbedViewController : UITableViewController

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *avatar;

@property (weak, nonatomic) IBOutlet UIImageView *friendDetailAvatar;
@property (weak, nonatomic) IBOutlet UILabel *friendDisplayedName;
@property (weak, nonatomic) IBOutlet UILabel *friendUserId;
@property (weak, nonatomic) IBOutlet UILabel *friendNickName;

@end
