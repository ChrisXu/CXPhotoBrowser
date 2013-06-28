//
//  CXPhotoBrowser.h
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/19.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXPhoto.h"
#import "CXPhotoProtocol.h"
#import "CXPhotoLoadingView.h"
#import "CXBrowserNavBarView.h"
#import "CXBrowserToolBarView.h"
@protocol CXPhotoBrowserDataSource;
@protocol CXPhotoBrowserDelegate;
@interface CXPhotoBrowser : UIViewController
<UIScrollViewDelegate>
{
    // Controls (NavigationBar & ToolBar)
    CXBrowserNavBarView *browserNavigationBarView;
    CXBrowserToolBarView *browserToolBarView;
}
//@property (nonatomic, assign) id<CXPhotoBrowserDataSource> dataSource;
//@property (nonatomic, assign) id<CXPhotoBrowserDelegate> delegate;
@property (nonatomic, assign) CXPhotoLoadingView *currentPhotoLoadingView;
@property (nonatomic, readonly) NSUInteger photoCount;
@property (nonatomic, readonly) NSUInteger currentPageIndex;

- (id)initWithDataSource:(id <CXPhotoBrowserDataSource>)dataSource  delegate:(id <CXPhotoBrowserDelegate>)delegate;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setInitialPageIndex:(NSUInteger)index;

// Customlize view
- (void)resetCustomlizeBrowserNavigationBarView;
- (void)resetCustomlizeBrowserToolBarView;

// Navigation & control / Hiding / Showing
- (void)setControlBarViewsHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@protocol CXPhotoBrowserDataSource <NSObject>
@required
- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser;
- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;
@optional
//- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoLoadingViewAtIndex:(NSUInteger)index;
- (CXBrowserNavBarView *)browserNavigationBarViewOfOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size;
- (CXBrowserToolBarView *)browserToolBarViewOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size;
//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;
@end

@protocol CXPhotoBrowserDelegate <NSObject>

@optional
- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;

@end