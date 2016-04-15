//
//  QSLoginViewController.h
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"


@interface QSLoginViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIView *textFieldContainView;
@property (weak, nonatomic) IBOutlet UIView *usernameContainView;
@property (weak, nonatomic) IBOutlet UIView *passwordContainView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *toRetrivePdButton;
@property (weak, nonatomic) IBOutlet UIButton *toRegisterButton;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) void(^loginViewStatusCallback)(LOGINVIEW_STATUS);

- (IBAction)onLoginButtonAction:(id)sender;

- (IBAction)onRetrivePdButtonAction:(id)sender;

- (IBAction)onRegisterButtonAction:(id)sender;

@end
