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
    
    //Process comment body text view
    NSInteger viewWidth = self.view.frame.size.width;
    NSInteger viewHeight = self.view.frame.size.height;
    momentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, viewWidth - 20, 10)];
    momentTextView.backgroundColor = [UIColor redColor];
    momentTextView.text = [self.momentBody stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
    [momentTextView sizeToFit];
    [momentTextView layoutIfNeeded];
    
    CGSize size = [momentTextView
                   sizeThatFits:CGSizeMake(momentTextView.frame.size.width, CGFLOAT_MAX)];
    [momentTextView setContentSize:size];
    
    //Process floating view
    floatingView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 35 - size.height,
                                                            viewWidth, 35 + size.height)];
    [floatingView addSubview: momentTextView];
    floatingView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [self.view addSubview: floatingView];
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
