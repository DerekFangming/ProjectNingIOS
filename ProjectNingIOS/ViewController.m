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
    NSDate * now = [NSDate date];
    
    NSLog(@"%@", now);
    
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    NSDate *theDate = [formatter dateFromString:@"2016-02-15T17:33:45.472Z"];
    
    NSLog(@"%@", theDate);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
