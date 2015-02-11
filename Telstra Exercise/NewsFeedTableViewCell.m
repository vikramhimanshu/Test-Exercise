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
@property (assign,nonatomic) NewsFeed *newsObj;

@end

@implementation NewsFeedTableViewCell

-(void)dealloc
{
    [self.titleLabel release];
    [self.imgView release];
    [self.descriptionLabel release];
    [super dealloc];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.networkRequest = [NetworkRequest sharedManager];
        CGFloat contentWidth = CGRectGetWidth(self.contentView.frame);
        CGFloat contentHeight = MAX(contentWidth/4,CGRectGetHeight(self.contentView.frame));
        //TitleView's Frame
        CGRect titleFrame = CGRectZero;
        titleFrame.size.width = contentWidth-(PADDING*2);
        titleFrame.size.height = contentHeight/4;
        titleFrame.origin.x = PADDING;
        titleFrame.origin.y = PADDING;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.textColor = [UIColor blueColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];

//        self.titleLabel.layer.borderColor = [UIColor greenColor].CGColor;
//        self.titleLabel.layer.borderWidth = 1.0;
        [self.contentView addSubview:self.titleLabel];
        
        //Description View's Frame
        CGRect descriptionFrame = CGRectZero;
        descriptionFrame.size.width = contentWidth*(2/3);
        descriptionFrame.size.height = contentHeight*(3/4);
        descriptionFrame.origin.x = PADDING;
        descriptionFrame.origin.y = CGRectGetHeight(self.titleLabel.frame) + titleFrame.origin.y;
        self.descriptionLabel = [[UILabel alloc] initWithFrame:descriptionFrame];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.font = [UIFont systemFontOfSize:12];
        //
//        self.descriptionLabel.layer.borderColor = [UIColor redColor].CGColor;
//        self.descriptionLabel.layer.borderWidth = 1.0;
        
        [self.contentView addSubview:self.descriptionLabel];

        CGRect imgViewFrame = CGRectZero;
        imgViewFrame.size.width = contentWidth/3;
        imgViewFrame.size.height = contentWidth/4;
        imgViewFrame.origin.x = (contentWidth-imgViewFrame.size.width) - PADDING;
        imgViewFrame.origin.y = (contentHeight-imgViewFrame.size.height) - PADDING;

        self.imgView = [[UIImageView alloc] initWithFrame:imgViewFrame];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        //
//        self.imgView.layer.borderColor = [UIColor blueColor].CGColor;
//        self.imgView.layer.borderWidth = 1.0;
        
        [self.contentView addSubview:self.imgView];
        //
//        self.layer.borderColor = [UIColor blackColor].CGColor;
//        self.layer.borderWidth = 1.0;
    }
    return self;
}

-(void)setupWithNewsFeedData:(NewsFeed *)obj
{
    self.newsObj = obj;
    if (self.newsObj.title) {
        self.titleLabel.text = self.newsObj.title;
    } else {
        [self.titleLabel setHidden:YES];
    }
    
    if (self.newsObj.desc) {
        self.descriptionLabel.text = self.newsObj.desc;
    } else {
        [self.descriptionLabel setHidden:YES];
    }
    
    if (obj.imageHref) {
        [self.networkRequest getImageFromURL:[NSURL URLWithString:obj.imageHref]
                            withSuccessBlock:^(UIImage *image) {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    self.imgView.image = image;
                                    [self layoutIfNeeded];
                                }];
                            }
                             andFailureBlock:^(NSError *error) {
                                 [self.imgView setHidden:YES];
                                 [self layoutIfNeeded];
                             }];
    } else {
        [self.imgView setHidden:YES];
    }
}

-(void)prepareForReuse
{
    self.titleLabel.text = nil;
    [self.titleLabel setHidden:NO];
    self.descriptionLabel.text = nil;
    [self.descriptionLabel setHidden:NO];
    self.imgView.image = nil;
    [self.imgView setHidden:NO];
    self.networkRequest = [NetworkRequest sharedManager];
}

- (CGRect)availableContentView
{
    CGRect f = self.contentView.bounds;
    f.size.width -= 10;
    return f;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat viewWidth = CGRectGetWidth([self availableContentView]);
    [self.titleLabel sizeToFit];
    CGRect titleFrame = CGRectZero;
    if ([self.titleLabel text]) {
        titleFrame.size.width = viewWidth;
        titleFrame.size.height = 21;
        titleFrame.origin.x = PADDING;
        titleFrame.origin.y = PADDING;
        CGSize titleSize = [self.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:14]];
        CGFloat newTitleHeight = ceil(ceil(titleSize.width/(viewWidth-10))*titleSize.height);
        if (CGRectGetHeight(titleFrame)<newTitleHeight) {
            titleFrame.size.height = newTitleHeight;
        }
    }
    self.titleLabel.frame = titleFrame;
    
    CGRect imgViewFrame = CGRectZero;
    if (_newsObj.imageHref && !self.imgView.isHidden) {
        imgViewFrame.size.width = viewWidth/3;
        imgViewFrame.size.height = viewWidth/4;
        imgViewFrame.origin.x = (viewWidth-imgViewFrame.size.width);
    }
    
    [self.descriptionLabel sizeToFit];
    CGRect descriptionFrame = CGRectZero;
    if ([self.descriptionLabel text]) {
        descriptionFrame.size.width = viewWidth-CGRectGetWidth(imgViewFrame);
        descriptionFrame.size.height = CGRectGetHeight(imgViewFrame);
        descriptionFrame.origin.x = PADDING;
        descriptionFrame.origin.y = titleFrame.origin.y + titleFrame.size.height;
        CGSize desc = [self.descriptionLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
        CGFloat newDescHeight = ceil(ceil(desc.width/CGRectGetWidth(descriptionFrame))*desc.height);
        if (CGRectGetHeight(descriptionFrame)<newDescHeight) {
            descriptionFrame.size.height = newDescHeight;
        }
    }
    self.descriptionLabel.frame = descriptionFrame;
    
    CGFloat contentHeight = ((PADDING*2)+CGRectGetHeight(descriptionFrame)+CGRectGetHeight(titleFrame));
    
    imgViewFrame.origin.y = contentHeight - imgViewFrame.size.height - PADDING;
    self.imgView.frame = imgViewFrame;
}

@end
