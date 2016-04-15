//
//  QSRecommendFoodListViewController.h
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSRecommendFoodListViewController : QSViewController

@property (nonatomic, copy) NSString *merchant_id;

@property (weak, nonatomic) IBOutlet UIButton *confirmButtonAction;
@property (weak, nonatomic) IBOutlet UITableView *foodTableView;

@property (nonatomic, strong) NSMutableArray *preFoodlist;

@property (nonatomic, strong) void(^onConfirmHandler)(NSMutableArray *);

- (IBAction)onConfirmButtonAction:(id)sende;

@end
