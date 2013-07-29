//
//  CXPhotoLoadingView.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/22.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "CXPhotoLoadingView.h"
#import "CXPhotoBrowser.h"

@interface CXPhotoLoadingView ()
{
    __unsafe_unretained CXPhotoBrowser *_photoBrowser;
}
@end

@implementation CXPhotoLoadingView
@synthesize photoBrowser = _photoBrowser;

#pragma mark - PV

- (void)displayLoading
{
    [NSException raise:NSInternalInconsistencyException format:@"Subclasses must override %@", NSStringFromSelector(_cmd)];
//    NSLog(@"displayLoading");
}
- (void)displayFailure
{
    [NSException raise:NSInternalInconsistencyException format:@"Subclasses must override %@", NSStringFromSelector(_cmd)];
//    NSLog(@"displayFailure");
}
@end
