//
//  CommentInputController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 2/3/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "PNService.h"

@interface CommentInputController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) NSNumber *momentId;

@property (strong, nonatomic) UITextView *commentInput;
@property (strong, nonatomic) NSString *unsentComment;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBtn;

@end
