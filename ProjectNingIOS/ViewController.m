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
    
    
//    [user registerUserWithUsername:@"a"
//                       andPassword:@"b"
//                           response:^(PNUser *user, NSError *error) {
//        NSLog([NSString stringWithFormat:@"cuccess and user name is %@", user.username]);
//    }];
    
    NSLog(@"%d", [[NSTimeZone localTimeZone] secondsFromGMT] / 3600);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
