//
//  PNImage.h
//  ProjectNingIOS
//
//  Created by NingFangming on 3/18/16.
//  Copyright © 2016 fangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PNUser.h"
#import "PNStranger.h"
#import "PNUtils.h"

@interface PNImageManager : NSObject

+ (instancetype)imageManager;

/**
 Upload an image to server
 If the response error is not nil, there is error in the upload process
 @param img the image in UIImage form
 @param type the type of the image. This will be validated by the server and may be changed
 */
+ (void) uploadImage:(UIImage *) img
              inType:(NSString *) type
            response:(void (^)(NSError *))response;

/**
 Upload an image to server with a customized title
 If the response error is not nil, there is error in the upload process
 @param img the image in UIImage form
 @param type the type of the image. This will be validated by the server and may be changed
 */
+ (void) uploadImage:(UIImage *) img
              inType:(NSString *) type
           withTitle:(NSString *) title
            response:(void (^)(NSError *))response;

/**
	Delete an image on server.
	Note that you need to be the creator of that image to delete it.
	@param imageId the Id of the image to be deleted
 */
+ (void) deleteImageWithId:(NSNumber *) imageId
                  response:(void (^)(NSError *))response;

/**
	Get a list of IDs for images with the specific type.
	Note that only images created by you with that type will get retrieved
	@param type the type name of the images
 */
+ (void) getImageIdListByType:(NSString *) type
                     response:(void (^)(NSMutableArray *, NSError *))response;

/**
	Download image from server with a given Id
	Note that you need to be the creator of that image to delete it
	@param imageId the Id of the image to be deleted
 */
+ (void) downloadImageWithId:(NSNumber *) imageId
                    response:(void (^)(UIImage *, NSError *))response;

/**
    Get avatar of a user by user id
    @param userId the Id of this user
 */
+ (void) getSingletonImgForUser:(NSNumber *) userId
                    withImgType:(NSString *) imgType
                       response:(void (^)(UIImage *, NSError *))response;
/**
    Get avatar of the next user. There may not be available users
    @param action the action for currect user when requesting for a new one
    @param userId the id of the current user
 */
+ (void) getNextAvatarWithAction:(NSString *) action
            forCurrentUserWithId:(NSNumber *) userId
                        response:(void (^)(PNStranger *, bool, NSError *))response;
@end
