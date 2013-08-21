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
{
    NSArray *imageURLs;
    NSArray *descriptions;
    
    CXBrowserNavBarView *navBarView;
    CXBrowserToolBarView *toolBarView;
    
    BOOL _like;
}

#define BROWSER_TITLE_LBL_TAG 12731
#define BROWSER_DESCRIP_LBL_TAG 178273
#define BROWSER_LIKE_BTN_TAG 12821

@property (nonatomic, strong) CXPhotoBrowser *browser;
@property (nonatomic, strong) NSMutableArray *photoDataSource;
- (IBAction)showBrowserWithPresent:(id)sender;
- (IBAction)showBrowserWithPush:(id)sender;
//PhotBrower Actions
- (void)photoBrowserDidTapDoneButton:(UIButton *)sender;
- (void)photoBrowserDidTapLIKEButton:(UIButton *)sender;
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
    
    imageURLs = [[NSArray alloc] initWithObjects:@"http://beauty-places.com/wp-content/uploads/2012/10/TaiPei-101-Wallpaper3.jpg",@"http://4.bp.blogspot.com/_Dei71iQMoec/S8T1RQvIPbI/AAAAAAAAGK0/jDBh_BKubx0/s1600/cat50.jpg",@"http://images1.fanpop.com/images/image_uploads/Funny-Cat-Pictures-animal-humor-935491_500_375.jpg",@"http://zef.me/wp-content/uploads/2008/02/funny-cat.jpg", @"http://wallpaperdev.com/stock/cute-cat-close-up.jpg",@"http://3.bp.blogspot.com/-J6WK7HAE_78/T1lvmpI8FAI/AAAAAAAACSI/xrcJT7el-Tk/s1600/cute+cat+funny.jpg", nil];
    
    descriptions = [[NSArray alloc] initWithObjects:@"Taipei 101 (Chinese: 臺北101 / 台北101), formerly known as the Taipei World Financial Center, is a landmark skyscraper located in Xinyi District, Taipei, Taiwan. ",@"http://3.bp.blogspot.com/-J6WK7HAE_78/T1lvmpI8FAI/AAAAAAAACSI/xrcJT7el-Tk/s1600/cute+cat+funny.jpg",@"http://4.bp.blogspot.com/_Dei71iQMoec/S8T1RQvIPbI/AAAAAAAAGK0/jDBh_BKubx0/s1600/cat50.jpg",@"http://images1.fanpop.com/images/image_uploads/Funny-Cat-Pictures-animal-humor-935491_500_375.jpg",@"http://zef.me/wp-content/uploads/2008/02/funny-cat.jpg", @"",@"like.png", nil];
    
//    for (int i = 0; i < [imageURLs count]; i++)
//    {
//        NSURL *imgURL = [NSURL URLWithString:[imageURLs objectAtIndex:i]];
//        DemoPhoto *photo = [[DemoPhoto alloc] initWithURL:imgURL];
//        
//        [self.photoDataSource addObject:photo];
//    }
    
    for (int i = 0; i < [imageURLs count]; i++)
    {
        NSURL *imgURL = [NSURL URLWithString:[imageURLs objectAtIndex:i]];
        CXPhoto *photo = [[CXPhoto alloc] initWithURL:imgURL];
        
        [self.photoDataSource addObject:photo];
    }
    
    CXPhoto *image = [[CXPhoto alloc] initWithImage:[UIImage imageNamed:@"like.png"]];
    [self.photoDataSource addObject:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
- (IBAction)showBrowserWithPresent:(id)sender
{
    [self.browser setInitialPageIndex:2];
    [self presentViewController:self.browser animated:YES completion:^{
        
    }];
}

- (IBAction)showBrowserWithPush:(id)sender
{
    [self.browser setInitialPageIndex:4];
    [self.navigationController pushViewController:self.browser animated:YES];
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

- (CXBrowserNavBarView *)browserNavigationBarViewOfOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    if (!navBarView)
    {
        navBarView = [[CXBrowserNavBarView alloc] initWithFrame:frame];
        
        [navBarView setBackgroundColor:[UIColor clearColor]];
        
        UIView *bkgView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, size.width, size.height)];
        [bkgView setBackgroundColor:[UIColor blackColor]];
        bkgView.alpha = 0.2;
        bkgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [navBarView addSubview:bkgView];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        [doneButton setTitle:NSLocalizedString(@"Done",@"Dismiss button title") forState:UIControlStateNormal];
        [doneButton setFrame:CGRectMake(size.width - 60, 10, 50, 30)];
        [doneButton addTarget:self action:@selector(photoBrowserDidTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton.layer setMasksToBounds:YES];
        [doneButton.layer setCornerRadius:4.0];
        [doneButton.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        [doneButton.layer setBorderColor:colorref];
        doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [navBarView addSubview:doneButton];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFrame:CGRectMake((size.width - 60)/2, 10, 60, 40)];
        [titleLabel setCenter:navBarView.center];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20.]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [titleLabel setTag:BROWSER_TITLE_LBL_TAG];
        [navBarView addSubview:titleLabel];
    }
    
    return navBarView;
}

