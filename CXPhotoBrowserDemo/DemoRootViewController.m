//
//  DemoRootViewController.m
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import "DemoRootViewController.h"
#import "CXPhotoBrowser.h"
#import "DemoPhoto.h"
#import "SDImageCache.h"
#import <QuartzCore/QuartzCore.h>
@interface DemoRootViewController ()
<CXPhotoBrowserDataSource, CXPhotoBrowserDelegate>
@property (nonatomic, strong) CXPhotoBrowser *browser;
@property (nonatomic, strong) NSMutableArray *photoDataSource;
- (IBAction)showBrowserWithPresent:(id)sender;
- (IBAction)showBrowserWithPush:(id)sender;
//PhotBrower Actions
- (void)photoBrowserDidTapDoneButton:(id)sender;
@end

@implementation DemoRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.photoDataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    self.browser = [[CXPhotoBrowser alloc] initWithDataSource:self delegate:self];
    self.browser.wantsFullScreenLayout = NO;
    
    NSArray *imageURLs = [NSArray arrayWithObjects:@"http://wallpaperdev.com/stock/cute-cat-close-up.jpg",@"http://3.bp.blogspot.com/-J6WK7HAE_78/T1lvmpI8FAI/AAAAAAAACSI/xrcJT7el-Tk/s1600/cute+cat+funny.jpg",@"http://4.bp.blogspot.com/_Dei71iQMoec/S8T1RQvIPbI/AAAAAAAAGK0/jDBh_BKubx0/s1600/cat50.jpg",@"http://images1.fanpop.com/images/image_uploads/Funny-Cat-Pictures-animal-humor-935491_500_375.jpg",@"http://zef.me/wp-content/uploads/2008/02/funny-cat.jpg", @"", nil];
    
    for (int i = 0; i < [imageURLs count]; i++)
    {
        NSURL *imgURL = [NSURL URLWithString:[imageURLs objectAtIndex:i]];
        DemoPhoto *photo = [[DemoPhoto alloc] initWithURL:imgURL];
        
        [self.photoDataSource addObject:photo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
- (IBAction)showBrowserWithPresent:(id)sender
{
    [self presentViewController:self.browser animated:YES completion:^{
        
    }];
}

- (IBAction)showBrowserWithPush:(id)sender
{
    
}

#pragma mark - CXPhotoBrowserDataSource
- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser
{
    return [self.photoDataSource count];
}
- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photoDataSource.count)
        return [self.photoDataSource objectAtIndex:index];
    return nil;
}
// optional
//- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoLoadingViewAtIndex:(NSUInteger)index;
- (CXBrowserNavBarView *)browserNavigationBarViewOfOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    CXBrowserNavBarView *navBarView = [[CXBrowserNavBarView alloc] initWithFrame:frame];
    [navBarView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:10.]];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setFrame:CGRectMake(size.width - 50, 12, 38, 20)];
    [doneButton addTarget:self action:@selector(photoBrowserDidTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton.layer setMasksToBounds:YES];
    [doneButton.layer setCornerRadius:4.0];
    [doneButton.layer setBorderWidth:1.0];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
    [doneButton.layer setBorderColor:colorref];
    doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [navBarView addSubview:doneButton];
    
    return navBarView;
}

- (CXBrowserToolBarView *)browserToolBarViewOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    CXBrowserToolBarView *toolBarView = [[CXBrowserToolBarView alloc] initWithFrame:frame];
    [toolBarView setBackgroundColor:[UIColor clearColor]];
    
    return toolBarView;
}
#pragma mark - CXPhotoBrowserDelegate
- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    NSLog(@"index:%i",index);
}

#pragma mark - PhotBrower Actions
- (void)photoBrowserDidTapDoneButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
