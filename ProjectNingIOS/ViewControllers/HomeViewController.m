//
//  HomeViewController.m
//  ProjectNingIOS
//
//  Created by NingFangming on 6/11/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "HomeViewController.h"
#import "LeftMenuViewController.h"
//import "xiao bao bei.h"

@implementation HomeViewController

@synthesize avatarView;
@synthesize acceptBtn;
@synthesize denyBtn;
@synthesize refreshBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Setting up slide navigation controller
    [SlideNavigationController sharedInstance].portraitSlideOffset = 200;
    [SlideNavigationController sharedInstance].landscapeSlideOffset = 400;
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .22;
        [SlideNavigationController sharedInstance].menuRevealAnimator = [[SlideNavigationContorllerAnimatorScaleAndFade alloc] initWithMaximumFadeAlpha:.6 fadeColor:[UIColor blackColor] andMinimumScale:.8];
    }];
    
    //Setting up background
    self.view.backgroundColor = GRAY_BG_COLOR;
    
    //Setting up avatar image view
    [avatarView setImage:[UIImage imageNamed:@"defaultAvatar.jpg"]];
    [[avatarView layer] setShadowOffset:CGSizeMake(10, 10)];
    [[avatarView layer] setShadowRadius:5.0];
    [[avatarView layer] setShadowOpacity:0.6];
    [[avatarView layer] setMasksToBounds:NO];
    
    //Setting up buttons
    [acceptBtn setImage:[UIImage imageNamed:@"acceptBtnClicked.png"] forState: UIControlStateHighlighted];
    [acceptBtn setImage:[UIImage imageNamed:@"acceptBtn.png"] forState: UIControlStateNormal];
    [denyBtn setImage:[UIImage imageNamed:@"denyBtnClicked.png"] forState: UIControlStateHighlighted];
    [denyBtn setImage:[UIImage imageNamed:@"denyBtn.png"] forState: UIControlStateNormal];
    [refreshBtn setImage:[UIImage imageNamed:@"refreshBtn.png"] forState: UIControlStateNormal];
    [refreshBtn setHidden:YES];
    
    //Init first stranger
    [self disableAllBtns];/*
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    [PNImage getNextAvatarWithAction:nil
                forCurrentUserWithId:nil
                            response:^(PNStranger * stranger, bool status, NSError *error) {
                                [self enableAllBtns];
                                [GMDCircleLoader hideFromView:self.view animated:YES];
                                if(error == nil){
                                    currentStranger = stranger;
                                    [avatarView setImage:[stranger avatar]];
                                }else{
                                    [refreshBtn setHidden:NO];
                                    [self disableAllBtns];
                                    [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription] from:self];
                                }
                            }];*/
//    [UIAlertController showFriendConfirmAlertForStranger:@"Andy" from:self completionHandler:^(NSInteger selected) {
//        if(selected ==1){
//            // Chat!
//            UIViewController *vc = [[VCHolder sharedInstance] getVC:FRIEND_VC];
//            
//            static Menu menu = MenuLeft;
//            [[SlideNavigationController sharedInstance] openMenu:menu withCompletion:^{
//                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
//                                                                         withSlideOutAnimation:YES
//                                                                                 andCompletion:nil];
//            }];
//            
//        }
//    }];
    //i love shanshan ~
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
	return NO;
}

#pragma mark - IBActions -

- (IBAction)acceptBtnClick {
    [self disableAllBtns];
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    [PNImageManager getNextAvatarWithAction:ACCEPT_ACTION
                forCurrentUserWithId:[currentStranger userId]
                            response:^(PNUser * stranger, bool status, NSError *error) {
                                [self enableAllBtns];
                                [GMDCircleLoader hideFromView:self.view animated:YES];
                                if(error == nil){
                                    currentStranger = stranger;
                                    [avatarView setImage: stranger.avatar];
                                }else{
                                    [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription] from:self];
                                }
    }];
}

- (IBAction)denyBtnClick {
    [self disableAllBtns];
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    [PNImageManager getNextAvatarWithAction:DENY_ACTION
                forCurrentUserWithId:[currentStranger userId]
                            response:^(PNUser * stranger, bool status, NSError *error) {
                                [self enableAllBtns];
                                [GMDCircleLoader hideFromView:self.view animated:YES];
                                if(error == nil){
                                    
                                    
                                    currentStranger = stranger;
                                    [avatarView setImage:stranger.avatar];
                                }else{
                                    [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription] from:self];
                                }
                            }];
}

- (IBAction)refreshBtnClick {
    [refreshBtn setHidden:YES];
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    [PNImageManager getNextAvatarWithAction:nil
                forCurrentUserWithId:nil
                            response:^(PNUser * stranger, bool status, NSError *error) {
                                [self enableAllBtns];
                                [GMDCircleLoader hideFromView:self.view animated:YES];
                                if(error == nil){
                                    [self enableAllBtns];
                                    currentStranger = stranger;
                                    [avatarView setImage:stranger.avatar];
                                }else{
                                    [refreshBtn setHidden:NO];
                                    [self disableAllBtns];
                                    [UIAlertController showErrorAlertWithErrorMessage:[error localizedDescription] from:self];
                                }
                            }];
}

#pragma mark - Button controls -

- (void)disableAllBtns {
    [acceptBtn setEnabled:NO];
    [denyBtn setEnabled:NO];
}

- (void)enableAllBtns {
    [acceptBtn setEnabled:YES];
    [denyBtn setEnabled:YES];
}

@end
