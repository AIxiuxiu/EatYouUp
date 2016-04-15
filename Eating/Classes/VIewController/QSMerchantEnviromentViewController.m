//
//  QSMerchantEnviromentViewController.m
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMerchantEnviromentViewController.h"
#import "QSBannerViewController.h"
#import "QSAPIModel+Merchant.h"
#import "QSAPIClientBase+User.h"
#import "XLCycleScrollView.h"
#import "SocaialManager.h"

@interface QSMerchantEnviromentViewController ()<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, strong) QSBannerViewController *advertisementView;
@property (nonatomic, strong) XLCycleScrollView *slcycleView;
@end

@implementation QSMerchantEnviromentViewController

- (NSMutableArray *)imageUrls
{
    if (!_imageUrls) {
        _imageUrls = [[NSMutableArray alloc] init];
        for (NSDictionary *info in self.item.merchant_image_arr) {
            NSString *url = [info objectForKey:@"image_link"];
            [_imageUrls addObject:url];
        }
    }
    return _imageUrls;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
}

-(void)viewWillAppear:(BOOL)animated
{

    self.diggButton.selected = [self.item.isGood boolValue];

}

- (void)viewDidAppear:(BOOL)animated
{
    //self.diggButton.selected = [self.item.isGood boolValue];

}

- (void)setupUI
{
    self.titleLabel.text = self.item.merchant_name;
    [self setupBannerView];
}

- (void)setupBannerView
{
    __weak QSMerchantEnviromentViewController *weakSelf = self;
//    self.advertisementView = [[QSBannerViewController alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) withImageUrls:self.imageUrls];
//    [self.view insertSubview:self.advertisementView.view atIndex:0];
//    self.advertisementView.onTapBanner = ^(NSInteger index){
//
//    };
    self.slcycleView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 64, DeviceWidth, DeviceHeight-64)];
    self.slcycleView.delegate = self;
    self.slcycleView.datasource = self;
    [self.view insertSubview:self.slcycleView atIndex:0];
}


- (IBAction)onShareButtonAction:(id)sender
{
    [[SocaialManager sharedManager] showNewUIShareOnVC:self
                                               Content:@"s省心省力省钱省时间，“吃订你”轻轻一点立即省"
                                              UserName:nil
                                              WorkName:nil
                                                Images:self.merchant_image
                                             ImagesUrl:nil];}

- (IBAction)onDiggButtonAction:(id)sender
{
    BOOL isLogin = [self checkIsLogin];
    if (!isLogin) {
        return;
    }
    
    __weak QSMerchantEnviromentViewController *weakSelf = self;
    if ([self.item.isGood boolValue] == 0) {
        [[QSAPIClientBase sharedClient] userAddGood:self.merchant_id
                                               type:kUserGoodType_Merchant
                                            success:^(QSAPIModelDict *response) {
                                                weakSelf.item.isGood = @"true";
                                                weakSelf.diggButton.selected = YES;
                                            } fail:^(NSError *error) {
                                                
                                            }];
    }
    else{
        [[QSAPIClientBase sharedClient] userDelGood:self.merchant_id
                                               type:kUserGoodType_Merchant
                                            success:^(QSAPIModelDict *response) {
                                                weakSelf.item.isGood = @"false";
                                                weakSelf.diggButton.selected = NO;
                                            } fail:^(NSError *error) {
                                                
                                            }];
    }
    
}

- (NSInteger)numberOfPages
{
    return self.imageUrls.count;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.slcycleView.bounds];
    NSString *url = self.imageUrls[index];
    [imageView setImageWithURL:[NSURL URLWithString:[url imageUrl]] placeholderImage:nil];
    return imageView;
}

- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                    message:[NSString stringWithFormat:@"当前点击第%d个页面",index]
//                                                   delegate:self
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil];
//    [alert show];
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
