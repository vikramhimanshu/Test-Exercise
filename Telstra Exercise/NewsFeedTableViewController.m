//
//  NewsFeedTableViewController.m
//  Telstra Exercise
//
//  Created by Himanshu on 2/6/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#include "NewsFeedTableViewCell.h"
#include "NetworkRequest.h"
#include "NewsFeed.h"

@interface NewsFeedTableViewController ()

@property (nonatomic,retain) NetworkRequest *networkRequest;
@property (nonatomic,retain) NSArray *newsFeedArray;

@end

@implementation NewsFeedTableViewController

-(void)dealloc {
    [self.networkRequest release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[NewsFeedTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([NewsFeedTableViewCell class])];
    
    [self fetchDataFromServer];
}

- (void)fetchDataFromServer {
    
    if (self.networkRequest == nil) {
        self.networkRequest = [[NetworkRequest alloc] init];
    }
    __unsafe_unretained NewsFeedTableViewController *weakSelf = self;
    [self.networkRequest getContentFromURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/746330/facts.json"]
                          withSuccessBlock:^(NSDictionary *jsonResponse)
    {
          NSString *title = jsonResponse[@"title"];
          dispatch_async(dispatch_get_main_queue(), ^{
              [weakSelf updateNavigationTitle:title];
          });
          
          NSArray *rows = jsonResponse[@"rows"];
          NSMutableArray *objectsArray = [[NSMutableArray alloc] initWithCapacity:[rows count]];
          
          for (NSDictionary *newsDic in rows)
          {
              NewsFeed *newsObj = [[NewsFeed alloc] initWithTitle:[NSString stringWithFormat:@"%@",newsDic[@"title"]]
                                                       description:[NSString stringWithFormat:@"%@",newsDic[@"description"]]
                                                         imagePath:[NSString stringWithFormat:@"%@",newsDic[@"imageHref"]]];
              if (newsObj) {
                  [objectsArray addObject:newsObj];
                  [newsObj release];
              }
          }
          dispatch_async(dispatch_get_main_queue(), ^{
              [weakSelf reloadTableViewWithData:objectsArray];
          });
          [objectsArray release];
      }
       andFailureBlock:^(NSError *error) {
           dispatch_async(dispatch_get_main_queue(), ^{
               [weakSelf handleFailureWithError:error];
           });
       }];
}

- (void)updateNavigationTitle:(NSString *)title {
    self.title = title;
}

- (void)reloadTableViewWithData:(NSArray *)objects
{
    self.newsFeedArray = objects;
    [self.tableView reloadData];
}

- (void)handleFailureWithError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewsFeedTableViewCell class])
                                                            forIndexPath:indexPath];
    if ([self.newsFeedArray count]) {
        [cell setupWithNewsFeedData:[self.newsFeedArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
