//
//  NewsFeed.h
//  Telstra Exercise
//
//  Created by Himanshu on 2/6/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsFeed : NSObject

@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) NSString *desc;
@property (nonatomic, retain, readonly) NSString *imageHref;

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)desc imagePath:(NSString *)imagePath;

@end
