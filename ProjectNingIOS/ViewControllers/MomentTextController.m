//
//  MomentTextController.m
//  ProjectNingIOS
//
//  Created by NingFangming on 12/26/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "MomentTextController.h"

@interface MomentTextController ()

@end

@implementation MomentTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.likeCellHeight = 44;
    //self.commentLikeCount = 0;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Section and list -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return self.headerCellHeight;
    }else if(indexPath.row == 1){
        return self.likeCellHeight;
    }else{
        return 45;
    }
}

#pragma mark - Table cell handling -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        MomentTextHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentTextHeaderCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[MomentTextHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentImageCell"];
        }
        //Remove seperator?
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        
        [cell.avatar setImage: self.avatar];
        cell.nameLabel.text = self.displayedName;
        cell.nameLabel.textColor = PURPLE_COLOR;
        cell.momentTextField.text = [self.momentBody stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
        [cell.momentTextField sizeToFit];
        [cell.momentTextField layoutIfNeeded];
        CGSize size = [cell.momentTextField
                       sizeThatFits:CGSizeMake(cell.momentTextField.frame.size.width, CGFLOAT_MAX)];
        self.headerCellHeight = size.height + 45;
        
        [cell.momentTextField setContentSize:size];
        cell.dateLabel.text = [self processDateToText:self.createdAt];
        
        //Like button
        if(self.likedByCurrentUser) [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        else [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"notLike.png"] forState:UIControlStateNormal];
        
        [cell.likeBtn addTarget:self action:@selector(okButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //Triangle view
        if(self.commentLikeCount > 0 || self.commentCount > 0){
            UIBezierPath* trianglePath = [UIBezierPath bezierPath];
            [trianglePath moveToPoint:CGPointMake(0, 5)];
            [trianglePath addLineToPoint:CGPointMake(5,0)];
            [trianglePath addLineToPoint:CGPointMake(10, 5)];
            [trianglePath closePath];
            
            CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
            [triangleMaskLayer setPath:trianglePath.CGPath];
            
            UIView *triangleView = [[UIView alloc] initWithFrame:CGRectMake(20,self.headerCellHeight - 5, 10, 5)];
            
            triangleView.backgroundColor = GRAY_BG_COLOR;
            triangleView.layer.mask = triangleMaskLayer;
            triangleView.tag = 1;
            [cell.contentView addSubview:triangleView];
        }else if ([cell.contentView subviews]){
            UIView * triagnleView = [cell.contentView viewWithTag:1];
            [triagnleView removeFromSuperview];
        }
        return cell;
    }else if (indexPath.row == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentTextLikeCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentTextLikeCell"];
        }
        
        //Remove background view and images
        if ([cell.contentView subviews]){
            for (UIView *subview in [cell.contentView subviews]) {
                [subview removeFromSuperview];
            }
        }
                                                                   
        //Calculate image information base on cell width, etc
        int cellwidth = (int) roundf(cell.bounds.size.width);
        int picPerRow = (cellwidth - 75) / 35;
        int totalRows = ceil((float)self.commentLikeCount / (float)picPerRow);
        
        //Add gray background view and calculate cell height if there are comments
        if(self.commentLikeCount > 0){
            self.likeCellHeight = totalRows * 35 + 9; // rows * 30 + (rows - 1 ) * 5 + 7 * 2
            UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(15, 0, cell.bounds.size.width - 25, self.likeCellHeight)];
            [bgView setBackgroundColor:GRAY_BG_COLOR];
            [cell.contentView addSubview:bgView];
        }
            
        //Adding images
        for(int i = 0; i < self.commentLikeCount; i ++){
            int row = i / picPerRow;
            int col = i % picPerRow;
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(60 + col * 35, 7 + row * 35, 30, 30)];
            imv.image=[UIImage imageNamed:@"defaultAvatar.jpg"];
            imv.tag = i;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(likeImgClick:)];
            singleTap.numberOfTapsRequired = 1;
            [imv setUserInteractionEnabled:YES];
            [imv addGestureRecognizer:singleTap];
            [cell.contentView addSubview:imv];
        }
        
        //Add seperator only when both like and comment exist
        if(self.commentLikeCount == 0 || self.commentCount == 0){
            cell.separatorInset = UIEdgeInsetsMake(10, cell.bounds.size.width , 0, 0);
        }
        return cell;
        
    }else{
        return nil;
    }
}

#pragma mark - Like and comment button events -

- (void)okButtonTapped:(UIButton *)sender{
    if(self.likedByCurrentUser){
        [sender setBackgroundImage:[UIImage imageNamed:@"notLike.png"] forState:UIControlStateNormal];
        self.likedByCurrentUser = NO;
        self.commentLikeCount -= 1;
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        self.likedByCurrentUser = YES;
        self.commentLikeCount += 1;
    }
    [self.tableView reloadData];
}

#pragma mark - Helpers -

- (NSString *) processDateToText: (NSDate *) date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
    NSString *month = [Utils monthToString:[components month] withAbbreviation:NO];
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@, %@", month, [@([components day]) stringValue],
                         [@([components year]) stringValue]];
    dateStr = [NSString stringWithFormat:@"%@ %@:%@", dateStr, [@([components hour]) stringValue],
               [@([components minute]) stringValue]];
    return dateStr;
}

-(void)likeImgClick:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"%d", recognizer.view.tag);
}

@end
