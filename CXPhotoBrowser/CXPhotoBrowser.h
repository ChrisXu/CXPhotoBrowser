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

typedef enum
{
    CXPhotoStartLoading = 0,
    CXPhotoFinishLoading = 1,
    CXPhotoDidFailLoading = 2
}CXPhotoLoadingStatus;

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
- (void)setToolBarViewsHidden:(BOOL)hidden animated:(BOOL)animated;

//Reload
//- (void)reloadCurrentPhoto; undone
@end

@protocol CXPhotoBrowserDataSource <NSObject>
@required

/**
 @param photoBrower The current photobrowser to present.
 
 @return number of photos.
 */
- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser;

/**
 @param photoBrower The current photobrowser to present.
 @param index 
 
 @return CXPhoto for showing.
 */
- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;
@optional

/**
 @param orientation 
 
 @return Height for your customlize NavigationBarView.
 */
- (CGFloat)heightForNavigationBarInInterfaceOrientation:(UIInterfaceOrientation)orientation;

/**
 @param orientation 
 
 @return Height for your customlize ToolBarView.
 */
- (CGFloat)heightForToolBarInInterfaceOrientation:(UIInterfaceOrientation)orientation;

/**
 @param photoBrower The current photobrowser to present.
 @param size NavigationBarView will be resize as this parameter. Make sure your view will fit the size.
 
 @return A customlize NavigationBarView to show on top.
 */
- (CXBrowserNavBarView *)browserNavigationBarViewOfOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size;

/**
 @param photoBrower The current photobrowser to present.
 @param size ToolBarView will be resize as this parameter. Make sure your view will fit the size.
 
 @return A customlize ToolBarView to show on bottom.
 */
- (CXBrowserToolBarView *)browserToolBarViewOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size;
@end

@protocol CXPhotoBrowserDelegate <NSObject>

@optional

/**
 @param photoBrower The current photobrowser to present.
 @param index The current showing index in photoBrowser.
 */
- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;

/**
 @param photoBrower The current photobrowser to present.
 @param index The current showing index in photoBrowser.
 @param status 
 */
//- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser currentPhotoAtIndex:(NSUInteger)index didFinishedLoadingWithStatus:(CXPhotoLoadingStatus)status;

/**

 
 @return supportReload.
 */
- (BOOL)supportReload;
@end