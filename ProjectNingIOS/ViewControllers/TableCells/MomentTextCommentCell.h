//
//  MomentTextCommentCell.h
//  ProjectNingIOS
//
//  Created by NingFangming on 1/11/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentTextCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentOwnerAvatar;
@property (weak, nonatomic) IBOutlet UILabel *commentOwnerName;
@property (weak, nonatomic) IBOutlet UITextView *commentBody;
@property (weak, nonatomic) IBOutlet UILabel *commentCreatedAt;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
