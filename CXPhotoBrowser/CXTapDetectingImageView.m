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
        NSLog(@"longPress:%@",self.image);
    }
}

@end
