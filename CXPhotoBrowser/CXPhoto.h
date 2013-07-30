//
//  CXPhoto.h
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/18.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXPhotoProtocol.h"
#import "CXPhotoLoadingView.h"

@interface CXPhoto : NSObject
<CXPhotoProtocol>
{
    // Image
    UIImage *_underlyingImage;
}

@property (nonatomic, strong, readonly) UIImage *underlyingImage;

// Class
+ (CXPhoto *)photoWithImage:(UIImage *)image;
+ (CXPhoto *)photoWithFilePath:(NSString *)path;
+ (CXPhoto *)photoWithURL:(NSURL *)url;

// Init
- (id)initWithImage:(UIImage *)image;
- (id)initWithFilePath:(NSString *)path;
- (id)initWithURL:(NSURL *)url;

//Load Async
- (void)loadImageFromFileAsync:(NSString *)path;
- (void)loadImageFromURLAsync:(NSURL *)url;
- (void)unloadImage;
- (void)reloadImage;

@end
