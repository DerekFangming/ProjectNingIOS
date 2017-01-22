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
    
    selectedRow = -1;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [PNCommentManager getRecentCommentsForCurrentUserWithCommentType:@"Feed"
                                                        andMappingId:self.momentId
                                                            response:^(NSError *error, NSMutableArray *resultList, BOOL liked) {
                                          if(error != nil){
                                              if(![[error localizedDescription] isEqualToString:NO_COMMENT_ERR_MSG]){
                                                  [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                                               from:self];
                                              }
                                          }else{
                                              self.commentList = resultList;
                                              [self.tableView reloadData];
                                          }
                                      }];
    
    [PNCommentManager getRecentCommentsForCurrentUserWithCommentType:@"Feed Like"
                                                        andMappingId:self.momentId
                                                            response:^(NSError *error, NSMutableArray *resultList, BOOL liked) {
                                                                if(error != nil){
                                                                    if(![[error localizedDescription] isEqualToString:NO_COMMENT_ERR_MSG]){
                                                                        [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                                                                     from:self];
                                                                    }
                                                                }else{
                                                                    self.likedList = resultList;
                                                                    self.likedByCurrentUser = liked;
                                                                    [self.tableView reloadData];
                                                                }
                                                            }];
    //Define constants
    tableViewHeight = self.tableView.frame.size.height;
    tableViewWidth = self.tableView.frame.size.width;
    commentInputHeight = 35;
    
    //Create comment input text field
    floatingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableViewWidth, commentInputHeight)];
    floadtingViewOffset = tableViewHeight - commentInputHeight;
    [floatingView setBackgroundColor:GRAY_BG_COLOR];
    
    separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableViewWidth, 1)];
    [separatorView setBackgroundColor: [UIColor colorWithRed: 190/255.0 green:190/255.0 blue:190/255.0 alpha:1]];
    
    commentInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, tableViewWidth - 20, 25)];
    [commentInput setBackgroundColor:[UIColor whiteColor]];
    [commentInput.layer setBorderColor:[UIColor colorWithRed: 230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor];
    [commentInput.layer setBorderWidth:1.0];
    [commentInput setReturnKeyType:UIReturnKeySend];
    commentInput.clipsToBounds = YES;
    commentInput.layer.cornerRadius = 4.0f;
    commentInput.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    commentInput.placeholder = @"Enter comment";
    commentInput.delegate = self;
    
    [floatingView addSubview:separatorView];
    [floatingView addSubview:commentInput];
    [self.view addSubview:floatingView];
    
    
    
    //Keyboard methods
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardDidShow:)
                                                name:UIKeyboardDidShowNotification object:nil];

}

