//
//  CXZoomingScrollView.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/19.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "CXZoomingScrollView.h"
#import "CXPhotoBrowser.h"

#define PHOTO_LOADIG_VIEW_TAG 35271

@interface CXPhotoBrowser ()
- (UIImage *)imageForPhoto:(id<CXPhotoProtocol>)photo;

@end

@interface CXZoomingScrollView ()
{
    CGFloat zoomScaleFromInit;
    BOOL shouldSupportedPanGesture;
}
@property (nonatomic, assign) CXPhotoBrowser *photoBrowser;

- (void)layoutPhotoLoadingView;

@end

@implementation CXZoomingScrollView
@synthesize photoBrowser = _photoBrowser, photo = _photo;

- (id)initWithPhotoBrowser:(CXPhotoBrowser *)browser
{
    if ((self = [super init]))
    {
        self.isPhotoSupportedPanGesture = YES;
        self.isPhotoSupportedReload = YES;
        // Delegate
        self.photoBrowser = browser;
        
		// Tap view for background
		_tapView = [[CXTapDetectingView alloc] initWithFrame:self.bounds];
		_tapView.tapDelegate = self;
		_tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_tapView.backgroundColor = [UIColor blackColor];
		[self addSubview:_tapView];
		
		// Image view
		_photoImageView = [[CXTapDetectingImageView alloc] initWithFrame:CGRectZero];
		_photoImageView.tapDelegate = self;
		_photoImageView.contentMode = UIViewContentModeCenter;
		_photoImageView.backgroundColor = [UIColor blackColor];
		[self addSubview:_photoImageView];
		
		// Setup
		self.backgroundColor = [UIColor blackColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)layoutSubviews {
	
	// Update tap view frame
	_tapView.frame = self.bounds;
	
	// Super
	[super layoutSubviews];
	
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
	} else {
        frameToCenter.origin.x = 0;
	}
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
	} else {
        frameToCenter.origin.y = 0;
	}
    
	// Center
	if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
    {
		_photoImageView.frame = frameToCenter;
	}
    
}

#pragma mark - Setter
- (void)setPhoto:(id<CXPhotoProtocol>)photo {
    _photoImageView.image = nil; // Release image
    if (_photo != photo)
    {
        _photo = photo;
    }
    
    if (_photo)
    {
        [self displayImage];
    }
}

#pragma mark - PV
- (void)layoutPhotoLoadingView
{
    [_photoLoadingView removeFromSuperview];
    if ([_photo respondsToSelector:@selector(photoLoadingView)])
    {
        _photoLoadingView = (CXPhotoLoadingView *)[_photo photoLoadingView];
        _photoLoadingView.supportReload = self.isPhotoSupportedReload;
        [_photoLoadingView setTag:PHOTO_LOADIG_VIEW_TAG];
        [_photoLoadingView setFrame:_photoBrowser.view.bounds];
        _photoLoadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self setUserInteractionEnabled:NO];
        [self addSubview:_photoLoadingView];
    }
}

#pragma mark - PB
- (void)displayImageStartLoading
{
    if ([_photoLoadingView respondsToSelector:@selector(displayLoading)])
    {
        [_photoLoadingView displayLoading];
    }
}

- (void)displayImage
{
    if (_photo && !_photoImageView.image)
    {
        [self setUserInteractionEnabled:YES];
		// Reset
		self.maximumZoomScale = 1;
		self.minimumZoomScale = 1;
		self.zoomScale = 1;
		self.contentSize = CGSizeMake(0, 0);
		
		// Get image from browser as it handles ordering of fetching
		UIImage *img = [self.photoBrowser imageForPhoto:_photo];
		if (img)
        {
            id photoBrowserDelegate = self.photoBrowser.delegate;
            if (photoBrowserDelegate && [photoBrowserDelegate respondsToSelector:@selector(photoBrowser:didFinishLoadingWithCurrentImage:)]) {
                [photoBrowserDelegate photoBrowser:self.photoBrowser didFinishLoadingWithCurrentImage:img];
            }
            
            [_photoLoadingView removeFromSuperview];
			// Set image
			_photoImageView.image = img;
			_photoImageView.hidden = NO;
			
			// Setup photo frame
			CGRect photoImageViewFrame;
			photoImageViewFrame.origin = CGPointZero;
			photoImageViewFrame.size = img.size;
			_photoImageView.frame = photoImageViewFrame;
			self.contentSize = photoImageViewFrame.size;
            
			// Set zoom to minimum zoom
			[self setMaxMinZoomScalesForCurrentBounds];
			
		}
        else
        {
			// Hide image view
            [self layoutPhotoLoadingView];
			_photoImageView.hidden = YES;
		}
		[self setNeedsLayout];
	}
}

- (void)displayImageFailure
{
    id photoBrowserDelegate = self.photoBrowser.delegate;
    if (photoBrowserDelegate && [photoBrowserDelegate respondsToSelector:@selector(photoBrowser:didFinishLoadingWithCurrentImage:)]) {
        [photoBrowserDelegate photoBrowser:self.photoBrowser didFinishLoadingWithCurrentImage:nil];
    }
    [self setUserInteractionEnabled:YES];
    [_photoLoadingView displayFailure];
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    // Reset
	self.maximumZoomScale = 1;
	self.minimumZoomScale = 1;
	self.zoomScale = 1;
	
	// Bail
	if (_photoImageView.image == nil) return;
	
	// Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.frame.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
	
	// If image is smaller than the screen then ensure we show it at
	// min scale of 1
	if (xScale > 1 && yScale > 1) {
		minScale = 1.0;
	}
    
	// Calculate Max
	CGFloat maxScale = 2.0; // Allow double scale
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	
	// Set
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
	zoomScaleFromInit = minScale;
	// Reset position
	_photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
	[self setNeedsLayout];
}

- (void)prepareForReuse
{
    shouldSupportedPanGesture = NO;
    self.photo = nil;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _photoImageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    shouldSupportedPanGesture = ((self.zoomScale == zoomScaleFromInit) && self.isPhotoSupportedPanGesture);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

#pragma mark - Touch Event
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    
    return view;
}

- (void)handleImageViewSingleTap:(CGPoint)touchPoint {
    
	[_photoBrowser performSelector:@selector(toggleControls) withObject:nil afterDelay:0.2];
}

- (void)handleImageViewDoubleTap:(CGPoint)touchPoint {
	
	// Cancel any single tap handling
	[NSObject cancelPreviousPerformRequestsWithTarget:_photoBrowser];
	
	// Zoom
	if (self.zoomScale == self.maximumZoomScale) {
		
		// Zoom out
        [_photoBrowser setToolBarViewsHidden:NO animated:YES];
		[self setZoomScale:self.minimumZoomScale animated:YES];
		
	} else {
		
		// Zoom in
        [_photoBrowser setToolBarViewsHidden:YES animated:YES];
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
		
	}
	
	// Delay controls
}
#pragma mark - CXTapDetectingImageViewDelegate
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch {
    [self handleImageViewSingleTap:[touch locationInView:imageView]];
}
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleImageViewDoubleTap:[touch locationInView:imageView]];
}

#pragma mark - CXTapDetectingViewDelegate

@end
