//
//  MomentImageController.m
//  ProjectNingIOS
//
//  Created by NingFangming on 1/27/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import "MomentImageController.h"

@interface MomentImageController ()

@end

@implementation MomentImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"image view loaded");
    dateText = [Utils processDateToText:self.createdAt withAbbreviation:NO];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.numberOfLines = 2;
    dateLabel.font = [UIFont boldSystemFontOfSize: 14.0f];
    dateLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor whiteColor];
    if([self.imageIdList count] == 1){
        dateLabel.numberOfLines = 1;
    }
    
    self.navigationItem.titleView = dateLabel;
    
    self.imageSliderView = [[PNImageSliderView alloc] initWithInitialIndex:0 imageIds:self.imageIdList];
    self.imageSliderView.delegate = self;
    self.imageSliderView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imageSliderView];
    [self setImageSliderViewConstraints];
    
    //Process comment body text view and the holder view
    NSInteger viewWidth = self.view.frame.size.width;
    NSInteger viewHeight = self.view.frame.size.height;
    momentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, viewWidth - 10, 10)];
    momentTextView.textColor = [UIColor whiteColor];
    momentTextView.backgroundColor = [UIColor clearColor];
    momentTextView.text = [self.momentBody stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
    [momentTextView sizeToFit];
    [momentTextView layoutIfNeeded];
    CGSize size = [momentTextView sizeThatFits:CGSizeMake(momentTextView.frame.size.width, CGFLOAT_MAX)];
    [momentTextView setContentSize:size];
    
    momentHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 35 - size.height,
                                                               viewWidth, size.height)];
    momentHolderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    momentHolderView.userInteractionEnabled = NO;
    [momentHolderView addSubview:momentTextView];
    
    //Process action view
    momentActionView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 35, viewWidth, 35)];
    momentActionView.backgroundColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:0.8];
    likeImageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(10,5,25,25)];
    likeImageLeft.image=[UIImage imageNamed:@"notLikeWhite.png"];
    likeLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 42, 35)];
    likeLabelLeft.font=[likeLabelLeft.font fontWithSize:12];
    likeLabelLeft.textColor = [UIColor whiteColor];
    likeLabelLeft.text = @"  Like";
    
    UITapGestureRecognizer *likeImageLeftTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(likeBtnTapped)];
    UITapGestureRecognizer *likeLabelLeftTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(likeBtnTapped)];
    [likeImageLeft setUserInteractionEnabled:YES];
    [likeLabelLeft setUserInteractionEnabled:YES];
    [likeImageLeft addGestureRecognizer:likeImageLeftTap];
    [likeLabelLeft addGestureRecognizer:likeLabelLeftTap];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(80, 10, 1, 15)];
    separator.backgroundColor = [UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:0.8];
    UIImageView *commentImageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(85, 5, 25, 25)];
    commentImageLeft.image = [UIImage imageNamed:@"writeCommentWhite.png"];
    UILabel *commentLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 55, 35)];
    commentLabelLeft.font = likeLabelLeft.font;
    commentLabelLeft.textColor = [UIColor whiteColor];
    commentLabelLeft.text = @"Comment";
    
    UITapGestureRecognizer *commentImageLeftTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(commentTapped)];
    UITapGestureRecognizer *commentLabelLeftTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(commentTapped)];
    [commentImageLeft setUserInteractionEnabled:YES];
    [commentLabelLeft setUserInteractionEnabled:YES];
    [commentImageLeft addGestureRecognizer:commentImageLeftTap];
    [commentLabelLeft addGestureRecognizer:commentLabelLeftTap];
    
    likeImageRight = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth - 55, 7, 20, 20)];
    likeImageRight.image = [UIImage imageNamed:@"notLikeWhite.png"];
    likeLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 35, 0, 0, 35)];
    likeLabelRight.font = likeLabelLeft.font;
    likeLabelRight.textColor = [UIColor whiteColor];
    commentImageRight = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth - 30, 7, 20, 20)];
    commentImageRight.image = [UIImage imageNamed:@"writeCommentWhite.png"];
    commentLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 10, 0, 0, 35)];
    commentLabelRight.font = likeLabelLeft.font;
    commentLabelRight.textColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *likeImageRightTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(detailsTapped)];
    UITapGestureRecognizer *likeLabelRightTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(detailsTapped)];
    UITapGestureRecognizer *commentImageRightTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(detailsTapped)];
    UITapGestureRecognizer *commentLabelRightTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(detailsTapped)];
    [likeImageRight setUserInteractionEnabled:YES];
    [likeLabelRight setUserInteractionEnabled:YES];
    [commentImageRight setUserInteractionEnabled:YES];
    [commentLabelRight setUserInteractionEnabled:YES];
    [likeImageRight addGestureRecognizer:likeImageRightTap];
    [likeLabelRight addGestureRecognizer:likeLabelRightTap];
    [commentImageRight addGestureRecognizer:commentImageRightTap];
    [commentLabelRight addGestureRecognizer:commentLabelRightTap];
    
    [momentActionView addSubview:likeImageLeft];
    [momentActionView addSubview:likeLabelLeft];
    [momentActionView addSubview:separator];
    [momentActionView addSubview:commentImageLeft];
    [momentActionView addSubview:commentLabelLeft];
    [momentActionView addSubview:likeImageRight];
    [momentActionView addSubview:likeLabelRight];
    [momentActionView addSubview:commentImageRight];
    [momentActionView addSubview:commentLabelRight];
    
    //Adding views
    [self.view addSubview: momentHolderView];
    [self.view addSubview: momentActionView];
    
    //Update counts and likes
    [PNCommentManager getCommentCountForCommentMappingId:self.momentId
                                                response:^(NSError *error, NSNumber *commentCount,
                                                           NSNumber *commentLikeCount, BOOL liked, NSNumber *likedId) {
                                                    [self adjustCountsAndViewsForComments:commentCount
                                                                          andCommentLikes:commentLikeCount];
                                                    likedByCurrentUser = liked;
                                                    if(liked){
                                                        self.likedCommentId = likedId;
                                                        likeImageLeft.image=[UIImage imageNamed:@"like.png"];
                                                        likeLabelLeft.text = @"Cancel";
                                                    }
                                                    
                                                }];
}

