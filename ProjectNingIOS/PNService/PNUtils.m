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

+ (UIImage *) base64ToImage:(NSString *) base64Str{
    NSData* imgData = [[NSData alloc] initWithBase64EncodedString:base64Str options:0];
    return [UIImage imageWithData:imgData];
}

@end
