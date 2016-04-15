//
//  QSMerchantFoodlistViewController.m
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMerchantFoodlistViewController.h"
#import "QSFoodDetailViewController.h"
#import "QSFoodListCell.h"
#import "QSAPIClientBase+Food.h"
#import "QSAPIModel+Food.h"
#import "QSAPIModel+Merchant.h"
#import "QSTakeoutListViewController.h"
#import "QSBookFillFormViewController.h"
#import "QSMerchantFoodlist2ViewController.h"
#import "MJRefresh.h"
#import "QSFoodTypeView.h"

typedef enum
{
    kRefreshType_No,
    kRefreshType_Header,
    kRefreshType_Footer
}kRefreshType;

//like ,5, 就是出外卖
//like ,1, 是早茶
//,2, 午市
//,3,  晚市
//,4,  夜宵
@interface QSMerchantFoodlistViewController ()

@property (nonatomic, strong) QSFoodListReturnData *foodlistReturnData;
@property (nonatomic, unsafe_unretained) NSInteger page;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *flavor;
@property (nonatomic, copy) NSString *pice;
@property (nonatomic, unsafe_unretained) kRefreshType refreshType;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) QSFoodTypeView *foodTypeView;

@property (nonatomic,assign) BOOL takeout;                    //!<是否只是预约商家

@property (nonatomic,copy) NSMutableDictionary *searchDict;   //!<搜索相关的条
    
    

@end

@implementation QSMerchantFoodlistViewController

- (void)setFoodlistReturnData:(QSFoodListReturnData *)foodlistReturnData
{
    _foodlistReturnData = foodlistReturnData;
    [self.foodTableView headerEndRefreshing];
    [self.foodTableView footerEndRefreshing];
    if (self.refreshType == kRefreshType_Header) {
        self.dataSource = [NSMutableArray arrayWithArray:_foodlistReturnData.data];
    }
    else if (self.refreshType == kRefreshType_Footer){
        [self.dataSource addObjectsFromArray:_foodlistReturnData.data];
    }
    
    if (self.dataSource.count%2 == 1) {
        QSFoodDetailData *info = [[QSFoodDetailData alloc] init];
        [self.dataSource addObject:info];
    }
    [self.foodTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    
   
    
    [self.foodTableView headerBeginRefreshing];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.foodTableView.frame;
    frame.origin.x = 0;
    frame.origin.y = 88;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 88 - 50;
    self.foodTableView.frame = frame;
    
    frame = self.footerView.frame;
    frame.origin.x = 0;
    frame.origin.y = DeviceHeight - frame.size.height;
    frame.size.width = DeviceWidth;
    self.footerView.frame = frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[[UserManager sharedManager] carFoodNum] isEqualToString:@"0"]) {
        self.cartLabel.hidden = YES;
    }
    else{
        self.cartLabel.hidden = NO;
        self.cartLabel.text = [[UserManager sharedManager] carFoodNum];
    }
    self.cartLabel.backgroundColor = kBaseGreenColor;
    [self.cartLabel roundView];
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

- (void)highlightButton:(UIButton *)b {
    [b setHighlighted:YES];
}

