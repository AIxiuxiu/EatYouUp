//
//  QSChangePasswordViewController.h
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSChangePasswordViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIView *password1View;
@property (weak, nonatomic) IBOutlet UITextField *password1TextField;
@property (weak, nonatomic) IBOutlet UIView *password2View;
@property (weak, nonatomic) IBOutlet UITextField *password2TextField;
@property (weak, nonatomic) IBOutlet UIView *password3View;
@property (weak, nonatomic) IBOutlet UITextField *password3TextField;

@property (weak, nonatomic) IBOutlet UIButton *confimButton;

- (IBAction)onConfirmButtonAction:(id)sender;

@end
