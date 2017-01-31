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
    
    self.imageIds = [NSArray arrayWithObjects:[NSNumber numberWithInt:14],[NSNumber numberWithInt:15],[NSNumber numberWithInt:16],[NSNumber numberWithInt:17],[NSNumber numberWithInt:18],nil];
    self.imageSliderView = [[PNImageSliderView alloc] initWithInitialIndex:0 imageIds:self.imageIds];
    self.imageSliderView.delegate = self;
    self.imageSliderView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imageSliderView];
    [self setImageSliderViewConstraints];
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
    NSLog(@"hshs");
    NSLog(@"%d / %d", index, count);
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)imageSliderViewSingleTap:(UITapGestureRecognizer *)tap{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
