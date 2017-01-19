//
//  MomentTextController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 12/26/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNService.h"
#import "Utils.h"
#import "MomentTextHeaderCell.h"
#import "MomentTextCommentCell.h"

@interface MomentTextController : UITableViewController <UITextFieldDelegate>{
    UIView *floatingView;
    UIView *separatorView;
    UITextField *commentInput;
    
    NSInteger floadtingViewOffset;
    UIEdgeInsets tableviewContentInsets;
    
    CGFloat keyboardHeight;
    CGFloat commentInputHeight;
    CGFloat tableViewHeight;
    CGFloat tableViewWidth;
    
    BOOL keyboardShowingHiding;
    BOOL keyboardIsUp;
    BOOL keyboardAdjusting;
}

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *displayedName;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) NSNumber *momentId;
@property (nonatomic, strong) NSString *momentBody;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, assign) BOOL likedByCurrentUser;

@property (nonatomic, strong) NSMutableArray *likedList;
@property (nonatomic, strong) NSMutableArray *commentList;

//@property (nonatomic, assign) int commentLikeCount; // testing only
//@property (nonatomic, assign) int commentCount; // testing only
@property (nonatomic, assign) CGFloat likeCellHeight;
@property (nonatomic, assign) CGFloat headerCellHeight;

@end
