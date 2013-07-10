//
//  CXTapDetectingImageView.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "CXTapDetectingImageView.h"

@interface CXTapDetectingImageView ()
{
    CGPoint panGestureStartLocation;
}

- (void)setup;
- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture;
@end

@implementation CXTapDetectingImageView

@synthesize tapDelegate;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
        [self setup];
	}
	return self;
}

- (id)initWithImage:(UIImage *)image {
	if ((self = [super initWithImage:image])) {
        [self setup];
	}
	return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
	if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
        [self setup];
	}
	return self;
}

#pragma mark - 
- (void)setup
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    [longPressGesture setNumberOfTouchesRequired:1];
    [longPressGesture setMinimumPressDuration:1.0f];
    [self addGestureRecognizer:longPressGesture];
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        
    }
}

- (void)handleSingleTap:(UITouch *)touch {
//    NSLog(@"handleSingleTap");
	if ([tapDelegate respondsToSelector:@selector(imageView:singleTapDetected:)])
		[tapDelegate imageView:self singleTapDetected:touch];
}

- (void)handleDoubleTap:(UITouch *)touch {
//    NSLog(@"handleDoubleTap");
	if ([tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)])
		[tapDelegate imageView:self doubleTapDetected:touch];
}

- (void)handleTripleTap:(UITouch *)touch {
//    NSLog(@"handleTripleTap");
	if ([tapDelegate respondsToSelector:@selector(imageView:tripleTapDetected:)])
		[tapDelegate imageView:self tripleTapDetected:touch];
}

#pragma mark - Touched
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = touch.tapCount;
	switch (tapCount) {
		case 1:
			[self handleSingleTap:touch];
			break;
		case 2:
			[self handleDoubleTap:touch];
			break;
		case 3:
			[self handleTripleTap:touch];
			break;
		default:
			break;
	}
	[[self nextResponder] touchesEnded:touches withEvent:event];
}


@end
