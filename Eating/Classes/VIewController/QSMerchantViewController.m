//
//  QSMerchantViewController.m
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMerchantViewController.h"
#import "QSMerchantIndexViewController.h"
#import "QSIndexCell3.h"
#import "QSAPIModel+Merchant.h"
#import "QSMerchantFoodlistViewController.h"
#import "QSFoodTypeView.h"
#import "QSAPIClientBase+Merchant.h"
#import "MJRefresh.h"
#import "QSTabbarViewController.h"
#import "QSAPIModel+User.h"

typedef enum
{
    kRefreshType_No,
    kRefreshType_Header,
    kRefreshType_Footer
}kRefreshType;
@interface QSMerchantViewController ()

@property (nonatomic, strong) QSMerchantListReturnData *allMerchantListReturnData;
@property (nonatomic, strong) QSMerchantListReturnData *takeoutMerchantListReturnData;
@property (nonatomic, strong) QSFoodTypeView *foodTypeView;



@property (nonatomic, unsafe_unretained) NSInteger allPage;
@property (nonatomic, unsafe_unretained) NSInteger takeoutPage;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *allDataSource;
@property (nonatomic, strong) NSMutableArray *takeoutDataSource;
@property (nonatomic, unsafe_unretained) kRefreshType refreshType;
@end

@implementation QSMerchantViewController

- (void)setAllMerchantListReturnData:(QSMerchantListReturnData *)allMerchantListReturnData
{
    _allMerchantListReturnData = allMerchantListReturnData;
    if (self.refreshType == kRefreshType_Header) {
        
        self.allDataSource = [NSMutableArray arrayWithArray:_allMerchantListReturnData.msg];
        
    } else if (self.refreshType == kRefreshType_Footer){
        
        [self.allDataSource addObjectsFromArray:_allMerchantListReturnData.msg];
        
    }
    self.dataSource = [NSMutableArray arrayWithArray:self.allDataSource];
    [self.merchantTableView reloadData];
}

