//
//  DemoPhoto.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "DemoPhoto.h"
#import "DemoPhotoLoadingView.h"
#import "SDWebImageManager.h"
@interface DemoPhoto ()
{
    DemoPhotoLoadingView *_photoLoadingView;
}
@property (nonatomic, strong) DemoPhotoLoadingView *photoLoadingView;

@end

@implementation DemoPhoto
@synthesize photoLoadingView = _photoLoadingView;
- (void)loadImageFromFileAsync:(NSString *)path
{
    [super loadImageFromFileAsync:path];
}

- (void)loadImageFromURLAsync:(NSURL *)url
{
    [self notifyImageDidStartLoad];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:url options:0 progress:^(NSUInteger receivedSize, long long expectedSize)
    {
        [_photoLoadingView loadWithReceivedSize:receivedSize expectedSize:expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (!error)
        {
            _underlyingImage = image;
            
            [self notifyImageDidFinishLoad];
        }
        else
        {
            [self notifyImageDidFailLoadWithError:error];
        }
    }];
}

- (void)unloadImage
{
    [super unloadImage];
}

- (UIView *)photoLoadingView
{
    if (!_photoLoadingView)
    {
        _photoLoadingView = [[DemoPhotoLoadingView alloc] initWithPhoto:self];
    }
    
    return _photoLoadingView;
}
@end
