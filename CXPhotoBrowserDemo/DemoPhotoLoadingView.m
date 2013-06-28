//
//  DemoPhotoLoadingView.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "DemoPhotoLoadingView.h"

#define LOADING_FAILURE_LABEL 23412

@implementation DemoPhotoLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)displayFailure
{
    [self.progressView removeFromSuperview];
    [self.indicator stopAnimating];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    [label setCenter:self.center];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"Loading Failure"];
    [label setFont:[UIFont boldSystemFontOfSize:20.]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTag:LOADING_FAILURE_LABEL];
    [self addSubview:label];
}

- (void)displayLoading
{
//    if (!self.indicator)
//    {
//        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [self.indicator setCenter:self.center];
//        [self.indicator setHidesWhenStopped:YES];
//        [self addSubview:self.indicator];
//    }
//    [self.indicator startAnimating];
}

#pragma mark - customlize method
- (void)loadWithReceivedSize:(NSUInteger)receivedSize expectedSize:(long)expectedSize
{
    if (self.indicator)
    {
        [self.indicator stopAnimating];
    }
    
    if (!self.progressView)
    {
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [self.progressView setFrame:CGRectMake( 0, 0, 200, 20)];
        [self.progressView setCenter:self.center];
        [self addSubview:self.progressView ];
    }
    float fReceivedSize = (float)receivedSize;
    float progress = (fReceivedSize  / expectedSize);
    if (progress != 1)
    {
        [self.progressView setProgress:progress];
    }
    else
    {
        [self.progressView removeFromSuperview];
    }    
}
@end
