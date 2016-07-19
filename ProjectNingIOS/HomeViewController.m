#import "HomeViewController.h"
#import "LeftMenuViewController.h"

@implementation HomeViewController

@synthesize avatarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Setting up slide navigation controller
    [SlideNavigationController sharedInstance].portraitSlideOffset = 200;
    [SlideNavigationController sharedInstance].landscapeSlideOffset = 400;
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .22;
        [SlideNavigationController sharedInstance].menuRevealAnimator = [[SlideNavigationContorllerAnimatorScaleAndFade alloc] initWithMaximumFadeAlpha:.6 fadeColor:[UIColor blackColor] andMinimumScale:.8];
    }];
    
    
    [avatarView setImage:[UIImage imageNamed:@"1.png"]];
    
    [[avatarView layer] setShadowOffset:CGSizeMake(10, 10)];
    [[avatarView layer] setShadowRadius:5.0];
    [[avatarView layer] setShadowOpacity:0.6];
    [[avatarView layer] setMasksToBounds:NO];
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

@end
