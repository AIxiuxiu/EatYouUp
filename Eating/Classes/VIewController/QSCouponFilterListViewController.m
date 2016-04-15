//
//  QSCouponFilterListViewController.m
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSCouponFilterListViewController.h"
#import "QSFilterTableCell.h"
#import "QSConfig.h"
#import "UIButton+UI.h"
#import "UIView+UI.h"

@interface QSCouponFilterListViewController ()

@property (nonatomic, strong) NSDictionary *dataSource;

@end

@implementation QSCouponFilterListViewController

- (NSDictionary *)dataSource
{
    if (!_dataSource) {
        _dataSource = @{
                        @"1" : @"代金券",
                        @"2" : @"折购券",
                        @"3" : @"兑换券",
                        @"4" : @"限时优惠",
                        @"5" : @"菜品优惠",
                        @"6" : @"会员优惠"
                        };
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.filterButton setBackgroundColor:kBaseOrangeColor];
    [self.filterButton roundCornerRadius:15];
    
    [self.view roundCornerRadius:8];
}

- (IBAction)onFilterButtonAction:(id)sender
{
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource allKeys].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSCouponFilterListViewController *weakSelf = self;
    static NSString *identifier = @"Cell";
    QSFilterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSFilterTableCell" owner:self options:nil];
        if ([nibs count] > 0) {
            cell = nibs[0];
        }
    }
    cell.textLabel.text = [self.dataSource allValues][indexPath.row];
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
