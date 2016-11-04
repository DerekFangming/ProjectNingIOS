//
//  PNFriend.h
//  ProjectNingIOS
//
//  Created by NingFangming on 11/3/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PNFriend : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) UIImage *avatar;


- (id)initWithName:(NSString *) name andId:(NSNumber *) userId;

@end
