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
    
    //Create and process images, update navigation bar if it's segued from comment image controller
    if(self.seguedFromImageController){
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(dismissSegue:)];
        doneBtn.tintColor = GREEN_COLOR;
        self.navigationItem.leftBarButtonItem = doneBtn;
        NSInteger imageCount = [self.imageList count];
        if(imageCount == 1){
            imageSectionHeight = (tableViewWidth - 100) * 0.66;
            imageSectionViewHeight = imageSectionHeight;
        }else if(imageCount <= 3){
            imageSectionHeight = (tableViewWidth - 100) * 0.33;
            imageSectionViewHeight = imageSectionHeight;
        }else if(imageCount <= 6){
            imageSectionHeight = (tableViewWidth - 100) * 0.66;
            imageSectionViewHeight = imageSectionHeight / 2;
        }else{
            imageSectionHeight = tableViewWidth - 100;
            imageSectionViewHeight = imageSectionHeight / 3;
        }
        
    }
    
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
    //Section 0 is header and like cell.
    //Section 1 is all the text comment cells
    //Section 2 is the blank fake cell
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
        return self.headerCellHeight + imageSectionHeight;
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
            cell = [[MomentTextHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentTextHeaderCell"];
        }
        //Remove seperator?
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        
        [cell.avatar setImage: self.avatar];
        cell.nameLabel.text = self.displayedName;
        cell.nameLabel.textColor = PURPLE_COLOR;
        cell.momentTextView.text = [self.momentBody stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
        [cell.momentTextView sizeToFit];
        [cell.momentTextView layoutIfNeeded];
        CGSize size = [cell.momentTextView
                       sizeThatFits:CGSizeMake(cell.momentTextView.frame.size.width, CGFLOAT_MAX)];
        self.headerCellHeight = size.height + 45;
        
        [cell.momentTextView setContentSize:size];
        cell.dateLabel.text = [Utils processDateToText:self.createdAt withAbbreviation:NO];
        
        int imageCount = [self.imageList count];
        //int totalRows = ceil( imageCount/ 3);
        int picPerRow = imageCount == 1 ? 1 : (imageCount == 2 || imageCount == 4) ? 2 : 3;
        for(int i = 0; i < imageCount; i ++){
            int row = i / picPerRow;
            int col = i % picPerRow;
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(65 + col * imageSectionViewHeight,
                                                                            row * imageSectionViewHeight + size.height + 25,
                                                                            imageSectionViewHeight - 10,
                                                                            imageSectionViewHeight - 10)];
            imv.tag = i;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(commentImgClick:)];
            singleTap.numberOfTapsRequired = 1;
            [imv setUserInteractionEnabled:YES];
            [imv addGestureRecognizer:singleTap];
            [cell.contentView addSubview:imv];
            
            PNImage *image = [self.imageList objectAtIndex:i];
            if(image.image){
                imv.image = image.image;
            }else{
                [PNImageManager downloadImageWithId:image.imageId
                                           response:^(UIImage *img, NSError *error) {
                                               if(error == nil){
                                                   imv.image = img;
                                                   image.image = img;
                                               }
                                           }];
            }
        }
        
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
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(nameLabelTapped:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [cell.commentOwnerName addGestureRecognizer:tapGestureRecognizer];
        cell.commentOwnerName.userInteractionEnabled = YES;
        
        NSMutableAttributedString *attrBody;
        if (comment.mentionedUserId != nil){
            //Create user obj here
            NSString *body = [NSString stringWithFormat:@"@%@%@%@", comment.mentionedUserName, @": ", comment.commentBody];
            attrBody = [[NSMutableAttributedString alloc]initWithString:body attributes:@{ @"commentTag" : @(YES) }];
            [attrBody addAttribute:NSForegroundColorAttributeName value:PURPLE_COLOR
                             range:NSMakeRange(1, comment.mentionedUserName.length)];
            cell.commentBody.attributedText =attrBody;
        }else{
            attrBody = [[NSMutableAttributedString alloc]initWithString:comment.commentBody
                                                             attributes:@{ @"commentTag" : @(YES) }];
            cell.commentBody.attributedText =attrBody;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textTapped:)];
        tap.numberOfTapsRequired = 1;
        [cell.commentBody addGestureRecognizer:tap];
        cell.commentBody.textContainer.lineFragmentPadding = 0;
        cell.commentBody.textContainerInset = UIEdgeInsetsZero;
        [cell.commentBody sizeToFit];
        [cell.commentBody layoutIfNeeded];
        CGSize size = [cell.commentBody
                       sizeThatFits:CGSizeMake(cell.commentBody.frame.size.width, CGFLOAT_MAX)];
        comment.cellHeight = size.height + 31;
        cell.commentCreatedAt.text = [Utils processDateToText:[[self.commentList objectAtIndex:indexPath.row] createdAt]
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
            floatingView.frame = CGRectOffset(floatingView.frame, 0, keyboardHeight);
        } completion:^(BOOL finished) {
            NSLog(@"Done!");
        }];
    }else if(indexPath.section == 1){
        PNComment *comment = [self.commentList objectAtIndex:indexPath.row];
        if(comment.ownerId == [[PNUserManager currentUser] userId]){
            [self showDeleteCommentConfirmationForComment:comment];
        }else{
            commentInput.placeholder = [@"Reply to " stringByAppendingString: comment.ownerDisplayedName];
            selectedRow = indexPath.row;
            mentionedUser = comment.ownerId;
            [commentInput becomeFirstResponder];
        }
    }
}

