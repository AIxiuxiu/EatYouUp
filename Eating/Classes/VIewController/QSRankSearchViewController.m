//
//  QSRankSearchViewController.m
//  Eating
//
//  Created by System Administrator on 12/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSRankSearchViewController.h"
#import "QSMerchantIndexViewController.h"
#import "QSIndexCell3.h"
#import "QSAPIModel+Merchant.h"
#import "QSMerchantFoodlistViewController.h"
#import "QSFoodTypeView.h"
#import "QSAPIClientBase+Merchant.h"
#import "MJRefresh.h"
#import "QSTabbarViewController.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"

typedef enum
{
    kRefreshType_No,
    kRefreshType_Header,
    kRefreshType_Footer
}kRefreshType;

@interface QSRankSearchViewController ()

@property (nonatomic, strong) QSMerchantListReturnData *merchantListReturnData;

@property (nonatomic, unsafe_unretained) NSInteger page1;
@property (nonatomic, unsafe_unretained) NSInteger page2;
@property (nonatomic, unsafe_unretained) NSInteger page3;


@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *dataSource1;
@property (nonatomic, strong) NSMutableArray *dataSource2;
@property (nonatomic, strong) NSMutableArray *dataSource3;

@property (nonatomic, unsafe_unretained) kRefreshType refreshType;

@end

@implementation QSRankSearchViewController

