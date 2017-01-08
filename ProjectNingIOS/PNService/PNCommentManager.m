//
//  PNCommentManager.m
//  ProjectNingIOS
//
//  Created by NingFangming on 1/5/17.
//  Copyright © 2017 fangming. All rights reserved.
//

#import "PNCommentManager.h"

@implementation PNCommentManager

+ (void) getRecentCommentsForUser:(NSNumber *) userId
                   forCommentType:(NSString *) type
                    withMappingId:(NSNumber *) mappingId
                         response:(void(^)(NSError *, NSArray *)) response{
    NSError *error = [PNUser checkUserLoginStatus];
    if(error != nil){
        response(error, nil);
    }
    
    PNUser *user = [PNUser currentUser];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[user accessToken] forKey:@"accessToken"];
    [parameters setObject:userId forKey:@"userId"];
    [parameters setObject:type forKey:@"type"];
    [parameters setObject:mappingId forKey:@"mappingId"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:requestBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:pathForRecentComments
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if ([[responseObject objectForKey:@"error"] isEqualToString:@""]) {
                  NSArray *array = [responseObject objectForKey:@"commentList"];
                  NSMutableArray *commentList = [[NSMutableArray alloc] init];
                  for(NSDictionary * dic in array){
                      PNComment *comment = [[PNComment alloc] initWithCommentId:[dic objectForKey:@"commentId"]
                                                                        andBody:[dic objectForKey:@"commentbody"]
                                                                        andType:type
                                                                   andMappingId:mappingId
                                                                     andOwnerId:[dic objectForKey:@"ownerId"]
                                                                        andDate:[dic objectForKey:@"createdAt"]];
                      
                      comment.ownerDisplayedName = [dic objectForKey:@"ownerName"];
                      [commentList addObject:comment];
                  }
                  
                  response(nil, commentList);
              }else{
                  response([PNUtils createNSError:responseObject], nil);
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              response(error,nil);
              
          }];
    
}
@end
