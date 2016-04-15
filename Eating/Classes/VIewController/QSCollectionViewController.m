//
//  QSCollectionViewController.m
//  Eating
//
//  Created by System Administrator on 12/13/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSCollectionViewController.h"
#import "QSMerchantIndexViewController.h"
#import "QSIndexCell3.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+Merchant.h"
#import "QSAPIClientBase+Food.h"
#import "QSAPIModel+Food.h"
#import "QSMerchantFoodlistViewController.h"
#import "QSFoodTypeView.h"
#import "QSAPIClientBase+Merchant.h"
#import "MJRefresh.h"
#import "QSTabbarViewController.h"
#import "QSFoodListCell.h"
#import "QSAPIModel+Food.h"
#import "QSFoodDetailViewController.h"
#import "QSFoodMenuViewController.h"


typedef enum
{
    kRefreshType_No,
    kRefreshType_Header,
    kRefreshType_Footer
}kRefreshType;

@interface QSCollectionViewController ()

@property (nonatomic, strong) QSMerchantListReturnData *merchantListReturnData;
@property (nonatomic, strong) QSFoodListReturnData *foodListReturnData;

@property (nonatomic, unsafe_unretained) NSInteger merchantPage;
@property (nonatomic, unsafe_unretained) NSInteger foodPage;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *merchantDataSource;
@property (nonatomic, strong) NSMutableArray *foodDataSource;
@property (nonatomic, unsafe_unretained) kRefreshType refreshType;

@end

@implementation QSCollectionViewController

- (void)setMerchantListReturnData:(QSMerchantListReturnData *)merchantListReturnData
{
    _merchantListReturnData = merchantListReturnData;
    if (self.refreshType == kRefreshType_Header) {
        self.merchantDataSource = [NSMutableArray arrayWithArray:_merchantListReturnData.msg];
    }
    else if (self.refreshType == kRefreshType_Footer){
        [self.merchantDataSource addObjectsFromArray:_merchantListReturnData.msg];
        
    }
    self.dataSource = [NSMutableArray arrayWithArray:self.merchantDataSource];
    [self.collectionTableView reloadData];
}

- (void)setFoodListReturnData:(QSFoodListReturnData *)foodListReturnData
{
    _foodListReturnData = foodListReturnData;
    
    
    if (self.refreshType == kRefreshType_Header) {
        self.foodDataSource = [NSMutableArray arrayWithArray:_foodListReturnData.data];
    }
    else if (self.refreshType == kRefreshType_Footer){
        [self.foodDataSource addObjectsFromArray:_foodListReturnData.data];
        
    }
    
    if (self.foodDataSource.count%2 == 1) {
        QSFoodDetailData *info = [[QSFoodDetailData alloc] init];
        [self.foodDataSource addObject:info];
    }
    
    self.dataSource = [NSMutableArray arrayWithArray:self.foodDataSource];
    [self.collectionTableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];

    [self onSegmentButtonAction:self.segmentButton1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.collectionTableView.frame;
    frame.origin.x = 0;
    frame.origin.y = 90;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 90 - 3;
    self.collectionTableView.frame = frame;
    
    [self.view bringSubviewToFront:self.topView];
}

- (void)setupTableView
{
    [self.collectionTableView addHeaderWithCallback:^{
        self.refreshType = kRefreshType_Header;
        if (self.segmentButton1.selected) {
            self.merchantPage = 1;
            [self getMerchantList];
        }
        else{
            self.foodPage = 1;
            [self getFoodList];

        }
    }];
    
    [self.collectionTableView addFooterWithCallback:^{
        self.refreshType = kRefreshType_Footer;
        if (self.segmentButton1.selected) {
            self.merchantPage++;
            [self getMerchantList];
        }
        else{
            self.foodPage++;
            [self getFoodList];

        }
    }];
}

- (void)setupUI
{
    [self.segmentButton1 roundCornerRadius:13];
    [self.segmentButton2 roundCornerRadius:13];
}

- (IBAction)onSegmentButtonAction:(id)sender
{
    UIButton *button = sender;
    
    [self.segmentButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.segmentButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.segmentButton1 setBackgroundColor:[UIColor clearColor]];
    [self.segmentButton2 setBackgroundColor:[UIColor clearColor]];
    self.segmentButton1.userInteractionEnabled = YES;
    self.segmentButton2.userInteractionEnabled = YES;
    self.segmentButton1.selected = NO;
    self.segmentButton2.selected = NO;
    
    [button setTitleColor:kBaseOrangeColor forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.userInteractionEnabled = NO;
    button.selected = YES;
    
    if (self.segmentButton1.selected) {
        if (self.merchantPage == 0) {
            [self.collectionTableView headerBeginRefreshing];
        }
        else{
            self.dataSource = [NSMutableArray arrayWithArray:self.merchantDataSource];
            [self.collectionTableView reloadData];
        }
    }
    else{
        if (self.foodPage == 0) {
            [self.collectionTableView headerBeginRefreshing];
        }
        else{
            self.dataSource = [NSMutableArray arrayWithArray:self.foodDataSource];
            [self.collectionTableView reloadData];
        }
        
    }
    
}

- (void)getMerchantList
{
    __weak QSCollectionViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] userMerchantList:self.merchantPage
                                             success:^(QSMerchantListReturnData *response) {
                                                 
                                                 [weakSelf.collectionTableView headerEndRefreshing];
                                                 [weakSelf.collectionTableView footerEndRefreshing];
                                                 
                                                 weakSelf.merchantListReturnData = response;
                                             } fail:^(NSError *error) {
                                                 [weakSelf.collectionTableView headerEndRefreshing];
                                                 [weakSelf.collectionTableView footerEndRefreshing];
                                                 weakSelf.merchantPage--;
                                                 
                                             }];
}