#pragma mark - Like and comment button -

- (void)likeButtonTapped:(UIButton *)sender{
    if(self.likedByCurrentUser){
        PNComment *commentByCurrentUser;
        NSNumber *currentUserId = [[PNUserManager currentUser] userId];
        for(PNComment *comment in self.likedList){
            if(comment.ownerId == currentUserId){
                commentByCurrentUser = comment;
                break;
            }
        }
        [PNCommentManager deleteCommentWithId:commentByCurrentUser.commentId
                                     response:^(NSError *error) {
                                         if(error != nil){
                                             [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                                          from: self];
                                         }else{
                                             [sender setBackgroundImage:[UIImage imageNamed:@"notLike.png"] forState:UIControlStateNormal];
                                             self.likedByCurrentUser = NO;
                                             [self.likedList removeObject:commentByCurrentUser];
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
                                                                                       andOwnerId:[[PNUserManager currentUser] userId]
                                                                                          andDate:[NSDate date]];
                                       if(self.likedList == nil)
                                           self.likedList = [[NSMutableArray alloc] init];
                                       [self.likedList addObject:comment];
                                       [self.tableView reloadData];
                                   }
                               }];
    }
}

- (void)commentButtonTapped:(UIButton *)sender{
    if(!keyboardIsUp){
        NSLog(@"%ld", (long)floadtingViewOffset);
        NSLog(@"%f", floatingView.frame.origin.x);
        mentionedUser = nil;
        [commentInput becomeFirstResponder];
    }
}

