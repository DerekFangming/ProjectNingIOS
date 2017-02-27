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
    self.feedList = [[NSMutableArray alloc] init];
    
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
    [self loadNextSetOfFeedsBeforeCheckpoint:nil withLimit: [NSNumber numberWithInt:5]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.feedList count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else{
        return 1; //Header only for now
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 240;
    }else{
        if(indexPath.row == 0){
            return [[self.feedList objectAtIndex:indexPath.section -1] headerCellHeight];
        }else{
            return 50;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        MomentCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentCoverCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[MomentCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentCoverCell"];
        }
        
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        
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
        
        return cell;
    }else{
        MomentTextHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentTextHeaderCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[MomentTextHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"momentTextHeaderCell"];
        }
        
        PNFeed *feed = [self.feedList objectAtIndex:indexPath.section - 1];
        
        //Process feed basic information
        if(feed.ownerAvatar){
            [cell.avatar setImage: feed.ownerAvatar];
        }else{
            [PNImageManager getSingletonImgForUser:feed.ownerId
                                       withImgType:AVATAR
                                          response:^(UIImage *img, NSError *err) {
                                              if(err != nil){
                                                  cell.avatar.image = [UIImage imageNamed:@"defaultAvatar.jpg"];
                                              }else{
                                                  cell.avatar.image = img;
                                              }
                                              feed.ownerAvatar = cell.avatar.image;
                                          }];
        }
        cell.nameLabel.text = feed.ownerName;
        cell.nameLabel.textColor = PURPLE_COLOR;
        cell.momentTextView.text = [feed.feedBody stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
        [cell.momentTextView sizeToFit];
        [cell.momentTextView layoutIfNeeded];
        CGSize size = [cell.momentTextView
                       sizeThatFits:CGSizeMake(cell.momentTextView.frame.size.width, CGFLOAT_MAX)];
        feed.headerCellHeight = size.height + 45;
        [cell.momentTextView setContentSize:size];
        cell.dateLabel.text = [Utils processDateToText:feed.createdAt withAbbreviation:NO];
        
        //Process header images
        NSLog(@"NO IMG");
        if(feed.imgList){
            NSLog(@"HAS IMAGE");
            int imageCount = [feed.imgList count];
            CGFloat imageSectionHeight;
            CGFloat imageSectionViewHeight;
            
            if(imageCount == 1){
                imageSectionHeight = (self.tableView.frame.size.width - 100) * 0.66;
                imageSectionViewHeight = imageSectionHeight;
            }else if(imageCount <= 3){
                imageSectionHeight = (self.tableView.frame.size.width - 100) * 0.33;
                imageSectionViewHeight = imageSectionHeight;
            }else if(imageCount <= 6){
                imageSectionHeight = (self.tableView.frame.size.width - 100) * 0.66;
                imageSectionViewHeight = imageSectionHeight / 2;
            }else{
                imageSectionHeight = self.tableView.frame.size.width - 100;
                imageSectionViewHeight = imageSectionHeight / 3;
            }
            feed.headerCellHeight += imageSectionHeight;
            
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
                
                PNImage *image = [feed.imgList objectAtIndex:i];
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
        }
        
        /*
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

#pragma mark - Feed loading helper -
- (void)loadNextSetOfFeedsBeforeCheckpoint:(NSDate *) date withLimit:(NSNumber *) limit{
    [PNFeedManager
     getRecentFullFeedListForCurrentUserBeforeDate:date
     withLimit:limit response:^(NSError *error, NSArray *newFeeds, NSDate *checkPoint) {
         if(error != nil){
             [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription] from:self];
         }else{
             [self.feedList addObjectsFromArray:newFeeds];
             [self.tableView reloadData];
         }
     }
     ];
}

#pragma mark - Button action -

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

- (void)commentImgClick:(UITapGestureRecognizer *)recognizer{
    /*
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
     */
    
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
