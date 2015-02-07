//
//  NetworkRequest.h
//  Telstra Exercise
//
//  Created by Himanshu on 2/6/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^GetRequestSuccessBlock)(NSDictionary *jsonResponse);
typedef void(^GetImageSuccessBlock)(UIImage *image);
typedef void(^GetRequestFailureBlock)(NSError *error);

@interface NetworkRequest : NSObject

+ (NetworkRequest *)sharedManager;

- (void)getContentFromURL:(NSURL *)url
         withSuccessBlock:(GetRequestSuccessBlock)success
          andFailureBlock:(GetRequestFailureBlock)failure;

- (void)getImageFromURL:(NSURL *)url
       withSuccessBlock:(GetImageSuccessBlock)success
        andFailureBlock:(GetRequestFailureBlock)failure;
@end
