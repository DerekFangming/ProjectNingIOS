//
//  PNStranger.h
//  ProjectNingIOS
//
//  Created by NingFangming on 9/9/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PNStranger : NSObject{
    @protected UIImage *avatar;
    @protected NSNumber *userId;
}

- (id)initWithAvatar:(UIImage *) newAvatar andUserId:(NSNumber *) newUserId;

- (UIImage *) avatar;

- (NSNumber *) userId;

@end
