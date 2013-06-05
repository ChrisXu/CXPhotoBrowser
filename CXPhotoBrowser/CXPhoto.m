//
//  CXPhoto.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/18.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "CXPhoto.h"

@interface CXPhoto ()
{
    // Image Sources
    NSString *_photoPath;
    NSURL *_photoURL;
    
    // Other
    NSString *_caption;
}


@end

@implementation CXPhoto
@synthesize underlyingImage = _underlyingImage,
caption = _caption;

#pragma mark Class Methods

+ (CXPhoto *)photoWithImage:(UIImage *)image {
	return [[CXPhoto alloc] initWithImage:image];
}

+ (CXPhoto *)photoWithFilePath:(NSString *)path {
	return [[CXPhoto alloc] initWithFilePath:path];
}

+ (CXPhoto *)photoWithURL:(NSURL *)url {
	return [[CXPhoto alloc] initWithURL:url];
}

#pragma mark NSObject

- (id)initWithImage:(UIImage *)image {
	if ((self = [super init])) {
		_underlyingImage = image;
	}
	return self;
}

- (id)initWithFilePath:(NSString *)path {
	if ((self = [super init])) {
		_photoPath = [path copy];
	}
	return self;
}

- (id)initWithURL:(NSURL *)url {
	if ((self = [super init])) {
		_photoURL = [url copy];
	}
	return self;
}

#pragma mark - Async Loading
- (void)loadImageFromFileAsync:(NSString *)path
{
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:&error];
    if (!error) {
        _underlyingImage = [[UIImage alloc] initWithData:data];
        [self notifyImageDidFinishLoad];
    } else {
        _underlyingImage = nil;
        [self notifyImageDidFailLoadWithError:error];
    }
}

- (void)loadImageFromURLAsync:(NSURL *)url
{
    //implement
}

- (void)unloadImage
{
	if (self.underlyingImage && (_photoPath || _photoURL)) {
		_underlyingImage = nil;
	}
}

//- (UIView *)photoLoadingView;
//{
//    return _photoLoadingView;
//}

#pragma mark - CXPhotoProtocol Notify
- (void)notifyImageDidStartLoad
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NFCXPhotoImageDidStartLoad object:self];
    });
}

- (void)notifyImageDidFinishLoad
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NFCXPhotoImageDidFinishLoad object:self];
    });
}

- (void)notifyImageDidFailLoadWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *notifyInfo = [NSDictionary dictionaryWithObjectsAndKeys:error,@"error", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NFCXPhotoImageDidFailLoadWithError object:self userInfo:notifyInfo];
    });
}

#pragma mark - CXPhotoProtocol Image Process
- (UIImage *)underlyingImage
{
    return _underlyingImage;
}

- (void)loadUnderlyingImageAndNotify
{
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (self.underlyingImage) {
        // Image already loaded
        [self notifyImageDidFinishLoad];
    } else {
        if (_photoPath) {
            // Load async from file
            [self performSelectorInBackground:@selector(loadImageFromFileAsync:) withObject:_photoPath];
        } else if (_photoURL) {
            // Load async from web
            [self performSelectorInBackground:@selector(loadImageFromURLAsync:) withObject:_photoURL];
        } else {
            // Failed - no source
            _underlyingImage = nil;
            [self notifyImageDidFinishLoad];
        }
    }
}

- (void)unloadUnderlyingImage
{
    [self performSelector:@selector(unloadImage)];
}

@end
