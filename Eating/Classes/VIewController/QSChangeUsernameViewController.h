//
//  QSChangeUsernameViewController.h
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSChangeUsernameViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *confimButton;
- (IBAction)onSexButtonAction:(id)sender;

- (IBAction)onConfirmButtonAction:(id)sender ;
@end


