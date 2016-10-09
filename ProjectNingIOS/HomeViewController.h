#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SlideNavigationController.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"

#import "PNService.h"
#import "Utils.h"
#import "GMDCircleLoader.h"

@interface HomeViewController : UIViewController{
    PNStranger *currentStranger;
}
//
//@property (nonatomic, strong) IBOutlet UISwitch *limitPanGestureSwitch;
//@property (nonatomic, strong) IBOutlet UISwitch *slideOutAnimationSwitch;
//@property (nonatomic, strong) IBOutlet UISwitch *shadowSwitch;
//@property (nonatomic, strong) IBOutlet UISwitch *panGestureSwitch;
//@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UIButton *acceptBtn;
@property (strong, nonatomic) IBOutlet UIButton *denyBtn;

@end