- (void)setTakeoutMerchantListReturnData:(QSMerchantListReturnData *)takeoutMerchantListReturnData
{
    _takeoutMerchantListReturnData = takeoutMerchantListReturnData;
    if (self.refreshType == kRefreshType_Header) {
        self.takeoutDataSource = [NSMutableArray arrayWithArray:_takeoutMerchantListReturnData.msg];
    }
    else if (self.refreshType == kRefreshType_Footer){
        [self.takeoutDataSource addObjectsFromArray:_takeoutMerchantListReturnData.msg];
        
    }
    self.dataSource = [NSMutableArray arrayWithArray:self.takeoutDataSource];
    [self.merchantTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    
      [self onSegmentButtonAction:self.segmentButton1];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_showTakeoutList) {
        [self onSegmentButtonAction:self.segmentButton2];
    }
    else{
        [self onSegmentButtonAction:self.segmentButton1];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    CGRect frame = self.merchantTableView.frame;
    frame.origin.x = 0;
    frame.origin.y = 112;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 112 - 53;
    
    if (_showBackButton) {
        [self.tabbarViewController hideTabBar];
        self.backButton.hidden = NO;
        frame.size.height = DeviceHeight - 112 - 3;
    }
    
    self.merchantTableView.frame = frame;
}

- (IBAction)onBackButtonAction:(id)sender
{
    if (_showBackButton) {
        [self.tabbarViewController showTabBar];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableView
{
    [self.merchantTableView addHeaderWithCallback:^{
        self.refreshType = kRefreshType_Header;
        if (self.segmentButton1.selected) {
            self.allPage = 1;
        }
        else{
            self.takeoutPage = 1;
        }
        [self getIndexMerchantList];
    }];
    
    [self.merchantTableView addFooterWithCallback:^{
        self.refreshType = kRefreshType_Footer;
        if (self.segmentButton1.selected) {
            self.allPage++;
        }
        else{
            self.takeoutPage++;
        }
        [self getIndexMerchantList];
    }];
}

- (void)setupUI
{
    [self.segmentButton1 roundCornerRadius:13];
    [self.segmentButton2 roundCornerRadius:13];
}

- (IBAction)onFilterButtonAction:(id)sender
{
    UIButton *button = sender;
    __weak QSMerchantViewController *weakSelf = self;
    [self.foodTypeView hiddenFoodTypeView];
    if (button == self.sortButton1) {
       self.foodTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"全部",@"100米",@"200米",@"300米",@"400米",@"500米",@"800米",@"1公里",@"2公里"] andYPoint:64 andAboveView:self.merchantTableView andCallBack:^(NSString *string,int index) {
            
            NSArray *temp = @[@"0",@"100",@"200",@"300",@"400",@"500",@"800",@"1000",@"2000"];
            weakSelf.distance = temp[index];
            weakSelf.flavor = @"";
            weakSelf.coupon = @"";
            weakSelf.sort = @"";
           
           
           if (weakSelf.segmentButton1) {
               [weakSelf.allDataSource removeAllObjects];
               weakSelf.allPage = 1;
           }
           else{
               [weakSelf.takeoutDataSource removeAllObjects];
               weakSelf.takeoutPage = 1;
           }
           
           [weakSelf.merchantTableView headerBeginRefreshing];
        }];
    }
    else if (button == self.sortButton2){
        self.foodTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:[UserManager sharedManager].searchCategoryArray andYPoint:64 andAboveView:self.merchantTableView andCallBack:^(NSString *string,int index) {
            
            NSArray *temp = [UserManager sharedManager].searchCategoryCodeArray;
            weakSelf.flavor = temp[index];
            weakSelf.distance = @"";
            weakSelf.coupon = @"";
            weakSelf.sort = @"";
            
            if (weakSelf.segmentButton1) {
                [weakSelf.allDataSource removeAllObjects];
                weakSelf.allPage = 1;
            }
            else{
                [weakSelf.takeoutDataSource removeAllObjects];
                weakSelf.takeoutPage = 1;
            }
            
            [weakSelf.merchantTableView headerBeginRefreshing];
        }];

    }
    else if (button == self.sortButton3){
        self.foodTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"全部",@"限时促销",@"菜品促销",@"会员优惠",@"代金优惠",@"折扣优惠",@"菜品优惠"] andYPoint:64 andAboveView:self.merchantTableView andCallBack:^(NSString *string,int index) {
            
            weakSelf.coupon = [NSString stringWithFormat:@"%d",index];
            weakSelf.distance = @"";
            weakSelf.flavor = @"";
            weakSelf.sort = @"";
            
            if (weakSelf.segmentButton1) {
                [weakSelf.allDataSource removeAllObjects];
                weakSelf.allPage = 1;
            }
            else{
                [weakSelf.takeoutDataSource removeAllObjects];
                weakSelf.takeoutPage = 1;
            }
            
            [weakSelf.merchantTableView headerBeginRefreshing];
        }];
        
    }
    else if (button == self.sortButton4){
        self.foodTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"不限",@"按人气排序",@"按评价排序",@"按费用从低到高",@"按费用从高到低"] andYPoint:64 andAboveView:self.merchantTableView andCallBack:^(NSString *string,int index) {
            
            weakSelf.sort = [NSString stringWithFormat:@"%d",index+1];
            weakSelf.distance = @"";
            weakSelf.coupon = @"";
            weakSelf.flavor = @"";
            
            if (weakSelf.segmentButton1) {
                [weakSelf.allDataSource removeAllObjects];
                weakSelf.allPage = 1;
            }
            else{
                [weakSelf.takeoutDataSource removeAllObjects];
                weakSelf.takeoutPage = 1;
            }
            
            [weakSelf.merchantTableView headerBeginRefreshing];
            
        }];
        
    }
    self.sortButton1.userInteractionEnabled = YES;
    self.sortButton2.userInteractionEnabled = YES;
    self.sortButton3.userInteractionEnabled = YES;
    self.sortButton4.userInteractionEnabled = YES;
    self.sortButton1.selected = NO;
    self.sortButton2.selected = NO;
    self.sortButton3.selected = NO;
    self.sortButton4.selected = NO;
    button.selected = YES;

}