- (IBAction)onFilterButtonAction:(id)sender
{
    UIButton *button = sender;
    __weak QSMerchantFoodlistViewController *weakSelf = self;
    [self.foodTypeView hiddenFoodTypeView];
    if (button == self.sortButton1) {
        
       int currentIndex = [_searchDict valueForKey:@"flavor_index"] ? [[_searchDict valueForKey:@"flavor_index"] intValue] : 0;
        
        self.foodTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"全部",@"粤菜",@"西餐",@"日本料理",@"自助餐",@"东南亚菜",@"小吃",@"韩国料理",@"川菜",@"火锅",@"面包甜点",@"湘菜",@"东北菜",@"清真菜",@"茶餐厅",@"烧烤",@"新疆菜",@"其他"] andYPoint:64 andAboveView:self.foodTableView andCurrentIndex:currentIndex andCallBack:^(NSString *string,int index) {
            
            NSArray *temp = @[@"0",@"3",@"20",@"36",@"13",@"19",@"14",@"18",@"1",@"12",@"21",@"2",@"9",@"10",@"22",@"40",@"11",@"其他"];
            weakSelf.tag = temp[index];
            weakSelf.flavor = @"";
            weakSelf.pice = @"";
            
            [weakSelf.foodTableView headerBeginRefreshing];
            if (index==-1) {
                self.foodTypeView=nil;
                return ;
            }
            else if(index==0){
                [_searchDict removeObjectForKey:@"flavor"];
                [_searchDict setObject:[NSString stringWithFormat:@"%d",index] forKey:@"flavor_index"];
                button.selected = NO;
                
                //button.selected=YES;
                
            }
            else{
                [_searchDict setObject:string forKey:@"flavor"];
                [_searchDict setObject:[NSString stringWithFormat:@"%d",index] forKey:@"flavor_index"];
                button.selected=YES;
                [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
                
               
            
            }
            
            ///接取到所选择的菜品
            //[self.foodTypeView :_searchDict];
          
           
            
            ///弹回去的时候，重置指针
            self.foodTypeView = nil;
           
        }];
       [self.foodTypeView setValue:@"1" forKey:@"unchoiceCallBackFlag"];
  
        
    }
    else if (button == self.sortButton2){
        
         int currentIndex = [_searchDict valueForKey:@"flavor_index"] ? [[_searchDict valueForKey:@"flavor_index"] intValue] : 0;
        
        self.foodTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"全部",@"微辣",@"小辣",@"中辣",@"麻辣",@"特辣"] andYPoint:64 andAboveView:self.foodTableView andCurrentIndex:currentIndex andCallBack:^(NSString *string,int index) {
            
            NSArray *temp = @[@"11",@"12",@"13",@"14",@"15",@"16"];
            weakSelf.flavor = temp[index];
            weakSelf.tag = @"";
            weakSelf.pice = @"";
            
            
            
            [weakSelf.foodTableView headerBeginRefreshing];
            if (index==-1) {
                return ;
            }
            else if(index==0){
                button.selected=YES;
            }
            else{[self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
               
            }
           
        }];
        
        
    }
    else if (button == self.sortButton3){
        
         int currentIndex = [_searchDict valueForKey:@"order_index"] ? [[_searchDict valueForKey:@"order_index"] intValue] : 0;
        
        
        self.foodTypeView = [QSFoodTypeView showFoodTypeView:self.view andDataSource:@[@"不限",@"人均最低",@"人均最高",@"评价最好",@"人气最高"] andYPoint:64 andAboveView:self.foodTableView andCurrentIndex:currentIndex andCallBack:^(NSString *string,int index) {
            
            weakSelf.pice = [NSString stringWithFormat:@"%d",index];
            weakSelf.tag = @"";
            weakSelf.flavor = @"";
            
            [weakSelf.foodTableView headerBeginRefreshing];
            if (index==-1) {
                return ;
            }
            else if(index==0){
                button.selected=YES;
            }
            else{
                
                [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
              
            }
        
        }];
  
        
    }

    self.sortButton1.userInteractionEnabled = YES;
    self.sortButton2.userInteractionEnabled = YES;
    self.sortButton3.userInteractionEnabled = YES;
  
    self.sortButton1.selected = NO;
    self.sortButton2.selected = NO;
    self.sortButton3.selected = NO;
    //button.selected = YES;
}


- (void)getFoodList
{
    __weak QSMerchantFoodlistViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] foodListWithMerchantId:self.merchant_id
                                                   pageNum:self.page
                                                       tag:self.tag
                                                    flavor:self.flavor
                                                      pice:self.pice
                                                   success:^(QSFoodListReturnData *response) {
                                                       [weakSelf hideLoadingHud];
                                                       weakSelf.foodlistReturnData = response;

                                                   } fail:^(NSError *error) {
                                                       [weakSelf hideLoadingHud];
                                                       [weakSelf.foodTableView headerEndRefreshing];
                                                       [weakSelf.foodTableView footerEndRefreshing];
                                                       if (weakSelf.refreshType == kRefreshType_Header) {
                                                           
                                                       }
                                                       else if (weakSelf.refreshType == kRefreshType_Footer){
                                                           weakSelf.page--;
                                                       }
                                                   }];
}

