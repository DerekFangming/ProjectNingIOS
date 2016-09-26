#import "HomeViewController.h"
#import "LeftMenuViewController.h"

@implementation HomeViewController

@synthesize avatarView;
@synthesize acceptBtn;
@synthesize denyBtn;

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
    
    //Setting up avatar image view
    [avatarView setImage:[UIImage imageNamed:@"1.png"]];
    [[avatarView layer] setShadowOffset:CGSizeMake(10, 10)];
    [[avatarView layer] setShadowRadius:5.0];
    [[avatarView layer] setShadowOpacity:0.6];
    [[avatarView layer] setMasksToBounds:NO];
    
    //Setting up buttons
    [acceptBtn setImage:[UIImage imageNamed:@"acceptBtnClicked.png"] forState: UIControlStateHighlighted];
    [acceptBtn setImage:[UIImage imageNamed:@"acceptBtn.png"] forState: UIControlStateNormal];
    [denyBtn setImage:[UIImage imageNamed:@"denyBtnClicked.png"] forState: UIControlStateHighlighted];
    [denyBtn setImage:[UIImage imageNamed:@"denyBtn.png"] forState: UIControlStateNormal];
    
    //Init first stranger
    [self disableAllBtns];
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    [PNImage getNextAvatarWithAction:nil
                forCurrentUserWithId:nil
                            response:^(PNStranger * strange, bool status, NSError *error) {
                                if(error == nil){
                                    [avatarView setImage:[strange avatar]];
                                    [self enableAllBtns];
                                    [GMDCircleLoader hideFromView:self.view animated:YES];
                                }else if ([[error localizedDescription] isEqualToString:@"The resources do not exist"]){
                                    NSLog([error localizedDescription]);
                                }
                            }];
    
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
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    CGRect rect = [keyWindow bounds];
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [keyWindow.layer renderInContext:context];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    //[PNImage deleteImage:[NSNumber numberWithInt:11] response:^(NSError *error) {
    //    if(error == nil){
    //        NSLog(@"Ok");
    //    }else{
    //        NSLog([error localizedDescription]);
    //    }
    //}];
    /*
    [PNImage getImageIdListByType:@"Others" response:^(NSMutableArray *list, NSError *error) {
        if(error == nil){
            NSLog(@"%@",list);
        }else{
            NSLog([error localizedDescription]);
        }
    }];
     */
    NSLog(@"Click!");
    [self disableAllBtns];
    [GMDCircleLoader setOnView:self.view withTitle:@"Loading..." animated:YES];
    /*
    [PNImage downloadImageWithId:[NSNumber numberWithInt:5] response:^(UIImage * img, NSError *error) {
        if(error == nil){
            NSLog(@"Done");
            [avatarView setImage:img];
        }else{
            NSLog([error localizedDescription]);
        }
    }];*/
    [PNImage getNextAvatarWithAction:nil
                forCurrentUserWithId:nil
                            response:^(PNStranger * strange, bool status, NSError *error) {
                                if(error == nil){
                                    NSLog(@"Done");
                                    [avatarView setImage:[strange avatar]];
                                    [self enableAllBtns];
                                    [GMDCircleLoader hideFromView:self.view animated:YES];
                                }else{
                                    NSLog([error localizedDescription]);
                                }
    }];
}

- (IBAction)denyBtnClick {
    
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