- (void)getFoodList
{
    __weak QSCollectionViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] userFoodList:self.foodPage
                                         success:^(QSFoodListReturnData *response) {
                                             [weakSelf.collectionTableView headerEndRefreshing];
                                             [weakSelf.collectionTableView footerEndRefreshing];
                                             
                                             weakSelf.foodListReturnData = response;
                                         } fail:^(NSError *error) {
                                             [weakSelf.collectionTableView headerEndRefreshing];
                                             [weakSelf.collectionTableView footerEndRefreshing];
                                             weakSelf.foodPage--;
                                         }];
}


- (void)delMerchantCollect:(NSInteger)tag
{
    __weak QSCollectionViewController *weakSelf = self;
    QSMerchantDetailData *info = self.merchantDataSource[tag];
    [[QSAPIClientBase sharedClient] userMerchantDelCollect:info.merchant_id
                                                   success:^(QSAPIModelDict *response) {
                                                       [weakSelf showTip:self.view tipStr:@"取消收藏商家成功"];
                                                       [weakSelf.merchantDataSource removeObjectAtIndex:tag];
                                                       weakSelf.dataSource = [NSMutableArray arrayWithArray:self.merchantDataSource];
                                                       [weakSelf.collectionTableView reloadData];
                                                       
                                                   } fail:^(NSError *error) {
                                                       
                                                   }];
}


- (void)deleFoodCollect:(NSInteger)tag
{
    __weak QSCollectionViewController *weakSelf = self;
    QSFoodDetailData *info = self.foodDataSource[tag];
    [[QSAPIClientBase sharedClient] userFoodDelCollect:info.goods_id
                                               success:^(QSAPIModelDict *response) {
                                                   [weakSelf showTip:self.view tipStr:@"取消收藏菜品成功"];
                                                   [weakSelf.foodDataSource removeObjectAtIndex:tag];
                                                   weakSelf.dataSource = [NSMutableArray arrayWithArray:self.foodDataSource];
                                                   [weakSelf.collectionTableView reloadData];
                                               } fail:^(NSError *error) {
                                                   
                                               }];
}

- (void)foodMenu:(QSFoodDetailData *)info
{
    QSFoodMenuViewController *viewVC = [[QSFoodMenuViewController alloc] init];
    viewVC.foodName = info.goods_name;
    [self.navigationController pushViewController:viewVC animated:YES];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentButton1.selected) {
        return self.dataSource.count;
    }
    else{
        return self.dataSource.count/2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentButton1.selected) {
        return 90;
    }
    else{
        return 200;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak QSCollectionViewController *weakSelf = self;
    
    if (self.segmentButton1.selected) {
        static NSString *identifier = @"Cell";
        QSIndexCell3 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSIndexCell3" owner:self options:nil];
            if ([nibs count] > 0) {
                cell = nibs[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        QSMerchantDetailData *info = self.dataSource[indexPath.row];
        cell.showCollectionButton =YES;
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
        cell.onCollectButtonHandler = ^(BOOL isSelected){
            
            [weakSelf delMerchantCollect:indexPath.row];

        };
        
        return cell;
    }
    else{
        static NSString *identifier = @"Cell";
        QSFoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSFoodListCell" owner:self options:nil];
            if ([nibs count] > 0) {
                cell = nibs[0];
            }
            cell.collectionType = YES;
            cell.item1 = self.dataSource[indexPath.row*2+0];
            cell.item2 = self.dataSource[indexPath.row*2+1];
            
            cell.onDetailHandler = ^(NSInteger tag){
                QSFoodDetailData *info = weakSelf.dataSource[indexPath.row*2+tag];
                [weakSelf foodMenu:info];

            };

        }
        
        return cell;
    }

    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
