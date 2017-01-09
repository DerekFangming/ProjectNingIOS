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

@interface MomentTextController : UITableViewController{
    CGFloat headerCellHeight;
}

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *displayedName;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) NSString *momentBody;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) BOOL likedByCurrentUser;

@property (nonatomic, assign) CGFloat likeCellHeight;

@end
