//
//  CXBrowserToolBarView.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "CXBrowserToolBarView.h"
#import "CXPhotoBrowser.h"

@interface CXBrowserToolBarView ()
{
    __unsafe_unretained CXPhotoBrowser *_photoBrowser;
}
- (void)assignPhotoBrowser:(CXPhotoBrowser *)browser;
@end

@implementation CXBrowserToolBarView
@synthesize photoBrowser = _photoBrowser;

#pragma mark - PV
- (void)assignPhotoBrowser:(CXPhotoBrowser *)browser
{
    _photoBrowser = browser;
}

@end
