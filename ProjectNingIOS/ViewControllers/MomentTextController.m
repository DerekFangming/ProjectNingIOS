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
    
    //self.commentCount = 4;
    //self.commentLikeCount = 2;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [PNCommentManager getRecentCommentsForCurrentUserWithCommentType:@"Feed"
                                                        andMappingId:self.momentId
                                                            response:^(NSError *error, NSMutableArray *resultList) {
                                          if(error != nil){
                                              [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                                           from:self];
                                          }else{
                                              self.commentList = resultList;
                                              [self.tableView reloadData];
                                          }
                                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Section and list -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }else{
        return [self.commentList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0){
        return self.headerCellHeight;
    }else if(indexPath.section == 0 && indexPath.row == 1){
        return self.likeCellHeight;
    }else{
        return [[self.commentList objectAtIndex:indexPath.row] cellHeight];
    }
}

#pragma mark - Table cell handling -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0){
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
        cell.dateLabel.text = [self processDateToText:self.createdAt withAbbreviation:NO];
        
        //Like button
        if(self.likedByCurrentUser) [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        else [cell.likeBtn setBackgroundImage:[UIImage imageNamed:@"notLike.png"] forState:UIControlStateNormal];
        
        [cell.likeBtn addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //Comment button
        [cell.commentBtn addTarget:self action:@selector(commentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //Triangle view
        if(self.commentLikeCount > 0 || [self.commentList count] > 0){
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
    }else if (indexPath.section == 0 && indexPath.row == 1){
        
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
            
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(35, 14, 15, 15)];
            imv.image=[UIImage imageNamed:@"like.png"];
            [cell.contentView addSubview:imv];
        }else{
            self.likeCellHeight = 0;
        }
            
        //Adding images
        for(int i = 0; i < self.commentLikeCount; i ++){
            int row = i / picPerRow;
            int col = i % picPerRow;
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(58 + col * 35, 7 + row * 35, 30, 30)];
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
        if(self.commentLikeCount == 0 || [self.commentList count] == 0){
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width , 0, 0);
        }else{
            cell.separatorInset = UIEdgeInsetsMake(0, 15 , 0, 10);
        }
        return cell;
        
    }else{
        MomentTextCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentTextCommentCell"
                                                                      forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[MomentTextCommentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"momentTextCommentCell"];
        }
        
        [cell.bgView setBackgroundColor:GRAY_BG_COLOR];
        PNComment *comment = [self.commentList objectAtIndex:indexPath.row];
        cell.commentOwnerName.text = [comment ownerDisplayedName];
        cell.commentOwnerName.textColor = PURPLE_COLOR;
        cell.commentBody.text = [comment commentBody];
        cell.commentBody.textContainer.lineFragmentPadding = 0;
        cell.commentBody.textContainerInset = UIEdgeInsetsZero;
        [cell.commentBody sizeToFit];
        [cell.commentBody layoutIfNeeded];
        CGSize size = [cell.commentBody
                       sizeThatFits:CGSizeMake(cell.commentBody.frame.size.width, CGFLOAT_MAX)];
        comment.cellHeight = size.height + 31;
        cell.commentCreatedAt.text = [self processDateToText:[[self.commentList objectAtIndex:indexPath.row] createdAt]
                                            withAbbreviation:YES];
        
        if(indexPath.row + 1 == [self.commentList count]){
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width , 0, 0);
        }else{
            cell.separatorInset = UIEdgeInsetsMake(0, 30, 0, 15);
        }
        
        if(indexPath.row == 0){
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(35, 14, 15, 15)];
            imv.image=[UIImage imageNamed:@"writeComment.png"];
            [cell.contentView addSubview:imv];
        }
        return cell;
    }
}

#pragma mark - Like and comment button events -

- (void)likeButtonTapped:(UIButton *)sender{
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

- (void)commentButtonTapped:(UIButton *)sender{
    //self.commentCount += 1;
    //[self.tableView reloadData];
}

#pragma mark - Helpers -

- (NSString *) processDateToText: (NSDate *) date withAbbreviation: (BOOL) abbrev{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
    NSString *month = [Utils monthToString:[components month] withAbbreviation:abbrev];
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
