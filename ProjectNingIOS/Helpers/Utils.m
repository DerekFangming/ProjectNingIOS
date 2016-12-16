//
//  Utils.m
//  ProjectNingIOS
//
//  Created by NingFangming on 9/20/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)rotateLayerInfinite:(CALayer *)layer
{
    NSLog(@"start");
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 0.7f; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
}

+ (NSString *) monthToString :(NSInteger) intMonth{
    switch (intMonth) {
        case 1:
            return @"JAN";
        case 2:
            return @"FEB";
        case 3:
            return @"MAR";
        case 4:
            return @"APR";
        case 5:
            return @"MAY";
        case 6:
            return @"JUN";
        case 7:
            return @"JUL";
        case 8:
            return @"AUG";
        case 9:
            return @"SEP";
        case 10:
            return @"OCT";
        case 11:
            return @"NOV";
        case 12:
            return @"DEC";
            
        default:
            return @"ERROR";
    }
}

@end
