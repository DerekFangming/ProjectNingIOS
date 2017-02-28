//
//  PlainTextCommentCell.h
//  ProjectNingIOS
//
//  Created by Cyan Xie on 2/28/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlainTextCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *commentText;

@end
