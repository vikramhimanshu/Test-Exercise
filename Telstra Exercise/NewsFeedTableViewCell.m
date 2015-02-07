//
//  NewsFeedTableViewCell.m
//  Telstra Exercise
//
//  Created by Himanshu on 2/6/15.
//  Copyright (c) 2015 Himanshu. All rights reserved.
//

#import "NewsFeedTableViewCell.h"
#import "NetworkRequest.h"
#import "NewsFeed.h"

#define PADDING 5

@interface NewsFeedTableViewCell ()

@property (retain,nonatomic) UIImageView *imgView;
@property (retain,nonatomic) UILabel *titleLabel;
@property (retain,nonatomic) UILabel *descriptionLabel;
@property (retain,nonatomic) NetworkRequest *networkRequest;
@property (retain,nonatomic) NewsFeed *newsObj;

@end

@implementation NewsFeedTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.networkRequest = [NetworkRequest sharedManager];
        
        CGRect titleFrame = CGRectZero;
        titleFrame.size.width = CGRectGetWidth(self.contentView.frame);
        titleFrame.size.height = CGRectGetHeight(self.contentView.frame)*0.3;
        titleFrame.origin.x = PADDING;
        titleFrame.origin.y = PADDING;
        self.titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.titleLabel];
        
        CGRect descriptionFrame = CGRectZero;
        descriptionFrame.size.width = CGRectGetWidth(self.contentView.frame)*0.6;
        descriptionFrame.size.height = CGRectGetHeight(self.contentView.frame)*0.7;
        descriptionFrame.origin.x = 0;
        descriptionFrame.origin.y = CGRectGetHeight(self.titleLabel.frame) + PADDING;

        self.descriptionLabel = [[UILabel alloc] initWithFrame:descriptionFrame];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.descriptionLabel];

        CGRect imgViewFrame = CGRectZero;
        imgViewFrame.size.width = CGRectGetWidth(self.contentView.frame)*0.4;
        imgViewFrame.size.height = imgViewFrame.size.width*3/4;
        imgViewFrame.origin.x = (CGRectGetWidth(self.contentView.frame)-imgViewFrame.size.width) - PADDING;
        imgViewFrame.origin.y = CGRectGetHeight(self.titleLabel.frame) + PADDING;

        self.imgView = [[UIImageView alloc] initWithFrame:imgViewFrame];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

-(void)setupWithNewsFeedData:(NewsFeed *)obj
{
    self.newsObj = [obj retain];
    self.titleLabel.text = self.newsObj.title;
    self.descriptionLabel.text = self.newsObj.desc;
    if (obj.imageHref) {
        [self.networkRequest getImageFromURL:[NSURL URLWithString:obj.imageHref]
                            withSuccessBlock:^(UIImage *image) {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    self.imgView.image = image;
                                }];
                                [self setNeedsDisplay];
                            }
                             andFailureBlock:^(NSError *error) {
                                 [self setNeedsDisplay];
                             }];
    }
}

- (void)cleanup
{
    [self.newsObj release];
    [self.titleLabel release];
    [self.imgView release];
    [self.descriptionLabel release];
}

@end
