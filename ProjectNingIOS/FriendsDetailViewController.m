//
//  FriendsDetailViewController.m
//  ProjectNingIOS
//
//  Created by NingFangming on 11/11/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "FriendsDetailViewController.h"

@interface FriendsDetailViewController ()

@end

@implementation FriendsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Loaded");
    NSLog(_name);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"friendEmbedSegue"]) {
        FriendsEmbedViewController *destVC = segue.destinationViewController;
        destVC.userId = self.userId;
        destVC.name = self.name;
        destVC.avatar = self.avatar;
    }
}

@end
