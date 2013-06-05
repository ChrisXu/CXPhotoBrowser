//
//  CXBrowserNavBarView.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/22.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "CXBrowserNavBarView.h"
#import "CXPhotoBrowser.h"

@interface CXBrowserNavBarView ()
{
    __unsafe_unretained CXPhotoBrowser *_photoBrowser;
}
- (void)assignPhotoBrowser:(CXPhotoBrowser *)browser;
@end

@implementation CXBrowserNavBarView
@synthesize photoBrowser = _photoBrowser;

#pragma mark - PV
- (void)assignPhotoBrowser:(CXPhotoBrowser *)browser
{
    _photoBrowser = browser;
}

@end
