//
//  MomentViewController.m
//  ProjectNingIOS
//
//  Created by Cyan Xie on 2/15/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import "MomentViewController.h"

@implementation MomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [PNImageManager getSingletonImgForUser:[[PNUserManager currentUser] userId]
                               withImgType:COVER_IMG
                                  response:^(UIImage *img, NSError *err) {
                                      if(err != nil){
                                          int randNum = arc4random_uniform(4);
                                          NSString *imgName = [@"coverImg"
                                                               stringByAppendingString:[NSString stringWithFormat:@"%d", randNum]];
                                          self.coverImg = [UIImage imageNamed:[imgName stringByAppendingString:@".png"]];
                                      }else{
                                          self.coverImg = img;
                                      }
                                      [self.tableView reloadData];
                                  }];
    
    row = 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else{
        return row;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        MomentCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentCoverCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[MomentCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentCoverCell"];
        }
        
        [cell.coverImage setImage:self.coverImg];
        [cell.coverImage setContentMode:UIViewContentModeScaleAspectFill];
        [cell.coverImage setClipsToBounds:YES];
        
        PNUser *currentUser = [PNUserManager currentUser];
        if(currentUser.avatar == nil){
            [PNImageManager getSingletonImgForUser:currentUser.userId
                                       withImgType:AVATAR
                                          response:^(UIImage *img, NSError *err) {
                                              if(err != nil){
                                                  currentUser.avatar = [UIImage imageNamed:@"defaultAvatar.jpg"];
                                              }else{
                                                  currentUser.avatar = img;
                                              }
                                              [cell.avatar setImage:currentUser.avatar];
                                          }];
        }else{
            [cell.avatar setImage:currentUser.avatar];
        }
        [cell.avatar.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [cell.avatar.layer setBorderWidth:0.5];
        
        if(currentUser.displayedName == nil){
            [PNUserManager getDetailInfoForCurrentUser:^(NSError *error) {
                if(error != nil){
                    if([[error localizedDescription] isEqualToString:NO_USER_DETAIL_MSG]){
                        currentUser.displayedName = currentUser.username;
                    }else{
                        [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                    from:self];
                    }
                }
                cell.displayedName.text = currentUser.displayedName;
            }];
        }
        
        if(indexPath.row == row - 1){
            NSLog(@"reload");
            row += 5;
            [self.tableView reloadData];
        }
        
        return cell;
    }else{
        MomentTextHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentTextHeaderCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[MomentTextHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentTextHeaderCell"];
        }
        //Remove seperator?
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        /*
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
        }*/
        return cell;
    }
    
}

- (IBAction)createMomentTapped:(id)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* takePic = [UIAlertAction
                             actionWithTitle:@"Take a picture"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                 {
                                     [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                                     [imagePickerController setDelegate:self];
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     [self presentViewController:imagePickerController animated:YES completion:nil];
                                 }else{
                                     [UIAlertController showErrorAlertWithErrorMessage:@"Camera not available on this devide"
                                                                                  from:self];
                                 }
                             
                             }];
    
    UIAlertAction* selectPic = [UIAlertAction
                               actionWithTitle:@"Select pictures from album"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   QBImagePickerController *imagePickerController = [QBImagePickerController new];
                                   imagePickerController.delegate = self;
                                   imagePickerController.allowsMultipleSelection = YES;
                                   imagePickerController.maximumNumberOfSelection = 6;
                                   imagePickerController.showsNumberOfSelectedAssets = YES;
                                   
                                   [view dismissViewControllerAnimated:YES completion:nil];
                                   [self presentViewController:imagePickerController animated:YES completion:NULL];
                               }];
    
    UIAlertAction* enterText = [UIAlertAction
                                actionWithTitle:@"Enter text moment"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    [self performSegueWithIdentifier:@"createTextMomentSegue" sender:nil];
                                }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:takePic];
    [view addAction:selectPic];
    [view addAction:enterText];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    for (PHAsset *asset in assets) {
        NSLog(@"1");
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}

@end
