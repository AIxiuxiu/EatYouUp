//
//  QSTakeoutListViewController.m
//  Eating
//
//  Created by MJie on 14-11-17.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSTakeoutListViewController.h"
#import "QSRecommendFoodListCell.h"
#import "QSAPIClientBase+Takeout.h"
#import "QSAPIClientBase+Food.h"
#import "QSAPIModel+Takeout.h"
#import "QSAPIModel+Food.h"
#import "QSTakeoutFillInfoViewController.h"
#import "QSDatePickerViewController.h"
#import <ASDepthModalViewController.h>
#import "QSAPIModel+Merchant.h"

@interface QSTakeoutListViewController ()

@property (nonatomic, strong) QSTakeoutListReturnData *takeoutlistReturnData;
@property (nonatomic, strong) QSFoodListReturnData *foodListReturnData;
@property (nonatomic, strong) QSDatePickerViewController *datePickerVC;
@end

@implementation QSTakeoutListViewController

- (void)setFoodListReturnData:(QSFoodListReturnData *)foodListReturnData
{
    
    _foodListReturnData = foodListReturnData;
    
    [self.foodTableView reloadData];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.titleLabel.text = self.merchantIndexReturnData.data.merchant_name;
    
    QSFoodListReturnData *response = [[QSFoodListReturnData alloc] init];
    response.data = [[NSMutableArray alloc] initWithArray:[[UserManager sharedManager].carlist allValues]];
    self.foodListReturnData = response;

    UIView *amountView = [UIView listFooterView:[[UserManager sharedManager] carFoodNum] and:[[UserManager sharedManager] carOriginTotalMoney]];
    amountView.tag = 999;
    [self.footerView addSubview:amountView];
    
    self.foodTableView.tableFooterView = self.footerView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    CGRect frame = self.nextButton.frame;
    frame.origin.x = 10;
    frame.size.width = DeviceWidth - 20;
    self.nextButton.frame = frame;
    
}

- (void)setupUI
{
    
    self.titleLabel.text = @"外卖订餐";
    [self.nextButton roundCornerRadius:18];
    
}

- (IBAction)onNextButtonAction:(id)sender
{
    
    QSTakeoutFillInfoViewController *viewVC = [[QSTakeoutFillInfoViewController alloc] init];
    viewVC.foodlistReturnData = self.foodListReturnData;
    viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
    [self.navigationController pushViewController:viewVC animated:YES];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.foodListReturnData.data.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSTakeoutListViewController *weakSelf = self;
    static NSString *identifier = @"Cell";
    QSRecommendFoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSRecommendFoodListCell" owner:self options:nil];
        if ([nibs count] > 0) {
            
            cell = nibs[0];
            
        }
        
    }
    
    QSFoodDetailData *info = self.foodListReturnData.data[indexPath.row];
    cell.cellType = kRecommendFoodType_TakeoutSelect;
    cell.item = info;
    cell.onCountHandler = ^(){
        
        _datePickerVC = [[QSDatePickerViewController alloc] init];
        _datePickerVC.pickerType = kPickerType_Item;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (int i = 0 ; i < 100 ; i++) {
            
            [temp addObject:[NSString stringWithFormat:@"%d",i]];
            
        }
        
        _datePickerVC.dataSource = temp;
        _datePickerVC.currentRow = info.localAmount;
        [ASDepthModalViewController presentView:_datePickerVC.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
            
        }];
        
        _datePickerVC.onCancelButtonHandler = ^{
            
            [ASDepthModalViewController dismiss];
            
        };
        
        _datePickerVC.onItemConfirmButtonHandler = ^(NSInteger row, NSString *item){
            
            [ASDepthModalViewController dismiss];
            info.localAmount = [item intValue];
            if (info.localAmount == 0) {
                
                [[UserManager sharedManager].carlist removeObjectForKey:info.goods_id];
                weakSelf.foodListReturnData.data = [[NSMutableArray alloc] initWithArray:[[UserManager sharedManager].carlist allValues]];
                
            }
            
            [weakSelf.foodTableView reloadData];
            [[weakSelf.foodTableView.tableFooterView viewWithTag:999] removeFromSuperview];
            UIView *amountView = [UIView listFooterView:[[UserManager sharedManager] carFoodNum] and:[[UserManager sharedManager] carOriginTotalMoney]];
            amountView.tag = 999;
            [weakSelf.foodTableView.tableFooterView addSubview:amountView];
            
        };
        
    };
    
    return cell;
    
}

@end
