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
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[NewsFeedTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([NewsFeedTableViewCell class])];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [refresh addTarget:self
                action:@selector(fetchDataFromServer)
      forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refresh];
    [refresh release];
    
    [self fetchDataFromServer];
}

- (void)fetchDataFromServer {
    [self.refreshControl beginRefreshing];
    if (self.networkRequest == nil) {
        self.networkRequest = [NetworkRequest sharedManager];
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
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)handleFailureWithError:(NSError *)error
{
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsFeedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewsFeedTableViewCell class])
                                                            forIndexPath:indexPath];
    if ([self.newsFeedArray count]) {
        cell.parentTableView = tableView;
        [cell setupWithNewsFeedData:[self.newsFeedArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat viewWidth = 310;
    CGFloat estimatedHeight = viewWidth/4;
    return estimatedHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.0;
    if ([self.newsFeedArray count])
    {
        NewsFeed *newsObj = [self.newsFeedArray objectAtIndex:indexPath.row];
        CGFloat viewWidth = 310;
        
        CGSize titleFrame = CGSizeZero;
        titleFrame.width = viewWidth;
        titleFrame.height = 21;
        CGSize titleSize = [newsObj.title sizeWithFont:[UIFont systemFontOfSize:14]];
        CGFloat newTitleHeight = ceil(ceil(titleSize.width/(viewWidth))*titleSize.height);
        if (titleFrame.height<newTitleHeight) {
            titleFrame.height = newTitleHeight;
        }
        
        CGSize imgViewFrame = CGSizeZero;
        if (newsObj.imageHref) {
            imgViewFrame.width = viewWidth/3;
            imgViewFrame.height = viewWidth/4;
        }
        
        CGSize descriptionFrame = CGSizeZero;
        descriptionFrame.width = viewWidth-imgViewFrame.width;
        descriptionFrame.height = 42;
        CGSize desc = [newsObj.desc sizeWithFont:[UIFont systemFontOfSize:12]];
        CGFloat newDescHeight = ceil(ceil(desc.width/descriptionFrame.width)*desc.height);
        if (descriptionFrame.height<newDescHeight) {
            descriptionFrame.height = newDescHeight;
        }
        
        rowHeight = MAX(imgViewFrame.height,descriptionFrame.height)+titleFrame.height+PADDING;
    }
    return rowHeight;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.0;
    if (![self.newsFeedArray count]) {
        return rowHeight;
    }
    NewsFeed *newsObj = [self.newsFeedArray objectAtIndex:indexPath.row];
    CGFloat viewWidth = 310;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    [lbl setNumberOfLines:0];
    [lbl setText:newsObj.title];
    [lbl sizeToFit];
    
    CGSize titleSize = CGSizeZero;
    if ([lbl text]) {
        titleSize = lbl.frame.size;
        CGFloat newTitleHeight = ceil(ceil(titleSize.width/viewWidth)*titleSize.height);
        if (titleSize.height<newTitleHeight) {
            titleSize.height = newTitleHeight;
        }
    }
    
    CGSize imgViewSize = CGSizeZero;
    if (newsObj.imageHref) {
        imgViewSize.width = viewWidth/3;
        imgViewSize.height = viewWidth/4;
    }
    
    [lbl setText:newsObj.desc];
    [lbl sizeToFit];
    
    CGSize descriptionSize = CGSizeZero;
    if ([lbl text]) {
        descriptionSize = lbl.frame.size;
        CGFloat newDescHeight = ceil(ceil(descriptionSize.width/viewWidth)*descriptionSize.height);
        if (descriptionSize.height<newDescHeight) {
            descriptionSize.height = newDescHeight;
        }
    }
    
    [lbl release];
    
    rowHeight = (PADDING*2) + titleSize.height + MAX(descriptionSize.height, imgViewSize.height);
    
    return rowHeight;
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
