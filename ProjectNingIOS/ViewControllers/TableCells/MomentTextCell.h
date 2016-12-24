//
//  MomentTextCell.h
//  ProjectNingIOS
//
//  Created by NingFangming on 11/30/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITextView *momentBody;

@end
