//
//  ViewController.h
//  ProjectNingIOS
//
//  Created by NingFangming on 2/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PNService.h"
#import "SlideNavigationController.h"
#import "VCHolder.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

-(IBAction)registerClicked:(id)sender;
-(IBAction)loginClicked:(id)sender;

@end

