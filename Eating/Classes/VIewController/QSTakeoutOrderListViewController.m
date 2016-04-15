//
//  QSTakeoutOrderListViewController.m
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSTakeoutOrderListViewController.h"
#import "QSAPIClientBase+Takeout.h"
#import "QSAPIModel+Takeout.h"
#import "QSTakeoutOrderListCell.h"
#import "QSTakeoutDetailViewController.h"
#import "QSAPIClientBase+Book.h"
#import "QSAPIModel+Book.h"
#import "MJRefresh.h"

typedef enum
{
    kRefreshType_No,
    kRefreshType_Header,
    kRefreshType_Footer
}kRefreshType;

@interface QSTakeoutOrderListViewController ()

@property (nonatomic, strong) QSTakeoutListReturnData *takeoutlistReturnData;
@property (nonatomic, strong) QSBookListReturnData *booklistReturnData;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *takeoutDataSource;
@property (nonatomic, strong) NSMutableArray *bookDataSource;

@property (nonatomic, unsafe_unretained) NSInteger takeoutPage;
@property (nonatomic, unsafe_unretained) NSInteger bookPage;

@property (nonatomic, unsafe_unretained) kRefreshType refreshType;

@property (nonatomic,assign) NSString *turnBackIndex;//!<返回时的VC差，方便返回到特定页面

@end

@implementation QSTakeoutOrderListViewController

- (void)setTakeoutlistReturnData:(QSTakeoutListReturnData *)takeoutlistReturnData
{
    
    _takeoutlistReturnData = takeoutlistReturnData;
    if (self.refreshType == kRefreshType_Header) {
        
        self.takeoutDataSource = [NSMutableArray arrayWithArray:_takeoutlistReturnData.data];
        
    } else if (self.refreshType == kRefreshType_Footer){
        
        [self.takeoutDataSource addObjectsFromArray:_takeoutlistReturnData.data];
        
    }
    
    self.dataSource = [NSMutableArray arrayWithArray:self.takeoutDataSource];

    [self.orderTableView reloadData];
    
}

- (void)setBooklistReturnData:(QSBookListReturnData *)booklistReturnData
{
    
    _booklistReturnData = booklistReturnData;
    if (self.refreshType == kRefreshType_Header) {
        self.bookDataSource = [NSMutableArray arrayWithArray:_booklistReturnData.data];
    }
    else if (self.refreshType == kRefreshType_Footer){
        [self.bookDataSource addObjectsFromArray:_booklistReturnData.data];
    }
    self.dataSource = [NSMutableArray arrayWithArray:self.bookDataSource];
    
    [self.orderTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    
    if (self.orderListType == kOrderListType_Book){
        
        self.segmentButton1.selected = YES;
        self.segmentButton2.selected = NO;
        [self onSegmentButtonAction:self.segmentButton1];
        
    }
    else if (self.orderListType == kOrderListType_Takeout) {
        
        self.segmentButton1.selected = NO;
        self.segmentButton2.selected = YES;
        [self onSegmentButtonAction:self.segmentButton2];
        
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.orderTableView.frame;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 88;
    self.orderTableView.frame = frame;
}

- (void)setupUI
{
    
    [self.segmentButton1 roundCornerRadius:13];
    [self.segmentButton2 roundCornerRadius:13];
    
}

- (void)setupTableView
{
    [self.orderTableView addHeaderWithCallback:^{
        self.refreshType = kRefreshType_Header;
        if (self.segmentButton1.selected) {
            self.bookPage = 1;
            [self getBookList];
        }
        else{
            self.takeoutPage = 1;
            [self getTakeoutList];
        }
    }];
    
    [self.orderTableView addFooterWithCallback:^{
        self.refreshType = kRefreshType_Footer;
        if (self.segmentButton1.selected) {
            self.bookPage++;
            [self getBookList];
        }
        else{
            self.takeoutPage++;
            [self getTakeoutList];
        }
    }];
}

- (IBAction)onBackButtonAction:(id)sender
{
    ///获取返回下标的差标
    int turnback = [self.turnBackIndex intValue];
    if (turnback > 2 && turnback < 99) {
        
        int sumVC = (int)[self.navigationController.viewControllers count];
        __weak UIViewController *tempVC = self.navigationController.viewControllers[sumVC - [self.turnBackIndex intValue]];
        [self.navigationController popToViewController:tempVC animated:YES];
        
    } else {
    
        [self.navigationController popViewControllerAnimated:YES];
    
    }
    
}

- (IBAction)onSegmentButtonAction:(id)sender
{
    
    UIButton *button = sender;
    if (button == self.segmentButton1) {
        
        self.orderListType = kOrderListType_Book;
        
        [self.segmentButton1 setTitleColor:kBaseOrangeColor forState:UIControlStateNormal];
        [self.segmentButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.segmentButton1 setBackgroundColor:[UIColor whiteColor]];
        [self.segmentButton2 setBackgroundColor:[UIColor clearColor]];
        self.segmentButton1.userInteractionEnabled = NO;
        self.segmentButton2.userInteractionEnabled = YES;
        self.segmentButton1.selected = YES;
        self.segmentButton2.selected = NO;
        
        if (self.bookDataSource.count) {
            
            self.dataSource = [NSMutableArray arrayWithArray:self.bookDataSource];
            [self.orderTableView reloadData];
            
        } else {
            
            [self.orderTableView headerBeginRefreshing];
            
        }

    }
    else{
        self.orderListType = kOrderListType_Takeout;
        
        [self.segmentButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.segmentButton2 setTitleColor:kBaseOrangeColor forState:UIControlStateNormal];
        [self.segmentButton1 setBackgroundColor:[UIColor clearColor]];
        [self.segmentButton2 setBackgroundColor:[UIColor whiteColor]];
        self.segmentButton1.userInteractionEnabled = YES;
        self.segmentButton2.userInteractionEnabled = NO;
        self.segmentButton1.selected = NO;
        self.segmentButton2.selected = YES;
        
        if (self.takeoutDataSource.count) {
            
            self.dataSource = [NSMutableArray arrayWithArray:self.takeoutDataSource];
            [self.orderTableView reloadData];
            
        } else {
            
            [self.orderTableView headerBeginRefreshing];
            
        }

    }
}

#pragma mark - 请求外卖列表
- (void)getTakeoutList
{
    __weak QSTakeoutOrderListViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] userTakeoutOrderListWithMerchantId:self.merchant_id
                                                                  page:self.takeoutPage
                                                                  type:self.orderType
                                                          success:^(QSTakeoutListReturnData *response) {
                                                              
                                                              ///如果记录数为0
                                                              if ([response.data count] <= 0 && self.takeoutPage == 1) {
                                                                  
                                                                  [self showNoRecordUI:YES];
                                                                  
                                                              } else {
                                                              
                                                                  [self showNoRecordUI:NO];
                                                              
                                                              }
                                                              
                                                              [weakSelf hideLoadingHud];
                                                              [weakSelf.orderTableView headerEndRefreshing];
                                                              [weakSelf.orderTableView footerEndRefreshing];
                                                              weakSelf.takeoutlistReturnData = response;
                                                              
                                                          } fail:^(NSError *error) {
                                                              
                                                              [weakSelf hideLoadingHud];
                                                              weakSelf.refreshType = kRefreshType_No;
                                                              if (self.takeoutPage > 1) {
                                                                  self.takeoutPage--;
                                                              };
                                                              [weakSelf.orderTableView headerEndRefreshing];
                                                              [weakSelf.orderTableView footerEndRefreshing];
                                                              
                                                          }];
}

