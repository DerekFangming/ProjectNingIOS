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

+ (NSString *) monthToString :(NSInteger) intMonth withAbbreviation:(BOOL) abbrev{
    switch (intMonth) {
        case 1:
            return abbrev ? @"JAN" : @"January";
        case 2:
            return abbrev ? @"FEB" : @"February";
        case 3:
            return abbrev ? @"MAR" : @"March";
        case 4:
            return abbrev ? @"APR" : @"April";
        case 5:
            return abbrev ? @"MAY" : @"May";
        case 6:
            return abbrev ? @"JUN" : @"June";
        case 7:
            return abbrev ? @"JUL" : @"July";
        case 8:
            return abbrev ? @"AUG" : @"August";
        case 9:
            return abbrev ? @"SEP" : @"September";
        case 10:
            return abbrev ? @"OCT" : @"October";
        case 11:
            return abbrev ? @"NOV" : @"November";
        case 12:
            return abbrev ? @"DEC" : @"December";
            
        default:
            return @"ERROR";
    }
}

@end