- (IBAction)onSegmentButtonAction:(id)sender
{
    UIButton *button = sender;
    if (button == self.segmentButton1) {
        [self.segmentButton1 setTitleColor:kBaseOrangeColor forState:UIControlStateNormal];
        [self.segmentButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.segmentButton1 setBackgroundColor:[UIColor whiteColor]];
        [self.segmentButton2 setBackgroundColor:[UIColor clearColor]];
        self.segmentButton1.userInteractionEnabled = NO;
        self.segmentButton2.userInteractionEnabled = YES;
        self.segmentButton1.selected = YES;
        self.segmentButton2.selected = NO;
  
    }
    else{
        
        [self.segmentButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.segmentButton2 setTitleColor:kBaseOrangeColor forState:UIControlStateNormal];
        [self.segmentButton1 setBackgroundColor:[UIColor clearColor]];
        [self.segmentButton2 setBackgroundColor:[UIColor whiteColor]];
        self.segmentButton1.userInteractionEnabled = YES;
        self.segmentButton2.userInteractionEnabled = NO;
        self.segmentButton1.selected = NO;
        self.segmentButton2.selected = YES;
        
    }
    
    if (self.segmentButton1.selected) {
        
        if (self.allPage == 0) {
            [self.merchantTableView headerBeginRefreshing];
        }
        else{
            self.dataSource = [NSMutableArray arrayWithArray:self.allDataSource];
            [self.merchantTableView reloadData];
        }
    } else {
        
        if (self.takeoutPage == 0) {
            
            [self.merchantTableView headerBeginRefreshing];
            
        } else {
            
            self.dataSource = [NSMutableArray arrayWithArray:self.takeoutDataSource];
            [self.merchantTableView reloadData];
            
        }
    }
}

- (void)getIndexMerchantList
{
    __weak QSMerchantViewController *weakSelf = self;
    //double latitude = 23.144994;
    //double longitude = 113.327572;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] merchantNearbyWithLatitude:23.144994 longitude:113.327572 skey:self.searchWord pro:@"440000" city:@"440100" area:[UserManager sharedManager].userData.adcode ? [UserManager sharedManager].userData.adcode : @"440106" page:self.segmentButton1.selected ? self.allPage : self.takeoutPage distance:self.distance flavor:self.flavor coupon:self.coupon sort:self.sort metroline:self.metro bussiness:self.bussiness merTag:self.mertag merchantType:self.segmentButton1.selected ? @"0" : @"5" success:^(QSMerchantListReturnData *response) {
        
        [weakSelf hideLoadingHud];
        [weakSelf.merchantTableView headerEndRefreshing];
        [weakSelf.merchantTableView footerEndRefreshing];
        
        if (self.segmentButton1.selected) {
            
            ///判断是否服务端响应
            if (!response.type || (0 >= [response.msg count])) {
                
                [self showNoRecordUI:YES];
                weakSelf.allMerchantListReturnData = response;
                weakSelf.allMerchantListReturnData.msg = [[NSMutableArray alloc] init];
                weakSelf.allMerchantListReturnData = response;
                return;
                
            }
            
            [self showNoRecordUI:NO];
            weakSelf.allMerchantListReturnData = response;
            
        } else {
            
            ///判断是否服务端响应
            if (!response.type || (0 >= [response.msg count])) {
                
                [self showNoRecordUI:YES];
                weakSelf.takeoutMerchantListReturnData = response;
                weakSelf.takeoutMerchantListReturnData.msg = [[NSMutableArray alloc] init];
                weakSelf.takeoutMerchantListReturnData = response;
                return;
                
            }
            
            [self showNoRecordUI:NO];
            weakSelf.takeoutMerchantListReturnData = response;
            
        }
        
    } fail:^(NSError *error) {
        
            [weakSelf hideLoadingHud];
            [weakSelf.merchantTableView headerEndRefreshing];
            [weakSelf.merchantTableView footerEndRefreshing];
            if (weakSelf.refreshType == kRefreshType_Footer) {
                
                if (self.segmentButton1.selected) {
                    
                    self.allPage--;
                } else {
                    
                    self.takeoutPage--;
                    
                }
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
