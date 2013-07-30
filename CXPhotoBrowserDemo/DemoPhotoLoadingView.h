//
//  DemoPhotoLoadingView.h
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "CXPhotoLoadingView.h"

@interface DemoPhotoLoadingView : CXPhotoLoadingView
<CXPhotoLoadingViewProtocol>

@property (nonatomic, strong) UIProgressView *progressView;
- (void)loadWithReceivedSize:(NSUInteger)receivedSize expectedSize:(long)expectedSize;

@end
