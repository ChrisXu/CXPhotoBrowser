//
//  CXPhotoLoadingViewProtocol.h
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/5/21.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CXPhotoLoadingViewProtocol <NSObject>

@required
- (void)displayLoading;
- (void)displayFailure;

@end
