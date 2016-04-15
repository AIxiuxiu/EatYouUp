//
//  QSRecommendFoodListViewController.m
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSRecommendFoodListViewController.h"
#import "QSRecommendFoodListCell.h"
#import "QSAPIClientBase+Food.h"
#import "QSAPIModel+Food.h"
#import "MJRefresh.h"

typedef enum
{
    kRefreshType_No,
    kRefreshType_Header,
    kRefreshType_Footer
}kRefreshType;

@interface QSRecommendFoodListViewController ()

@property (nonatomic, strong) QSFoodListReturnData *foodlistReturnData;
@property (nonatomic, strong) NSMutableDictionary *selectedFoods;
@property (nonatomic, unsafe_unretained) kRefreshType refreshType;
@property (nonatomic, unsafe_unretained)NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation QSRecommendFoodListViewController


- (void)setPreFoodlist:(NSMutableArray *)preFoodlist
{
    _preFoodlist = preFoodlist;
    _selectedFoods = [[NSMutableDictionary alloc] init];
    for (QSFoodDetailData *info in _preFoodlist) {
        [_selectedFoods setValue:info forKey:info.goods_id];
    }
}

- (void)setFoodlistReturnData:(QSFoodListReturnData *)foodlistReturnData
{
    _foodlistReturnData = foodlistReturnData;
    
    if (self.refreshType == kRefreshType_Header) {
        self.dataSource = [NSMutableArray arrayWithArray:_foodlistReturnData.data];
    }
    else if (self.refreshType == kRefreshType_Footer){
        [self.dataSource addObjectsFromArray:_foodlistReturnData.data];
    }
    
    [self.foodTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    self.refreshType = kRefreshType_Header;
    [self.foodTableView headerBeginRefreshing];
    [self getFoodList];
}

- (void)setupTableView
{
    [self.foodTableView addHeaderWithCallback:^{
        self.refreshType = kRefreshType_Header;
        self.page = 1;
        [self getFoodList];
    }];
    
    [self.foodTableView addFooterWithCallback:^{
        self.refreshType = kRefreshType_Footer;
        self.page++;
        [self getFoodList];
    }];
}


- (void)setupUI
{
    self.titleLabel.text = @"推荐菜品";
    
    
}

- (void)getFoodList
{
    __weak QSRecommendFoodListViewController *weakSelf = self;
    
    [[QSAPIClientBase sharedClient] foodListWithMerchantId:self.merchant_id
                                                   pageNum:self.page
                                                       tag:nil
                                                    flavor:nil
                                                      pice:nil
                                                   success:^(QSFoodListReturnData *response) {
                                                       
                                                       [weakSelf.foodTableView headerEndRefreshing];
                                                       [weakSelf.foodTableView footerEndRefreshing];
                                                       weakSelf.foodlistReturnData = response;
                                                       
                                                   } fail:^(NSError *error) {
                                                       
                                                       [weakSelf.foodTableView headerEndRefreshing];
                                                       [weakSelf.foodTableView footerEndRefreshing];
                                                       if (weakSelf.refreshType == kRefreshType_Header){
                                                           weakSelf.page = 1;
                                                           
                                                       } else if (weakSelf.refreshType == kRefreshType_Footer){
                                                           
                                                           weakSelf.page--;
                                                           
                                                       }
                                                   }];
    
}

- (IBAction)onConfirmButtonAction:(id)sende
{
    if (self.onConfirmHandler) {
        self.onConfirmHandler([[self.selectedFoods allValues] mutableCopy]);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSRecommendFoodListViewController *weakSelf = self;
    static NSString *identifier = @"Cell";
    QSRecommendFoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSRecommendFoodListCell" owner:self options:nil];
        if ([nibs count] > 0) {
            cell = nibs[0];
        }

    }
    cell.cellType = kRecommendFoodType_RecommendSelect;
    QSFoodDetailData *info = self.dataSource[indexPath.row];
    cell.item = info;
    cell.isSelected = [[self.selectedFoods allKeys] containsObject:info.goods_id];
    cell.onCheckHandler = ^(BOOL isSelected){
        QSFoodDetailData *info = weakSelf.foodlistReturnData.data[indexPath.row];
        if (isSelected) {
            [weakSelf.selectedFoods setValue:info forKey:info.goods_id];
        }
        else{
            [weakSelf.selectedFoods removeObjectForKey:info.goods_id];
        }

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