#pragma mark - Comment input text field -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!keyboardIsUp){
        //NSLog(@"recal %f", self.tableView.contentOffset.y);
        CGRect frame = floatingView.frame;
        frame.origin.y = scrollView.contentOffset.y + floadtingViewOffset;
        floatingView.frame = frame;
        
    }else if (keyboardAdjusting){
        //NSLog(@"recal- kb up %f", self.tableView.contentOffset.y);
        CGRect frame = floatingView.frame;
        //NSLog(@"adjust keyboard");
        frame.origin.y = scrollView.contentOffset.y + tableViewHeight - commentInputHeight - keyboardHeight;
        floatingView.frame = frame;
        
    }else if (keyboardIsUp){
        //NSLog(@"remove keyboard");
        commentInput.placeholder = @"Enter comment";
        [commentInput resignFirstResponder];
        [UIView animateWithDuration:0.3f animations:^{
            floatingView.frame = CGRectOffset(floatingView.frame, 0, keyboardHeight);
        } completion:^(BOOL finished) {
            keyboardIsUp = NO;
        }];
    }else{
        //NSLog(@"scroll");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"return pressed");
    keyboardIsUp = NO;
    [commentInput resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        
        floatingView.frame = CGRectOffset(floatingView.frame, 0, keyboardHeight);
    } completion:^(BOOL finished) {
        
    }];
    
    NSString *clickedUserName = [commentInput.placeholder
                                   stringByReplacingOccurrencesOfString:@"Reply to " withString:@""];
    NSString *commentBody = commentInput.text;
    [PNCommentManager createComment:commentBody
                     forCommentType:@"Feed"
                       andMappingId:self.momentId
                       mentionsUser:mentionedUser
                           response:^(NSError *error, NSNumber *commentId) {
                               if(error != nil){
                                   [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                                from: self];
                               }else{
                                   PNComment * comment = [[PNComment alloc] initWithCommentId:commentId
                                                                                      andBody:commentBody
                                                                                      andType:@"Feed"
                                                                                 andMappingId:self.momentId
                                                                                   andOwnerId:[[PNUserManager currentUser] userId]
                                                                                      andDate:[NSDate date]];
                                   comment.mentionedUserId = mentionedUser;
                                   comment.mentionedUserName = clickedUserName;
                                   comment.ownerDisplayedName = [[PNUserManager currentUser] username];
                                   if (self.commentList == nil)
                                       self.commentList = [[NSMutableArray alloc] init];
                                   [self.commentList addObject:comment];
                                   [self.tableView reloadData];
                               }
                           }];
    commentInput.placeholder = @"Enter comment";
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
    [self.view sendSubviewToBack:floatingView];
    if(keyboardHeight == 0){
        NSDictionary* keyboardInfo = [notification userInfo];
        CGSize kbSize = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        keyboardHeight = kbSize.height;
    }
    
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSLog(@"did show");
    keyboardAdjusting = YES;
    keyboardIsUp = YES;
    
    
    CGRect frame = floatingView.frame;
    frame.origin.y = self.tableView.contentOffset.y + tableViewHeight - commentInputHeight - keyboardHeight;
    floatingView.frame = frame;
    [self.view bringSubviewToFront:floatingView];
    
    [UIView animateWithDuration:0.3f animations:^{
        if(selectedRow + 1 == [self.commentList count] || selectedRow == -1){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]
                                  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }else{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow + 1 inSection:1]
                                  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    } completion:^(BOOL finished) {
        //NSLog(@"did show done %f", self.tableView.contentOffset.y);
        selectedRow = -1;
        keyboardAdjusting = NO;
    }];
}

#pragma mark - Comment user tap handling -

- (void)nameLabelTapped:(UITapGestureRecognizer *)recognizer {
    UITextField *nameLabel = (UITextField *)recognizer.view;
    
    if(keyboardIsUp){
        keyboardIsUp = NO;
        commentInput.placeholder = @"Enter comment";
        [commentInput resignFirstResponder];
        [UIView animateWithDuration:0.3f animations:^{
            floatingView.frame = CGRectOffset(floatingView.frame, 0, keyboardHeight);
        } completion:^(BOOL finished) {
            //NSLog(@"Done!");
        }];
    }else{
        MomentTextCommentCell *cell = (MomentTextCommentCell *) nameLabel.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        PNComment *comment = [self.commentList objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"momentToFriendSegue" sender:comment];
    }
}


- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    UITextView *textView = (UITextView *)recognizer.view;
    
    // Location of the tap in text-container coordinates
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    // Find the character that's been tapped on
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    if (characterIndex < textView.textStorage.length) {
        
        NSRange range;
        //id value = [textView.attributedText attribute:@"nameSegueTag" atIndex:characterIndex effectiveRange:&range];
        [textView.attributedText attribute:@"commentTag" atIndex:characterIndex effectiveRange:&range];
        
        //NSLog(@"%@, %d, %d", value, range.location, range.length);
        MomentTextCommentCell *cell = (MomentTextCommentCell *) textView.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        PNComment *comment = [self.commentList objectAtIndex:indexPath.row];
        
        if(keyboardIsUp){
            keyboardIsUp = NO;
            commentInput.placeholder = @"Enter comment";
            [commentInput resignFirstResponder];
            [UIView animateWithDuration:0.3f animations:^{
                floatingView.frame = CGRectOffset(floatingView.frame, 0, keyboardHeight);
            } completion:^(BOOL finished) {
                //NSLog(@"Done!");
            }];
        }else if(range.location == 1){
            PNComment *fakedComment = [[PNComment alloc] initWithCommentId:nil
                                                                   andBody:nil
                                                                   andType:nil
                                                              andMappingId:nil
                                                                andOwnerId:comment.mentionedUserId
                                                                   andDate:nil];
            fakedComment.ownerDisplayedName = comment.mentionedUserName;
            [self performSegueWithIdentifier:@"momentToFriendSegue" sender:fakedComment];
            //NSLog(comment.mentionedUserName);
        }else if([comment ownerId] == [[PNUserManager currentUser] userId]){
            [self showDeleteCommentConfirmationForComment:comment];
        }else{
            NSString *name = [comment ownerDisplayedName];
            commentInput.placeholder = [@"Reply to " stringByAppendingString: name];
            selectedRow = indexPath.row;
            mentionedUser = comment.ownerId;
            [commentInput becomeFirstResponder];
        }
    }
}

