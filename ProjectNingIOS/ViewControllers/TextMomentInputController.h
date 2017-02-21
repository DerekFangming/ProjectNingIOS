//
//  TextMomentInputController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 2/19/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNService.h"
#import "Utils.h"

@interface TextMomentInputController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) UITextView *commentInput;
@property (strong, nonatomic) NSString *unsentComment;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBtn;

@end