- (CXBrowserToolBarView *)browserToolBarViewOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    
    if (!toolBarView)
    {
        toolBarView = [[CXBrowserToolBarView alloc] initWithFrame:frame];
        [toolBarView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *bkgImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, size.width, size.height)];
        [bkgImageView setImage:[UIImage imageNamed:@"toolbarBKG.png"]];
        bkgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [toolBarView addSubview:bkgImageView];
        
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        [likeButton setTitle:NSLocalizedString(@"LIKE",@"") forState:UIControlStateNormal];
        [likeButton setFrame:CGRectMake(20, 10, 70, 30)];
        [likeButton addTarget:self action:@selector(photoBrowserDidTapLIKEButton:) forControlEvents:UIControlEventTouchUpInside];
        [likeButton.layer setMasksToBounds:YES];
        [likeButton.layer setCornerRadius:4.0];
        [likeButton.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        [likeButton.layer setBorderColor:colorref];
        likeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [likeButton setTag:BROWSER_LIKE_BTN_TAG];
        [toolBarView addSubview:likeButton];
        
        UILabel *descripLabel = [[UILabel alloc] init];
        [descripLabel setFrame:CGRectMake( 10, 50, size.width - 20, size.height - 50)];
        [descripLabel setTextAlignment:NSTextAlignmentLeft];
        [descripLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        [descripLabel setTextColor:[UIColor whiteColor]];
        [descripLabel setBackgroundColor:[UIColor clearColor]];
        [descripLabel setNumberOfLines:0];
        descripLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [descripLabel setTag:BROWSER_DESCRIP_LBL_TAG];
        [toolBarView addSubview:descripLabel];
    }
    
    return toolBarView;
}
#pragma mark - CXPhotoBrowserDelegate
- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    UILabel *titleLabel = (UILabel *)[navBarView viewWithTag:BROWSER_TITLE_LBL_TAG];
    if (titleLabel)
    {
        titleLabel.text = [NSString stringWithFormat:@"%i of %i", index+1, photoBrowser.photoCount];
    }
    
    UIButton *likeButton = (UIButton *)[toolBarView viewWithTag:BROWSER_LIKE_BTN_TAG];
    if (likeButton)
    {
        _like = YES;
        [likeButton setTitle:NSLocalizedString(@"LIKE",@"") forState:UIControlStateNormal];
    }
    
    UILabel *descripLabel = (UILabel *)[toolBarView viewWithTag:BROWSER_DESCRIP_LBL_TAG];
    if (descripLabel)
    {
        descripLabel.text = [NSString stringWithFormat:@"%@", [descriptions objectAtIndex:index]];
    }
}

- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didFinishLoadingWithCurrentImage:(UIImage *)currentImage
{
    if (currentImage) {
        //loading success
    }
    else {
        //loading failure
    }
}

- (BOOL)supportReload
{
    return YES;
}
#pragma mark - PhotBrower Actions
- (void)photoBrowserDidTapDoneButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoBrowserDidTapLIKEButton:(UIButton *)sender
{
    if (_like)
    {
        [sender setTitle:NSLocalizedString(@"UNLIKE",@"") forState:UIControlStateNormal];
    }
    else
    {
        [sender setTitle:NSLocalizedString(@"LIKE",@"") forState:UIControlStateNormal];
    }
    _like = !_like;
}
@end