#pragma mark - Image slider setup and helpers -

- (void)setImageSliderViewConstraints {
    NSArray *imageSliderViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageSliderView]-0-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:@{@"imageSliderView": self.imageSliderView}];
    
    [self.view addConstraints:imageSliderViewHConstraints];
    
    
    
    NSArray *imageSliderViewVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageSliderView]-0-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:@{@"imageSliderView": self.imageSliderView}];
    
    [self.view addConstraints:imageSliderViewVConstraints];
}

- (void)imageSliderViewImageDidSwitchToIndex:(NSInteger)index totalCount:(NSInteger)count{
    dateLabel.text = [NSString stringWithFormat:@"%@\n%d/%d", dateText, index + 1, count];
}

- (void)imageSliderViewSingleTap:(UITapGestureRecognizer *)tap{
    if(isNavAndActionHidden){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.2f animations:^{
            momentHolderView.frame = CGRectOffset(momentHolderView.frame, 0, -35);
            momentActionView.frame = CGRectOffset(momentActionView.frame, 0, -35);
        } completion:^(BOOL finished) {
            isNavAndActionHidden = NO;
        }];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.2f animations:^{
            momentHolderView.frame = CGRectOffset(momentHolderView.frame, 0, 35);
            momentActionView.frame = CGRectOffset(momentActionView.frame, 0, 35);
        } completion:^(BOOL finished) {
            isNavAndActionHidden = YES;
        }];
    }
}

#pragma mark - Button clicked actions -

