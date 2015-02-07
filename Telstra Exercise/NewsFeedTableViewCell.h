//
//  NewsFeedTableViewCell.h
//  Telstra Exercise
//
//  Created by Himanshu on 2/6/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsFeed;
@interface NewsFeedTableViewCell : UITableViewCell

- (void)setupWithNewsFeedData:(NewsFeed *)obj;

@end
