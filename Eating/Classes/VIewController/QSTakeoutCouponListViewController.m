//
//  QSTakeoutCouponListViewController.m
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSTakeoutCouponListViewController.h"
#import "QSAPIClientBase+Coupon.h"
#import "QSAPIModel+Coupon.h"
#import "QSTakeoutCouponListCell.h"

@interface QSTakeoutCouponListViewController ()

@property (nonatomic, strong) QSCouponListReturnData *couponListReturnData;

@end

@implementation QSTakeoutCouponListViewController

- (void)setCouponListReturnData:(QSCouponListReturnData *)couponListReturnData
{
    _couponListReturnData = couponListReturnData;
    
    if (_couponListReturnData.data.count > 0) {
        
        self.couponContainView.hidden = NO;
        [self.couponTableView reloadData];
    }
    else{
        [self showTip:self.view tipStr:@"无可用优惠券"];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self onCouponButtonAction:self.couponButton1];
}

- (void)setupUI
{
    self.titleLabel.text = @"使用优惠";
    
    [self.couponView1 roundCornerRadius:5];
    [self.couponView2 roundCornerRadius:5];
    [self.offlineCouponView roundCornerRadius:5];
    
}

- (void)getUserCouponList
{
    __weak QSTakeoutCouponListViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] userCouponListWithMerchant_id:self.merchant_id
                                                          success:^(QSCouponListReturnData *response) {
                                                              
                                                              [self hideLoadingHud];
                                                              weakSelf.couponListReturnData = response;
                                                              
                                                          } fail:^(NSError *error) {
                                                              
                                                              [self hideLoadingHud];

                                                          }];
}

- (IBAction)onBackButtonAction:(id)sender
{
    if (self.couponButton1.selected) {
        if (self.onCouponHandler) {
            self.onCouponHandler(NO,nil);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
 
    }
}

- (IBAction)onCouponButtonAction:(id)sender
{
    UIButton *button = sender;
    
    if (button == self.couponButton1) {
        self.couponButton1.selected = YES;
        self.couponButton2.selected = NO;
        self.couponContainView.hidden = YES;
    }
    else if (button == self.couponButton2){
        self.couponButton1.selected = NO;
        self.couponButton2.selected = YES;
        if (!_couponListReturnData) {
            [self getUserCouponList];
        }
        else{
            _couponContainView.hidden = NO;
        }

    }
    [self.couponButton1 customButton:kCustomButtonType_NoUseCoupon];
    [self.couponButton2 customButton:kCustomButtonType_UseCoupon];
    

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponListReturnData.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSTakeoutCouponListViewController *weakSelf = self;
    static NSString *identifier = @"Cell";
    QSTakeoutCouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSTakeoutCouponListCell" owner:self options:nil];
        if ([nibs count] > 0) {
            cell = nibs[0];
        }
    }
    if (indexPath.row == 0) {
        cell.bgType = 0;
    }
    else if (indexPath.row == self.couponListReturnData.data.count-1){
        cell.bgType = 2;
    }
    else{
        cell.bgType = 1;
    }
    cell.item = self.couponListReturnData.data[indexPath.row];
    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onCouponHandler) {
        self.onCouponHandler(YES,self.couponListReturnData.data[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