#pragma mark - Section and list -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }else if (section == 1 ){
        return [self.commentList count];
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0){
        return self.headerCellHeight;
    }else if(indexPath.section == 0 && indexPath.row == 1){
        return self.likeCellHeight;
    }else if (indexPath.section == 1){
        return [[self.commentList objectAtIndex:indexPath.row] cellHeight];
    }else{
        return 35;
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
        if([self.likedList count] > 0 || [self.commentList count] > 0){
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
        int picPerRow = (tableViewWidth - 75) / 35;
        int totalRows = ceil((float)[self.likedList count] / (float)picPerRow);
        
        //Add gray background view and calculate cell height if there are comments
        if([self.likedList count] > 0){
            self.likeCellHeight = totalRows * 35 + 9; // rows * 30 + (rows - 1 ) * 5 + 7 * 2
            UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(15, 0, tableViewWidth - 25, self.likeCellHeight)];
            [bgView setBackgroundColor:GRAY_BG_COLOR];
            [cell.contentView addSubview:bgView];
            
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(35, 14, 15, 15)];
            imv.image=[UIImage imageNamed:@"like.png"];
            [cell.contentView addSubview:imv];
        }else{
            self.likeCellHeight = 0;
        }
            
        //Adding images
        for(int i = 0; i < [self.likedList count]; i ++){
            int row = i / picPerRow;
            int col = i % picPerRow;
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(58 + col * 35, 7 + row * 35, 30, 30)];
            //imv.image=[UIImage imageNamed:@"defaultAvatar.jpg"];
            imv.tag = i;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(likeImgClick:)];
            singleTap.numberOfTapsRequired = 1;
            [imv setUserInteractionEnabled:YES];
            [imv addGestureRecognizer:singleTap];
            [cell.contentView addSubview:imv];
            
            PNComment *comment = [self.likedList objectAtIndex: i];
            if(comment.ownerAvatar == nil){
                [PNImageManager getSingletonImgForUser:comment.ownerId
                                           withImgType:AVATAR
                                              response:^(UIImage *img, NSError *err) {
                                                  if(err != nil){
                                                      comment.ownerAvatar = [UIImage imageNamed:@"defaultAvatar.jpg"];
                                                  }else{
                                                      comment.ownerAvatar = img;
                                                  }
                                                  imv.image = comment.ownerAvatar;
                                              }];
            }else{
                imv.image = comment.ownerAvatar;
            }
            
        }
        
        //Add seperator only when both like and comment exist
        if([self.likedList count] == 0 || [self.commentList count] == 0){
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width , 0, 0);
        }else{
            cell.separatorInset = UIEdgeInsetsMake(0, 15 , 0, 10);
        }
        return cell;
        
    }else if (indexPath.section == 1){
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
            cell.separatorInset = UIEdgeInsetsMake(0, tableViewWidth , 0, 0);
        }else{
            cell.separatorInset = UIEdgeInsetsMake(0, 30, 0, 15);
        }
        
        if(indexPath.row == 0){
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(35, 14, 15, 15)];
            imv.image=[UIImage imageNamed:@"writeComment.png"];
            [cell.contentView addSubview:imv];
        }
        
        if(comment.ownerAvatar == nil){
            [PNImageManager getSingletonImgForUser:comment.ownerId
                                       withImgType:AVATAR
                                          response:^(UIImage *img, NSError *err) {
                                              if(err != nil){
                                                  comment.ownerAvatar = [UIImage imageNamed:@"defaultAvatar.jpg"];
                                              }else{
                                                  comment.ownerAvatar = img;
                                              }
                                              [cell.commentOwnerAvatar setImage: comment.ownerAvatar];
                                          }];
        }else{
            [cell.commentOwnerAvatar setImage: comment.ownerAvatar];
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentTextFooterCell"
                                                                      forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"momentTextFooterCell"];
        }
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width , 0, 0);        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row selected");
    if(keyboardIsUp){
        keyboardIsUp = NO;
        commentInput.placeholder = @"Enter comment";
        [commentInput resignFirstResponder];
        [UIView animateWithDuration:0.3f animations:^{
            floatingView.frame = CGRectOffset(floatingView.frame, 0, keyboardHeight + 150);
        } completion:^(BOOL finished) {
            NSLog(@"Done!");
        }];
    }else if(indexPath.section == 1){
        NSString *name = [[self.commentList objectAtIndex:indexPath.row] ownerDisplayedName];
        commentInput.placeholder = [@"Reply to " stringByAppendingString: name];
        selectedRow = indexPath.row;
        [commentInput becomeFirstResponder];
    }
}

#pragma mark - Like and comment button -

