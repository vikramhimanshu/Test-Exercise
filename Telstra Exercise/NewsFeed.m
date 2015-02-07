//
//  NewsFeed.m
//  Telstra Exercise
//
//  Created by Himanshu on 2/6/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import "NewsFeed.h"

@interface NewsFeed ()

@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSString *desc;
@property (nonatomic, retain, readwrite) NSString *imageHref;

@end

@implementation NewsFeed

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)desc imagePath:(NSString *)imagePath
{
    if (![title length] && ![desc length] && ![imagePath length]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.title = title;
        self.desc = desc;
        self.imageHref = imagePath;
    }
    return self;
}

@end
