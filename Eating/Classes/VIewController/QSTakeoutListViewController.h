//
//  QSTakeoutListViewController.h
//  Eating
//
//  Created by MJie on 14-11-17.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSMerchantIndexReturnData;
@interface QSTakeoutListViewController : QSViewController

@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, strong) QSMerchantIndexReturnData *merchantIndexReturnData;

@property (weak, nonatomic) IBOutlet UIButton *confirmButtonAction;
@property (weak, nonatomic) IBOutlet UITableView *foodTableView;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) void(^onConfirmHandler)(NSMutableArray *);

- (IBAction)onNextButtonAction:(id)sender;
@end