- (void)setMerchantListReturnData:(QSMerchantListReturnData *)merchantListReturnData
{
    _merchantListReturnData = merchantListReturnData;
    if (self.refreshType == kRefreshType_Header) {
        if (self.segmentButton1.selected) {
            self.dataSource1 = [NSMutableArray arrayWithArray:_merchantListReturnData.msg];
            self.dataSource = [NSMutableArray arrayWithArray:self.dataSource1];

        }
        else if (self.segmentButton2.selected){
            self.dataSource2 = [NSMutableArray arrayWithArray:_merchantListReturnData.msg];
            self.dataSource = [NSMutableArray arrayWithArray:self.dataSource2];
        }
        else{
            self.dataSource3 = [NSMutableArray arrayWithArray:_merchantListReturnData.msg];
            self.dataSource = [NSMutableArray arrayWithArray:self.dataSource3];
        }
    }
    else if (self.refreshType == kRefreshType_Footer){
        if (self.segmentButton1.selected) {
            [self.dataSource1 addObjectsFromArray:_merchantListReturnData.msg];
            self.dataSource = [NSMutableArray arrayWithArray:self.dataSource1];
        }
        else if (self.segmentButton2.selected){
            [self.dataSource2 addObjectsFromArray:_merchantListReturnData.msg];
            self.dataSource = [NSMutableArray arrayWithArray:self.dataSource2];
        }
        else{
            [self.dataSource3 addObjectsFromArray:_merchantListReturnData.msg];
            self.dataSource = [NSMutableArray arrayWithArray:self.dataSource3];
        }

    }

    [self.merchantTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    
    [self onSegmentButtonAction:self.segmentButton1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.merchantTableView.frame;
    frame.origin.x = 0;
    frame.origin.y = 89;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 89 - 3;
    self.merchantTableView.frame = frame;
}

- (void)setupTableView
{
    [self.merchantTableView addHeaderWithCallback:^{
        self.refreshType = kRefreshType_Header;
        if (self.segmentButton1.selected) {
            self.page1 = 1;
        }
        else if (self.segmentButton2.selected){
            self.page2 = 1;
        }
        else{
            self.page3 = 1;
        }
        [self getIndexMerchantList];
    }];
    
    [self.merchantTableView addFooterWithCallback:^{
        self.refreshType = kRefreshType_Footer;
        if (self.segmentButton1.selected) {
            self.page1++;
        }
        else if (self.segmentButton2.selected){
            self.page2++;
        }
        else{
            self.page3++;
        }
        [self getIndexMerchantList];
    }];
}

- (void)setupUI
{
    [self.segmentButton1 roundCornerRadius:13];
    [self.segmentButton2 roundCornerRadius:13];
    [self.segmentButton3 roundCornerRadius:13];
}

- (IBAction)onSegmentButtonAction:(id)sender
{
    UIButton *button = sender;
    
    [self.segmentButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.segmentButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.segmentButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.segmentButton1 setBackgroundColor:[UIColor clearColor]];
    [self.segmentButton2 setBackgroundColor:[UIColor clearColor]];
    [self.segmentButton3 setBackgroundColor:[UIColor clearColor]];
    self.segmentButton1.userInteractionEnabled = YES;
    self.segmentButton2.userInteractionEnabled = YES;
    self.segmentButton3.userInteractionEnabled = YES;
    self.segmentButton1.selected = NO;
    self.segmentButton2.selected = NO;
    self.segmentButton3.selected = NO;
    
    [button setTitleColor:kBaseOrangeColor forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.userInteractionEnabled = NO;
    button.selected = YES;
    
    if (button == self.segmentButton1) {
        self.sort = @"2";
        
    }
    else if (button == self.segmentButton2) {
        self.sort = @"2";
        
    }
    else{
        self.sort = @"7";

    }
    if (self.segmentButton1.selected) {
        if (self.page1 == 0) {
            [self.merchantTableView headerBeginRefreshing];
        }
        else{
            self.dataSource = [NSMutableArray arrayWithArray:self.dataSource1];
            [self.merchantTableView reloadData];
        }
    }
    else if (self.segmentButton2.selected) {
        if (self.page2 == 0) {
            [self.merchantTableView headerBeginRefreshing];
        }
        else{
            self.dataSource = [NSMutableArray arrayWithArray:self.dataSource2];
            [self.merchantTableView reloadData];
        }
    }
    else{
        if (self.page3 == 0) {
            [self.merchantTableView headerBeginRefreshing];
        }
        else{
            self.dataSource = [NSMutableArray arrayWithArray:self.dataSource3];
            [self.merchantTableView reloadData];
        }
    }

}

- (void)getIndexMerchantList
{
    __weak QSRankSearchViewController *weakSelf = self;
    //double latitude = 23.144994;
    //double longitude = 113.327572;
    
    NSInteger page = 1;
    page = self.segmentButton1.selected ? self.page1 : page;
    page = self.segmentButton2.selected ? self.page2 : page;
    page = self.segmentButton3.selected ? self.page3 : page;
    
    [[QSAPIClientBase sharedClient] merchantNearbyWithLatitude:23.144994
                                                     longitude:113.327572
                                                          skey:nil
                                                           pro:@"440000"
                                                          city:@"440100"
                                                          area:[UserManager sharedManager].userData.adcode ? [UserManager sharedManager].userData.adcode : @"440106"
                                                          page:page
                                                      distance:self.distance
                                                        flavor:self.flavor
                                                        coupon:self.coupon
                                                          sort:self.sort
                                                     metroline:self.metro
                                                     bussiness:self.bussiness
                                                        merTag:self.mertag
                                                  merchantType:@"0"
                                                       success:^(QSMerchantListReturnData *response) {
                                                           [weakSelf.merchantTableView headerEndRefreshing];
                                                           [weakSelf.merchantTableView footerEndRefreshing];
                                                           weakSelf.merchantListReturnData = response;
                                                       } fail:^(NSError *error) {
                                                           [weakSelf.merchantTableView headerEndRefreshing];
                                                           [weakSelf.merchantTableView footerEndRefreshing];
                                                           if (self.segmentButton1.selected) {
                                                               weakSelf.page1--;
                                                           }
                                                           else if (self.segmentButton2.selected) {
                                                               weakSelf.page2--;
                                                           }
                                                           else{
                                                               weakSelf.page3--;
                                                               
                                                           }
                                                           
                                                       }];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
