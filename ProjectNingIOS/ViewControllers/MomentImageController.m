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
    UIImageView *likeImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,5,25,25)];
    likeImage.image=[UIImage imageNamed:@"notLikeWhite.png"];
    UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 42, 35)];
    likeLabel.font=[likeLabel.font fontWithSize:13];
    likeLabel.textColor = [UIColor whiteColor];
    likeLabel.text = @"Cancel";
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapped)];
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapped)];
    [likeImage setUserInteractionEnabled:YES];
    [likeLabel setUserInteractionEnabled:YES];
    [likeImage addGestureRecognizer:imageTap];
    [likeLabel addGestureRecognizer:labelTap];
    
    [momentActionView addSubview:likeImage];
    [momentActionView addSubview:likeLabel];
    
    //Adding views
    [self.view addSubview: momentHolderView];
    [self.view addSubview: momentActionView];
}

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

- (void) likeTapped {
    NSLog(@"1");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
