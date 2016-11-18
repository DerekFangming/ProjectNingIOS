//
//  FriendDetailTableCell.h
//  ProjectNingIOS
//
//  Created by NingFangming on 11/17/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendDetailTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *friendDetailAvatar;
@property (strong, nonatomic) IBOutlet UILabel *friendDisplayedName;
@property (strong, nonatomic) IBOutlet UILabel *friendUserId;
@property (strong, nonatomic) IBOutlet UILabel *friendNickName;

@end
