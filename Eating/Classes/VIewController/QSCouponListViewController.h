//
//  QSCouponListViewController.h
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSCouponListViewController : QSViewController

@property (weak, nonatomic) IBOutlet UITableView *couponTableView;

@property (weak, nonatomic) IBOutlet UIButton *filterBallButton;

- (IBAction)onFilterBallButtonAction:(id)sender;

@end
