//
//  QSTakeoutCouponListViewController.h
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSCouponDetailData;
@interface QSTakeoutCouponListViewController : QSViewController

@property (nonatomic, copy) NSString *merchant_id;

@property (weak, nonatomic) IBOutlet UIView *couponView1;
@property (weak, nonatomic) IBOutlet UIView *couponView2;

@property (weak, nonatomic) IBOutlet UIButton *couponButton1;
@property (weak, nonatomic) IBOutlet UIButton *couponButton2;

@property (weak, nonatomic) IBOutlet UIView *couponContainView;
@property (weak, nonatomic) IBOutlet UIView *offlineCouponView;
@property (weak, nonatomic) IBOutlet UITextField *offlineCouponTextField;
@property (weak, nonatomic) IBOutlet UITableView *couponTableView;

@property (nonatomic, strong) void(^onCouponHandler)(BOOL, QSCouponDetailData *);

- (IBAction)onCouponButtonAction:(id)sender;


@end
