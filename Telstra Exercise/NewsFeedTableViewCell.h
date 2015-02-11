//
//  NewsFeedTableViewCell.h
//  Telstra Exercise
//
//  Created by Himanshu on 2/6/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PADDING 5
#define MIN_CONTENT_WIDTH 310

@class NewsFeed;

@interface NewsFeedTableViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) UITableView *parentTableView;

- (void)setupWithNewsFeedData:(NewsFeed *)obj;
- (void)cleanup;

@end