- (void)setupUI
{
    self.titleLabel.text = @"美食";
    [self.bookButton customButton:kCustomButtonType_FoodBook];
    [self.takeoutButton customButton:kCustomButtonType_FoodTakeout];
    [self.callButton customButton:kCustomButtonType_CallTakout];
    
    self.takeout = NO;
    BOOL book = NO;
    if ([_merchantIndexReturnData.data.merchant_ser_new containsObject:@"5"]) {
        self.takeout = YES;
    }
    if ([_merchantIndexReturnData.data.merchant_ser_new containsObject:@"1"] || [_merchantIndexReturnData.data.merchant_ser_new containsObject:@"2"] || [_merchantIndexReturnData.data.merchant_ser_new containsObject:@"3"] || [_merchantIndexReturnData.data.merchant_ser_new containsObject:@"4"]) {
        book = YES;
    }

    self.bookButton.hidden = !book;
    self.takeoutButton.hidden = !self.takeout;
    self.callButton.hidden = book || self.takeout;
    
    CGPoint center;
    if (self.takeout && book) {
        
        center = self.bookButton.center;
        center.x = CGRectGetWidth(self.view.frame)/3;
        self.bookButton.center = center;
        
        center = self.takeoutButton.center;
        center.x = CGRectGetWidth(self.view.frame)/3*2;
        self.takeoutButton.center = center;
        
    } else if (self.takeout && !book){
        
        center = self.takeoutButton.center;
        center.x = CGRectGetWidth(self.view.frame)/2;
        self.takeoutButton.center = center;
        
    } else if (!self.takeout && book){
        
        center = self.bookButton.center;
        center.x = CGRectGetWidth(self.view.frame)/2;
        self.bookButton.center = center;
        
    } else {
        
        center = self.callButton.center;
        center.x = CGRectGetWidth(self.view.frame)/2;
        self.callButton.center = center;
        
    }
    
    _cartView.hidden = !self.takeout;

}


- (IBAction)onMenuButtonAction:(id)sender
{
    
    QSMerchantFoodlist2ViewController *viewVC = [[QSMerchantFoodlist2ViewController alloc] init];
    viewVC.merchant_id = self.merchant_id;
    viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
    QSFoodListReturnData *info = [[QSFoodListReturnData alloc] init];
    info.data = [[NSMutableArray alloc] initWithArray:self.dataSource];
    viewVC.foodlistReturnData = info;
    [self.navigationController pushViewController:viewVC animated:YES];
    
}

- (IBAction)onPhoneCallButtonAction:(id)sender
{
    [self makeCall:_merchantIndexReturnData.data.merchant_phone];
}

- (IBAction)onTakeoutButtonAction:(id)sender
{
    
    if (![self checkIsLogin]) {
        
        return;
        
    }
    
    if ([[[UserManager sharedManager] carFoodNum] integerValue] <= 0) {
        
        [self showTip:self.view tipStr:@"请先选择菜品"];
        return;
        
    }

    QSTakeoutListViewController *viewVC = [[QSTakeoutListViewController alloc] init];
    viewVC.merchant_id = self.merchant_id;
    viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
    [self.navigationController pushViewController:viewVC animated:YES];
    
}

- (IBAction)onBookButtonAction:(id)sender
{
    
    if (![self checkIsLogin]) {
        
        return;
        
    }
    
    QSBookFillFormViewController *viewVC = [[QSBookFillFormViewController alloc] init];
    viewVC.merchant_id = self.merchant_id;
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
    return self.dataSource.count/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSMerchantFoodlistViewController *weakSelf = self;
    static NSString *identifier = @"Cell";
    QSFoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSFoodListCell" owner:self options:nil];
        if ([nibs count] > 0) {
            
            cell = nibs[0];
            
        }
        
        cell.item1 = self.dataSource[indexPath.row*2+0];
        cell.item2 = self.dataSource[indexPath.row*2+1];

        cell.onDetailHandler = ^(NSInteger tag){
            
            QSFoodDetailData *info = weakSelf.dataSource[indexPath.row*2+tag];
            QSFoodDetailViewController *viewVC = [[QSFoodDetailViewController alloc] init];
            viewVC.goods_id = info.goods_id;
            viewVC.takeOutFlag = self.takeout;
            viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
            
            [weakSelf.navigationController pushViewController:viewVC animated:YES];
            
        };
        
        cell.onAddFoodHandler = ^(QSFoodDetailData *item){
            
            [[UserManager sharedManager] addFoodToLocalCart:item];
            
            if ([[[UserManager sharedManager] carFoodNum] isEqualToString:@"0"]) {
                
                self.cartLabel.hidden = YES;
                
            } else {
                
                self.cartLabel.hidden = NO;
                self.cartLabel.text = [[UserManager sharedManager] carFoodNum];
                [UIView animateWithDuration:0.3 animations:^{
                    
                } completion:^(BOOL finished) {
                    
                }];

            }
        };
        
        ///显示/隐藏购物车
        if (!self.takeout) {
            
            cell.addFoodButton1.hidden = YES;
            cell.addFoodButton2.hidden = YES;
            
        } else {
            
            cell.addFoodButton1.hidden = NO;
            cell.addFoodButton2.hidden = NO;
            
        }
        
    }
    
    ///显示/隐藏购物车
    if (!self.takeout) {
        
        cell.addFoodButton1.hidden = YES;
        cell.addFoodButton2.hidden = YES;
        
    } else {
        
        cell.addFoodButton1.hidden = NO;
        cell.addFoodButton2.hidden = NO;
        
    }
    
    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
