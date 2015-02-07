//
//  AppDelegate.h
//  Telstra Exercise
//
//  Created by Himanshu on 2/6/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsFeedTableViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) NewsFeedTableViewController *newsFeedTableViewController;


+(AppDelegate *)sharedInstance;

@end

