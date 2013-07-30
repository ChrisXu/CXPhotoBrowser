//
//  CXPhotoLoadingView.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/22.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "CXPhotoLoadingView.h"
#import "CXPhotoBrowser.h"
#import <QuartzCore/QuartzCore.h>

@interface CXPhotoLoadingView ()
{
    __unsafe_unretained CXPhotoBrowser *_photoBrowser;
    
    UIButton *reloadButton;
    UILabel *failureLabel;
}
@property (nonatomic, assign) CXPhoto *photo;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation CXPhotoLoadingView
@synthesize photo = _photo;
@synthesize supportReload = _supportReload;
- (id)initWithPhoto:(CXPhoto *)photo
{
    self = [super init];
    if (self)
    {
        _photo = photo;
        reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        failureLabel = [[UILabel alloc] init];
    }
    return self;
}
#pragma mark - PV

- (void)displayLoading
{
    [reloadButton removeFromSuperview];
    [failureLabel removeFromSuperview];
    if (!self.indicator)
    {
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.indicator setCenter:self.center];
        [self.indicator setHidesWhenStopped:YES];
        [self addSubview:self.indicator];
    }
    [self.indicator startAnimating];
}

- (void)displayFailure
{
    [self.indicator stopAnimating];
    
    [reloadButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.]];
    [reloadButton setTitle:NSLocalizedString(@"Reload",@"Reload") forState:UIControlStateNormal];
    [reloadButton setFrame:CGRectMake(20, 10, 100, 30)];
    [reloadButton setCenter:self.center];
    [reloadButton addTarget:self.photo action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
    [reloadButton.layer setMasksToBounds:YES];
    [reloadButton.layer setCornerRadius:4.0];
    [reloadButton.layer setBorderWidth:1.0];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
    [reloadButton.layer setBorderColor:colorref];
    reloadButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:reloadButton];
    
    [reloadButton setHidden:!_supportReload];
    
    [failureLabel setFrame:CGRectMake(CGRectGetMidX(reloadButton.frame) - self.bounds.size.width/2, CGRectGetMinY(reloadButton.frame) - 60, self.bounds.size.width, 44)];
    [failureLabel setNumberOfLines:0.];
    [failureLabel setTextAlignment:NSTextAlignmentCenter];
    [failureLabel setText:NSLocalizedString(@"Sorry ! Unable to load image.",nil)];
    [failureLabel setFont:[UIFont boldSystemFontOfSize:20.]];
    [failureLabel setTextColor:[UIColor whiteColor]];
    [failureLabel setBackgroundColor:[UIColor clearColor]];
    failureLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:failureLabel];
}
@end
