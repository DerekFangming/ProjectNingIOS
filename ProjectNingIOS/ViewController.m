//
//  ViewController.m
//  ProjectNingIOS
//
//  Created by NingFangming on 2/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [PNUser loginUserWithUsername:@"synfm123@gmail.com"
                       andPassword:@"flash"
                           response:^(PNUser *user, NSError *error) {
                               NSLog([user username]);
                               NSLog(@"%@", [user expDate]);
    }];
    
    [PNUser logoutCurrentUser];
    

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
