//
//  QSIndexViewController.m
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSIndexViewController.h"
#import "QSIndexCell1.h"
#import "QSIndexCell2.h"
#import "QSIndexCell3.h"
#import "QSMerchantIndexViewController.h"
#import "QSAPIClientBase+Index.h"
#import "QSAPIClientBase+Merchant.h"
#import "QSAPIModel+Merchant.h"
#import "QSAPIModel+Index.h"
#import "QSFoodDetectiveViewController.h"
#import "QSFoodGroudViewController.h"
#import "QSMerchantFoodlistViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QSTabbarViewController.h"
#import "MJRefresh.h"
#import "QSMapNavViewController.h"
#import "LocationManager.h"
#import "MJRefresh.h"
#import "QSYBannerAdverDetailViewController.h"

@interface QSIndexViewController ()<UITableViewDataSource, UITableViewDelegate>
{
}
@property (nonatomic, strong) QSIndexBannerReturnData *indexBannerReturnData;
@property (nonatomic, strong) QSMerchantListReturnData *merchantListReturnData;
@property (nonatomic, unsafe_unretained) NSInteger openedRow;


@end

@implementation QSIndexViewController

- (void)setMerchantListReturnData:(QSMerchantListReturnData *)merchantListReturnData
{
    _merchantListReturnData = merchantListReturnData;
    
    [self.indexTableView headerEndRefreshing];
    [self.indexTableView reloadData];
}

- (void)setIndexBannerReturnData:(QSIndexBannerReturnData *)indexBannerReturnData
{
    
    _indexBannerReturnData = indexBannerReturnData;
    
    [self.indexTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    [self setupNotification];
    
    [[LocationManager sharedManager] startUpdateUserLocation];
    [self.indexTableView headerBeginRefreshing];
    
    
}

- (void)setupNotification
{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:kUserDidUpdateLocationNotification
                                               object:nil];
}

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kUserDidUpdateLocationNotification]) {
        [self.indexTableView reloadData];
    }
}

- (void)setupTableView
{
    [self.indexTableView addHeaderWithCallback:^{
        [self getIndexBanner];
        
        [self getIndexMerchantList];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.indexTableView.frame;
    frame.origin.x = 0;
    frame.origin.y = 122;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 122 - 53;
    self.indexTableView.frame = frame;
}

- (void)getIndexBanner
{
    __weak QSIndexViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] indexBannerWithSuccess:^(QSIndexBannerReturnData *response) {
        
        weakSelf.indexBannerReturnData = response;
        
    } fail:^(NSError *error) {
        
        [self showTip:self.view tipStr:@"当前网络不可用，请稍后再试。" andCallBack:^{
            
            exit(999);
            
        }];
        
    }];
}

- (void)getIndexMerchantList
{
    __weak QSIndexViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] merchantListWithMerchantid:nil
                                                       success:^(QSMerchantListReturnData *response) {
                                                           
                                                           [weakSelf hideLoadingHud];
                                                           weakSelf.merchantListReturnData = response;
                                                           
                                                       } fail:^(NSError *error) {
                                                           
                                                           [weakSelf hideLoadingHud];
                                                           
                                                       }];
}

- (void)setupUI
{
    self.titleLabel.text = @"吃订你";
    

}

- (IBAction)onLocateButtonAction:(id)sender
{
    if (_merchantListReturnData) {
        QSMapNavViewController *viewVC = [[QSMapNavViewController alloc] init];
        viewVC.merchantListReturnData = _merchantListReturnData;
        [self.navigationController pushViewController:viewVC animated:YES];
    }

}

- (IBAction)onOrderButtonAction:(id)sender
{
    [[QSTabbarViewController sharedTabBarController] showMerchantView];

}

- (IBAction)onTakeoutButtonAction:(id)sender
{
    [[QSTabbarViewController sharedTabBarController] showMerchantTakeoutView];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 + self.merchantListReturnData.msg.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 203;
    }
    else if (indexPath.row == 1){
        return 110;
    }
    else{
        return 90;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSIndexViewController *weakSelf = self;
    if (indexPath.row == 0) {
        ///广告位
        static NSString *identifier = @"Cell";
        
        QSIndexCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSIndexCell1" owner:self options:nil];
            if ([nibs count] > 0) {
                cell = nibs[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        }
        
        ///绑定回调block
        cell.callBack = ^(BOOL flag,NSString *url){
        
            QSYBannerAdverDetailViewController *bannerDetailVC = [[QSYBannerAdverDetailViewController alloc] initWithURL:url];
            [self.navigationController pushViewController:bannerDetailVC animated:YES];
        
        };
        
        ///绑定数据
        cell.indexBannerReturnData = self.indexBannerReturnData;
       
        
        return cell;
        
    }
    else if (indexPath.row == 1){
        static NSString *identifier = @"Cell";
        QSIndexCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSIndexCell2" owner:self options:nil];
            if ([nibs count] > 0) {
                cell = nibs[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //绑定美食侦探/搭食团的回调block
        cell.onIconButtonHandler = ^(NSInteger tag){
            
            //根据不同的button tag进入不同的viewController
            if (tag == 0) {
                //进入美食侦探
#if 1
                QSFoodDetectiveViewController *foodDetective =
                [[QSFoodDetectiveViewController alloc] init];
                
                [self.navigationController pushViewController:foodDetective animated:YES];
#endif
                return;
            }
            
            if (tag == 1) {
                
                //进入搭食团主页
                QSFoodGroudViewController *foodGroud = [[QSFoodGroudViewController alloc] initWithType:DEFAULT_FLT];
                [self.navigationController pushViewController:foodGroud animated:YES];
                return;
            }
        };
        
        return cell;
    }
    else {
        static NSString *identifier = @"Cell";
        QSIndexCell3 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSIndexCell3" owner:self options:nil];
            if ([nibs count] > 0) {
                cell = nibs[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        QSMerchantDetailData *info = self.merchantListReturnData.msg[indexPath.row-2];
        cell.item = info;
        cell.onVoiceButtonHandler = ^{
            if (info.merchant_sounds) {
                [[UserManager sharedManager] playMerchantSound:info.merchant_sounds];
            }
        };
        cell.onIntroButtonHandler = ^(QSMerchantIndexReturnData *response){
            QSMerchantFoodlistViewController *viewVC = [[QSMerchantFoodlistViewController alloc] init];
            viewVC.merchant_id = response.data.merchant_id;
            viewVC.merchantIndexReturnData = response;
            [self.navigationController pushViewController:viewVC animated:YES];
        
        };
        cell.onTapButtonHandler = ^{
            QSMerchantIndexViewController *viewVC = [[QSMerchantIndexViewController alloc] init];
            viewVC.merchant_id = info.merchant_id;
            [self.navigationController pushViewController:viewVC animated:YES];
        };
        cell.onOpenHandler = ^{
            
            QSIndexCell3 *ce = (QSIndexCell3 *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.openedRow inSection:0]];
            if (indexPath.row != weakSelf.openedRow && weakSelf.openedRow >= 2) {
                [ce hideMenu];
            }

            weakSelf.openedRow = indexPath.row;
        };
        if (indexPath.row == self.openedRow) {
            [cell showMenu];
        }
        return cell;
    }
    
    return nil;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
