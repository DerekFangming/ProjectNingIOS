//
//  PNUtils.m
//  ProjectNingIOS
//
//  Created by NingFangming on 10/31/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import "PNUtils.h"

@implementation PNUtils

+ (NSError *) createNSError:(NSDictionary *) dic{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:[dic objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"PN" code:200 userInfo:details];
}

@end
