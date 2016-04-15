//
//  QSDeliveryListViewController.m
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSDeliveryListViewController.h"
#import "QSAPIClientBase+Delivery.h"
#import "QSAPIModel+Delivery.h"
#import "QSDeliveryListCell.h"
#import "QSDeliveryDetailViewController.h"

@interface QSDeliveryListViewController ()

@property (nonatomic, strong) QSDeliveryListReutrnData *deliveryListReturnData;

@end

@implementation QSDeliveryListViewController

- (void)setDeliveryListReturnData:(QSDeliveryListReutrnData *)deliveryListReturnData
{
    _deliveryListReturnData = deliveryListReturnData;
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:_deliveryListReturnData.data];
    [temp sortUsingComparator:^NSComparisonResult(QSDeliveryDetailData *obj1, QSDeliveryDetailData *obj2) {
        if ([obj1.status integerValue] > [obj2.status integerValue]) {
            return NSOrderedAscending;
        }
        else{
            return NSOrderedDescending;
        }
    }];
    _deliveryListReturnData.data = [NSArray arrayWithArray:temp];
    
    
    [self.deliveryTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getDeliveryList];
}

- (void)setupUI
{
    self.titleLabel.text = @"送餐地址管理";
    [self setupTableView];
}

- (void)setupTableView
{
    [self.headerButton roundCornerRadius:5];
    self.deliveryTableView.tableHeaderView = self.headerView;
}

- (void)getDeliveryList
{
    __weak QSDeliveryListViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] userDeliveryListSuccess:^(QSDeliveryListReutrnData *response) {
        weakSelf.deliveryListReturnData = response;
    } fail:^(NSError *error) {
        
    }];
}

- (void)deleteDelivery:(NSInteger)row
{
    __weak QSDeliveryListViewController *weakSelf = self;
    QSDeliveryDetailData *info = self.deliveryListReturnData.data[row];
    [[QSAPIClientBase sharedClient] deleteDelivery:info.delivery_id
                                           success:^(QSAPIModel *response) {
                                               [weakSelf.deliveryListReturnData.data removeObjectAtIndex:row];
                                               [weakSelf.deliveryTableView beginUpdates];
                                               [weakSelf.deliveryTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                                               [weakSelf.deliveryTableView endUpdates];
                                               
    } fail:^(NSError *error) {
        
    }];
}

- (IBAction)onAddDeliverButtonAction:(id)sender
{
    QSDeliveryDetailViewController *viewVC = [[QSDeliveryDetailViewController alloc] init];
    viewVC.item = nil;
    [self.navigationController pushViewController:viewVC animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deliveryListReturnData.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSDeliveryListViewController *weakSelf = self;
    static NSString *identifier = @"Cell";
    QSDeliveryListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSDeliveryListCell" owner:self options:nil];
        if ([nibs count] > 0) {
            cell = nibs[0];
        }

    }
    QSDeliveryDetailData *info = self.deliveryListReturnData.data[indexPath.row];
    cell.item = info;
    cell.onDeleteButtonHandler = ^{
        [weakSelf deleteDelivery:indexPath.row];
    };
    cell.onTapButtonHandler = ^{
        QSDeliveryDetailViewController *viewVC = [[QSDeliveryDetailViewController alloc] init];
        viewVC.item = info;
        [weakSelf.navigationController pushViewController:viewVC animated:YES];
    };
    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
