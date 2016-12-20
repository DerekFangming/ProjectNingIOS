//
//  MomentImageCell.h
//  ProjectNingIOS
//
//  Created by NingFangming on 12/19/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UITextView *momentBody;
@end