- (void)likeButtonTapped:(UIButton *)sender{
    if(self.likedByCurrentUser){
        [PNCommentManager deleteCommentWithId:self.momentId
                                     response:^(NSError *error) {
                                         if(error != nil){
                                             [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                                          from: self];
                                         }else{
                                             [sender setBackgroundImage:[UIImage imageNamed:@"notLike.png"] forState:UIControlStateNormal];
                                             self.likedByCurrentUser = NO;
                                             NSNumber *currentUserId = [[PNUser currentUser] userId];
                                             for(PNComment *comment in self.commentList){
                                                 if(comment.ownerId == currentUserId){
                                                     [self.commentList removeObject:comment];
                                                     break;
                                                 }
                                             }
                                             [self.tableView reloadData];
                                         }
                                     }];
    }else{
        [PNCommentManager createComment:@"like"
                         forCommentType:@"Feed Like"
                           andMappingId:self.momentId
                           mentionsUser:nil
                               response:^(NSError *error, NSNumber *commentId) {
                                   if(error != nil){
                                       [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                                    from: self];
                                   }else{
                                       [sender setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
                                       self.likedByCurrentUser = YES;
                                       PNComment * comment = [[PNComment alloc] initWithCommentId:commentId
                                                                                          andBody:@"like"
                                                                                          andType:@"Feed Like"
                                                                                     andMappingId:self.momentId
                                                                                       andOwnerId:[[PNUser currentUser] userId]
                                                                                          andDate:[NSDate date]];
                                       [self.likedList addObject:comment];
                                       [self.tableView reloadData];
                                   }
                               }];
    }
}

- (void)commentButtonTapped:(UIButton *)sender{
    if(!keyboardIsUp && !keyboardShowingHiding){
        [commentInput becomeFirstResponder];
    }
}

#pragma mark - Comment input text field -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!keyboardShowingHiding && !keyboardIsUp){
        NSLog(@"recal %f", self.tableView.contentOffset.y);
        CGRect frame = floatingView.frame;
        frame.origin.y = scrollView.contentOffset.y + floadtingViewOffset;
        floatingView.frame = frame;
        
        [self.view bringSubviewToFront:floatingView];
    }else if (keyboardAdjusting){
        NSLog(@"recal- kb up %f", self.tableView.contentOffset.y);
        CGRect frame = floatingView.frame;
        frame.origin.y = scrollView.contentOffset.y + tableViewHeight - commentInputHeight - keyboardHeight;
        floatingView.frame = frame;
        
        [self.view bringSubviewToFront:floatingView];
    }else if (!keyboardShowingHiding){
        NSLog(@"remove keyboard");
        keyboardShowingHiding = YES;
        commentInput.placeholder = @"Enter comment";
        [commentInput resignFirstResponder];
        [UIView animateWithDuration:0.3f animations:^{
            floatingView.frame = CGRectOffset(floatingView.frame, 0, keyboardHeight);
        } completion:^(BOOL finished) {
            keyboardIsUp = NO;
            keyboardShowingHiding = NO;
        }];
    }else{
        //NSLog(@"scroll");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"return pressed");
    keyboardIsUp = NO;
    keyboardShowingHiding = YES;
    [commentInput resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        
        floatingView.frame = CGRectOffset(floatingView.frame, 0, keyboardHeight);
    } completion:^(BOOL finished) {
        
        keyboardShowingHiding = NO;
    }];
    
    //NSLog(commentInput.text);
    commentInput.text = @"";
    return YES;
}

//- (void) textFieldDidBeginEditing:(UITextField *)textField {
//
//}

#pragma mark - Keyboard handlding methods -

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSLog(@"will show");
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    keyboardShowingHiding = YES;
    if(keyboardHeight == 0){
        NSDictionary* keyboardInfo = [notification userInfo];
        CGSize kbSize = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        keyboardHeight = kbSize.height;
    }
    NSLog(@"%f", keyboardHeight);
    
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSLog(@"did show");
    keyboardAdjusting = YES;
    keyboardIsUp = YES;
    NSLog(@"This row is selected %d", selectedRow);
    [UIView animateWithDuration:0.4f animations:^{
        if(selectedRow + 1 == [self.commentList count] || selectedRow == -1){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]
                                  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }else{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow + 1 inSection:1]
                                  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    } completion:^(BOOL finished) {
        NSLog(@"did show done %f", self.tableView.contentOffset.y);
        selectedRow = -1;
        keyboardAdjusting = NO;
        keyboardShowingHiding = NO;
    }];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
