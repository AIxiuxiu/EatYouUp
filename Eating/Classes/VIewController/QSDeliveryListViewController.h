//
//  QSDeliveryListViewController.h
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSDeliveryListViewController : QSViewController

@property (weak, nonatomic) IBOutlet UITableView *deliveryTableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

- (IBAction)onAddDeliverButtonAction:(id)sender;


@end
