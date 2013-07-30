//
//  CXTapDetectingView.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "CXTapDetectingView.h"

@implementation CXTapDetectingView
@synthesize tapDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)handleSingleTap:(UITouch *)touch
{
    
}

- (void)handleDoubleTap:(UITouch *)touch
{
    
}

- (void)handleTripleTap:(UITouch *)touch
{
    
}
@end
