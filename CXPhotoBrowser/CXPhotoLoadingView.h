//
//  CXPhotoLoadingView.h
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/22.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXPhotoLoadingViewProtocol.h"

@class CXPhotoBrowser;

@interface CXPhotoLoadingView : UIView
<CXPhotoLoadingViewProtocol>

@property (nonatomic, assign, readonly) CXPhotoBrowser *photoBrowser;

@end
