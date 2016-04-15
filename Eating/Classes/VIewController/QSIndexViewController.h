//
//  QSIndexViewController.h
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSIndexViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIButton *locateButton;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *takeoutButton;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeoutLabel;

@property (weak, nonatomic) IBOutlet UITableView *indexTableView;

- (IBAction)onLocateButtonAction:(id)sender;

- (IBAction)onOrderButtonAction:(id)sender;

- (IBAction)onTakeoutButtonAction:(id)sender;

@end
