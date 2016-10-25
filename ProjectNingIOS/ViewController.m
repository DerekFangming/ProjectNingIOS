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

@synthesize username;
@synthesize password;
@synthesize registerBtn;
@synthesize loginBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    [PNUser loginUserWithUsername:@"synfm123@gmail.com"
                       andPassword:@"flash"
                           response:^(PNUser *user, NSError *error) {
                               //NSLog([user username]);
                               //NSLog(@"%@", [error localizedDescription]);
    }];
    
    [PNUser logoutCurrentUser];// reminder: This does not work because of the async
    
}

#pragma - mark Login and register

-(IBAction)registerClicked:(id)sender{
    NSLog(@"register");
}

-(IBAction)loginClicked:(id)sender{
//    [PNUser loginUserWithUsername:username.text
//                      andPassword:password.text
//                         response:^(PNUser *user, NSError *error) {
//                             if(error == nil){
//                                 [self performSegueWithIdentifier:@"loginSegue" sender:nil];
//                             }else{
//                                 UIAlertController * alert=   [UIAlertController
//                                                               alertControllerWithTitle:@"My Title"
//                                                               message:@"Enter User Credentials"
//                                                               preferredStyle:UIAlertControllerStyleAlert];
//                                 
//                                 UIAlertAction* yesButton = [UIAlertAction
//                                                             actionWithTitle:@"Yes, please"
//                                                             style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction * action) {
//                                                                 //Handle your yes please button action here
//                                                             }];
//                                 
//                                 UIAlertAction* noButton = [UIAlertAction
//                                                            actionWithTitle:@"No, thanks"
//                                                            style:UIAlertActionStyleDefault
//                                                            handler:^(UIAlertAction * action) {
//                                                                //Handle no, thanks button
//                                                            }];
//                                 
//                                 [alert addAction:yesButton];
//                                 [alert addAction:noButton];
//                                 
//                                 [self presentViewController:alert animated:YES completion:nil];
//                             }
//                         }];
    //[self performSegueWithIdentifier:@"loginSegue" sender:nil];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"FriendsViewController"];
    
    [VCHolder sharedInstance];
    
    [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:vc
                                                          withSlideOutAnimation:YES
                                                                  andCompletion:nil];
    
}

#pragma - mark Delegate and default methods

-(void)dismissKeyboard {
    [username resignFirstResponder];
    [password resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
