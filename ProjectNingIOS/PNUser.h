//
//  PNUser.h
//  ProjectNingIOS
//
//  Created by NingFangming on 2/12/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNUser : NSObject{
    
}

@property (nonatomic, readonly) NSString *username;

-(id) initWithUsername:(NSString *)username andPassword :(NSString *)password;

@end