- (IBAction)actionBtnTapped:(id)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Delete"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:ok];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (void) likeBtnTapped {
    if(likedByCurrentUser){
        [PNCommentManager deleteCommentWithId:self.likedCommentId
                                     response:^(NSError *error) {
                                         if(error != nil){
                                             [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription]
                                                                                          from: self];
                                         }else{
                                             likeImageLeft.image=[UIImage imageNamed:@"notLikeWhite.png"];
                                             likeLabelLeft.text = @"  Like";
                                             likedByCurrentUser = NO;
                                             NSInteger newLike = [likeLabelRight.text intValue] - 1;
                                             [self adjustCountsAndViewsForComments:[NSNumber numberWithInt:-1]
                                                                   andCommentLikes:[NSNumber numberWithInt:newLike]];
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
                                       self.likedCommentId = commentId;
                                       likeImageLeft.image=[UIImage imageNamed:@"like.png"];
                                       likeLabelLeft.text = @"Cancel";
                                       likedByCurrentUser = YES;
                                       NSInteger newLike = [likeLabelRight.text intValue] + 1;
                                       [self adjustCountsAndViewsForComments:[NSNumber numberWithInt: -1]
                                                             andCommentLikes:[NSNumber numberWithInt:newLike]];
                                   }
                               }];
        
    }
}

- (void) commentTapped {
    [self performSegueWithIdentifier:@"enterCommentSegue" sender:nil];
}

- (void) detailsTapped {
    [self performSegueWithIdentifier:@"imageMomentToDetailSegue" sender:nil];
}

#pragma mark - Helper -

- (void) adjustCountsAndViewsForComments:(NSNumber *) commentCount andCommentLikes:(NSNumber *) commentLikeCount{
    NSInteger offset;
    if([commentCount intValue] >= 0){
        NSInteger previousWidth = commentLabelRight.frame.size.width;
        if([commentCount intValue] >= 0){
            commentLabelRight.text = [commentCount stringValue];
        }else{
            commentLabelRight.text = @"";
        }
        offset = commentLabelRight.intrinsicContentSize.width - previousWidth;
        CGRect currentFrame = commentLabelRight.frame;
        currentFrame.size.width += offset;
        currentFrame.origin.x -= offset;
        likeImageRight.frame = CGRectOffset(likeImageRight.frame, - offset, 0);
        likeLabelRight.frame = CGRectOffset(likeLabelRight.frame, - offset, 0);
        commentImageRight.frame = CGRectOffset(commentImageRight.frame, - offset, 0);
        commentLabelRight.frame = currentFrame;
    }
    
    if([commentLikeCount intValue] >= 0){
        NSInteger previousWidth = likeLabelRight.frame.size.width;
        if([commentLikeCount intValue] > 0){
            likeLabelRight.text = [commentLikeCount stringValue];
        }else{
            likeLabelRight.text = @"";
        }
        offset = likeLabelRight.intrinsicContentSize.width - previousWidth;
        CGRect currentFrame = likeLabelRight.frame;
        currentFrame.size.width += offset;
        currentFrame.origin.x -= offset;
        likeImageRight.frame = CGRectOffset(likeImageRight.frame, - offset, 0);
        likeLabelRight.frame = currentFrame;
    }
    
}

#pragma mark - Segues methods -

- (IBAction)unwindFromModalViewController:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isKindOfClass:[MomentInputController class]])
    {
        MomentInputController *sourceVC = segue.sourceViewController;
        NSCharacterSet* charsToTrim = [NSCharacterSet characterSetWithCharactersInString:@" "];
        NSString* trimmedStr = [sourceVC.commentInput.text stringByTrimmingCharactersInSet:charsToTrim];
        self.unsentComment = trimmedStr;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"enterCommentSegue"]) {
        
        MomentInputController *destVC = (MomentInputController *)[segue.destinationViewController topViewController];
        destVC.unsentComment = self.unsentComment;
        destVC.momentId = self.momentId;
    }else if ([segue.identifier isEqualToString:@"imageMomentToDetailSegue"]) {
        MomentTextController *destVC = (MomentTextController *)[segue.destinationViewController topViewController];
        destVC.seguedFromImageController = YES;
        destVC.displayedName = self.displayedName;
        destVC.avatar = self.avatar;
        destVC.userId = self.userId;
        destVC.momentId = self.momentId;
        destVC.momentBody = self.momentBody;
        destVC.createdAt = self.createdAt;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
