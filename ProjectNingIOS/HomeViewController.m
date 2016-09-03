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
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [PNImage uploadImage:img inType:@"Others" response:^(NSError *error) {
        if (error == nil){
            NSLog(@"ok");
        }else{
            NSLog([error localizedDescription]);
        }
    }];
}

- (IBAction)denyBtnClick {
    
}

@end