#pragma mark - Helpers -

- (void)showDeleteCommentConfirmationForComment:(PNComment *) comment{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Delete my comment "
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* delete = [UIAlertAction
                         actionWithTitle:@"Delete"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [PNCommentManager deleteCommentWithId:comment.commentId
                                                          response:^(NSError *error) {
                                                              if(error != nil){
                                                                  [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                                                               from: self];
                                                              }else{
                                                                  [self.commentList removeObject:comment];
                                                                  [self.tableView reloadData];
                                                              }
                                                          }];
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [delete setValue:[UIColor redColor] forKey:@"titleTextColor"];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:delete];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

#pragma mark - Image click events -

- (void)likeImgClick:(UITapGestureRecognizer *)recognizer{
    PNComment *comment = [self.likedList objectAtIndex:recognizer.view.tag];
    [self performSegueWithIdentifier:@"momentToFriendSegue" sender:comment];
    //NSLog(@"%d", recognizer.view.tag);
}

- (void)commentImgClick:(UITapGestureRecognizer *)recognizer{
    
    self.imageSliderView = [[PNImageSliderView alloc] initWithInitialIndex:((UIImageView *)recognizer.view).tag
                                                                  pnImages:self.imageList];
    self.imageSliderView.delegate = self;
    self.imageSliderView.translatesAutoresizingMaskIntoConstraints = NO;
    CGRect point=[self.view convertRect:recognizer.view.bounds fromView:recognizer.view];
    
    self.sliderHolder = [[UIView alloc] initWithFrame:point];
    [self.sliderHolder setBackgroundColor:[UIColor blackColor]];
    self.sliderHolder.clipsToBounds = YES;
    
    [self.sliderHolder addSubview: self.imageSliderView];
    
    NSArray *imageSliderViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageSliderView]-0-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:@{@"imageSliderView": self.imageSliderView}];
    
    [self.sliderHolder addConstraints:imageSliderViewHConstraints];
    
    
    
    NSArray *imageSliderViewVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageSliderView]-0-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:@{@"imageSliderView": self.imageSliderView}];
    
    [self.sliderHolder addConstraints:imageSliderViewVConstraints];
    
    [self.navigationController.view addSubview:self.sliderHolder];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.sliderHolder setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
    } completion:^(BOOL finished) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 30,
                                                                   self.view.bounds.size.height - 40, 60, 25)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [UIFont boldSystemFontOfSize: 14.0f];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [UIColor whiteColor];
        [self.sliderHolder addSubview:self.dateLabel];
        self.dateLabel.text = [NSString stringWithFormat:@"%d/%d",
                               ((UIImageView *)recognizer.view).tag + 1, [self.imageList count]];
    }];
    
}

- (void)imageSliderViewImageDidSwitchToIndex:(NSInteger)index totalCount:(NSInteger)count{
    self.dateLabel.text = [NSString stringWithFormat:@"%d/%d", index + 1, count];
}

- (void)imageSliderViewSingleTap:(UITapGestureRecognizer *)tap{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self.sliderHolder removeFromSuperview];
    self.imageSliderView = nil;
    self.sliderHolder = nil;
    self.dateLabel = nil;
}
#pragma mark - Segues -

- (void) dismissSegue: (UIBarButtonItem*)btn{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"momentToFriendSegue"]) {
        PNComment *comment = sender;
        FriendDetailController *destVC = segue.destinationViewController;
        destVC.userId = comment.ownerId;
        destVC.displayedName = comment.ownerDisplayedName;
        destVC.avatar = comment.ownerAvatar;
    }
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