#pragma mark - 请求预约列表
- (void)getBookList
{
    
    __weak QSTakeoutOrderListViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] bookListWithMerchantId:self.merchant_id
                                                      page:self.bookPage
                                                      type:self.orderType
                                                   success:^(QSBookListReturnData *response) {
                                                       
                                                       ///如果记录数为0
                                                       if ([response.data count] <= 0 && self.bookPage == 1) {
                                                           
                                                           [self showNoRecordUI:YES];
                                                           
                                                       } else {
                                                           
                                                           [self showNoRecordUI:NO];
                                                           
                                                       }
                                                       
                                                       [weakSelf hideLoadingHud];
                                                       [weakSelf.orderTableView headerEndRefreshing];
                                                       [weakSelf.orderTableView footerEndRefreshing];
                                                       weakSelf.booklistReturnData = response;
                                                       
                                                   } fail:^(NSError *error) {
                                                       
                                                       [weakSelf hideLoadingHud];
                                                       weakSelf.refreshType = kRefreshType_No;
                                                       if (self.bookPage > 1) {
                                                           self.bookPage--;
                                                       };
                                                       [weakSelf.orderTableView headerEndRefreshing];
                                                       [weakSelf.orderTableView footerEndRefreshing];
                                                       
                                                   }];
}

#pragma mark UITableView代理
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
    
    return 70.0f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    QSTakeoutOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSTakeoutOrderListCell" owner:self options:nil];
        if ([nibs count] > 0) {
            cell = nibs[0];
        }
        
    }
    
    cell.item = self.dataSource[indexPath.row];
    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QSTakeoutDetailViewController *viewVC = [[QSTakeoutDetailViewController alloc] init];

    if (self.orderListType == kOrderListType_Takeout) {
        
        QSTakeoutDetailData *info = self.dataSource[indexPath.row];
        viewVC.orderDetailType = kOrderDetailType_Takeout;
        viewVC.order_id = info.takeout_id;
        
        ///保存回调
        viewVC.payAgentCallBack = ^(BOOL flag){
            
            if (flag) {
                
                [self.orderTableView headerBeginRefreshing];
                
            }
            
        };
        
    } else if (self.orderListType == kOrderListType_Book){
        
        QSBookDetailData *info = self.dataSource[indexPath.row];
        viewVC.orderDetailType = kOrderDetailType_Book;
        viewVC.order_id = info.book_id;
        
        ///保存回调
        viewVC.payAgentCallBack = ^(BOOL flag){
            
            if (flag) {
                
                [self.orderTableView headerBeginRefreshing];
                
            }
            
        };
        
    }
    
    [self.navigationController pushViewController:viewVC animated:YES];
    
}

@end
