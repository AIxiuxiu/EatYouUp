//
//  QSCouponListViewController.m
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSCouponListViewController.h"
#import "QSCouponFilterListViewController.h"
#import <UIViewController+MJPopupViewController.h>
#import "QSRecommendListCell.h"
#import <ASDepthModalViewController.h>

@interface QSCouponListViewController ()

@property (nonatomic, strong) NSMutableDictionary *dataSourceDict;
@property (nonatomic, unsafe_unretained) NSInteger rowCount;

@end

@implementation QSCouponListViewController

- (NSMutableDictionary *)dataSourceDict
{
    if (!_dataSourceDict) {
        _dataSourceDict = [[NSMutableDictionary alloc] init];
        
        for (int i = 0 ; i < 6 ; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (int j = 0 ; j < i ; j++) {
                [arr addObject:[NSString stringWithFormat:@"%d",j]];
            }
            [_dataSourceDict setValue:arr forKey:key];
        }
        
    }
    
    return _dataSourceDict;
}

- (NSInteger)rowCount
{
    if (!_rowCount) {
        
        [self.dataSourceDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *obj, BOOL *stop) {
            _rowCount += obj.count;
        }];
        _rowCount += [self.dataSourceDict allKeys].count;
    }
    return _rowCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)setupUI
{
    
}

- (IBAction)onFilterBallButtonAction:(id)sender
{
    QSCouponFilterListViewController *viewVC = [[QSCouponFilterListViewController alloc] init];
//    [self presentPopupViewController:viewVC animationType:MJPopupViewAnimationSlideLeftLeft];
    [ASDepthModalViewController presentView:viewVC.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
        
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QSRecommendListCell cellHeight:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSCouponListViewController *weakSelf = self;
    static NSString *identifier = @"Cell";
    QSRecommendListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSRecommendListCell" owner:self options:nil];
        if ([nibs count] > 0) {
            cell = nibs[0];
        }
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (int i = 0 ; i < indexPath.row ; i++) {
            [temp addObject:[NSString stringWithFormat:@"%d",i]];
        }
        cell.coupons = [[NSMutableArray alloc] initWithArray:temp];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.onDetailHandler = ^(NSInteger tag){
        //            QSFoodDetailViewController *viewVC = [[QSFoodDetailViewController alloc] init];
        //            [weakSelf.navigationController pushViewController:viewVC animated:YES];
        //        };
    }
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
