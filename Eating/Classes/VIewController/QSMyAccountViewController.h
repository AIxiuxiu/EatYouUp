//
//  QSMyAccountViewController.h
//  Eating
//
//  Created by System Administrator on 11/20/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSMyAccountViewController : QSViewController

@property (weak, nonatomic) IBOutlet UITableView *accountTableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)onLogoutButtonAction:(id)sender;
@end
