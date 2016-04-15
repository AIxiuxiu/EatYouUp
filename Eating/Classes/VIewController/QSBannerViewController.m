//
//  QSBannerViewController.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSBannerViewController.h"
#import "KDCycleBannerView.h"

@interface QSBannerViewController ()<KDCycleBannerViewDataource, KDCycleBannerViewDelegate>
{
    BOOL needToDownloadImages;
}
@property (nonatomic, strong) KDCycleBannerView *bannerView;

@end

@implementation QSBannerViewController

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images
{
    self = [super init];
    if (self) {
        _frame = frame;
        _images = images;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withImageUrls:(NSMutableArray *)urls
{
    self = [super init];
    if (self) {
        _frame = frame;
        _imageUrls = urls;
        needToDownloadImages = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, _frame.size.width, _frame.size.height);
    [self setupBannerView];
    if (needToDownloadImages) {
        [self downloadRemoteImages];
    }
    else{
        
    }
    
}

- (void)setupBannerView
{
    _bannerView = [KDCycleBannerView new];
    _bannerView.frame = _frame;
    _bannerView.datasource = self;
    _bannerView.delegate = self;
    _bannerView.continuous = YES;
    _bannerView.autoPlayTimeInterval = 5;
    [self.view addSubview:_bannerView];
}

- (void)downloadRemoteImages
{
    
}

#pragma mark - KDCycleBannerViewDataource

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView {
    return self.imageUrls;
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
    return UIViewContentModeScaleAspectFill;
}

//- (UIImage *)placeHolderImageOfZeroBannerView {
//    return [UIImage imageNamed:@"image1"];
//}

#pragma mark - KDCycleBannerViewDelegate

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index {
    //NSLog(@"didScrollToIndex:%ld", (long)index);
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index {
    NSLog(@"didSelectedAtIndex:%ld", (long)index);
    if (self.onTapBanner) {
        self.onTapBanner(index);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
