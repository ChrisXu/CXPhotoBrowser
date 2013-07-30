//
//  CXPhotoProtocol.h
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/19.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NFCXPhotoImageDidStartLoad @"NFCXPhotoImageDidStartLoad"
#define NFCXPhotoImageDidFinishLoad @"NFCXPhotoImageDidFinishLoad"
#define NFCXPhotoImageDidFailLoadWithError @"NFCXPhotoImageDidFailLoadWithError"
#define NFCXPhotoImageDidStartReload @"NFCXPhotoImageDidStartReload"

@protocol CXPhotoProtocol <NSObject>

@required

- (UIImage *)underlyingImage;
- (void)loadUnderlyingImageAndNotify;
- (void)unloadUnderlyingImage;

@optional

- (UIView *)photoLoadingView;
//Notify
- (void)notifyImageDidStartLoad;
- (void)notifyImageDidFinishLoad;
- (void)notifyImageDidFailLoadWithError:(NSError *)error;
- (void)notifyImageDidStartReload;

@end
