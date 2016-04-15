//
//  QSCouponFilterListViewController.h
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSCouponFilterListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (weak, nonatomic) IBOutlet UIButton * filterButton;

- (IBAction)onFilterButtonAction:(id)sender;

@end
