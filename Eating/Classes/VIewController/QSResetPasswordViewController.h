//
//  QSResetPasswordViewController.h
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSResetPasswordViewController : QSViewController

@property (nonatomic, copy) NSString *mobile;

@property (weak, nonatomic) IBOutlet UIView *oldpasswordContainView;
@property (weak, nonatomic) IBOutlet UIView *passwordContainView;
@property (weak, nonatomic) IBOutlet UIView *newpasswordContainView;

@property (weak, nonatomic) IBOutlet UITextField *oldpasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *newpasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *handoverButton;

- (IBAction)onHandoverButtonAction:(id)sender;


@end
