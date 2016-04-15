//
//  QSLoginViewController.m
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSLoginViewController.h"
#import "QSRetrivePasswordViewController.h"
#import "QSRegisterViewController.h"
#import "QSTabbarViewController.h"
#import "QSAPIClientBase+Login.h"
#import "QSAPIModel+Login.h"
#import "QSAPIModel+User.h"

@interface QSLoginViewController ()<UITextFieldDelegate>

@property (nonatomic,assign) BOOL isRegist;//!<标记是否是进入注册页面

@end

@implementation QSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
    if (self.isRegist) {
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_login_count"];
        NSString *userPwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_login_pwd"];
        self.usernameTextField.text = userName;
        self.passwordTextField.text = userPwd;
        
    }

}

- (void)setupUI
{
    self.titleLabel.text = @"吃订你";
    self.usernameContainView.backgroundColor = HEXCOLOR(0xD83E2F);
    self.passwordContainView.backgroundColor = HEXCOLOR(0xD83E2F);
    
    [self.usernameContainView roundCornerRadius:6];
    [self.passwordContainView roundCornerRadius:6];
    
    self.backgroundImageView.backgroundColor = kBaseOrangeColor;
    
    [self.usernameTextField textWithWhiteColor:@"邮箱/手机号码/用户名"];
    [self.passwordTextField textWithWhiteColor:@"输入密码"];
    
    [self.loginButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.loginButton.layer setBorderWidth:8];
    [self.loginButton roundButton];
    
    self.usernameTextField.text = self.username;
    self.passwordTextField.text = self.password;
    
    self.usernameTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
}

- (IBAction)onBackButtonAction:(id)sender
{
    __weak QSLoginViewController *weakSelf = self;

    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.loginViewStatusCallback) {
            weakSelf.loginViewStatusCallback(LOGINVIEW_STATUS_DISMISS);
        }

    }];
}

- (IBAction)onLoginButtonAction:(id)sender
{
    __weak QSLoginViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] userLoginWithUsername:self.usernameTextField.text
                                                 password:self.passwordTextField.text
                                                  success:^(BOOL flag, QSUserReturnData *response, NSString *errorInfo, NSString *errorCode) {
                                                      
                                                      if (!flag) {
                                                          
                                                          [self showTip:self.view tipStr:errorInfo];
                                                          [weakSelf hideLoadingHud];
                                                          return;
                                                          
                                                      }
                                                      
                                                      ///保存用户账号信息
                                                      [[NSUserDefaults standardUserDefaults] setObject:self.usernameTextField.text forKey:@"user_login_count"];
                                                      [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"user_login_pwd"];
                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                      
                                                      [weakSelf hideLoadingHud];
                                                      response.userData.password = self.passwordTextField.text;
                                                      [UserManager sharedManager].userData = response.userData;
                                                      if (weakSelf.loginViewStatusCallback) {
                                                          weakSelf.loginViewStatusCallback(LOGINVIEW_STATUS_SUCCESS);
                                                      }
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLoginNotification object:nil];
                                                      [weakSelf dismissViewControllerAnimated:YES completion:^{
                                                          
                                                      }];
                                                      
                                                  } fail:^(NSError *error) {
                                                      
                                                      [weakSelf hideLoadingHud];
                                                      if (weakSelf.loginViewStatusCallback) {
                                                          weakSelf.loginViewStatusCallback(LOGINVIEW_STATUS_FAIL);
                                                      }

                                                  }];
}

- (IBAction)onRetrivePdButtonAction:(id)sender
{
    QSRetrivePasswordViewController *viewVC = [[QSRetrivePasswordViewController alloc] init];
    self.isRegist = YES;
    [self.navigationController pushViewController:viewVC
                                         animated:YES];
}

- (IBAction)onRegisterButtonAction:(id)sender
{
    QSRegisterViewController *viewVC = [[QSRegisterViewController alloc] init];
    [self.navigationController pushViewController:viewVC
                                         animated:YES];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField){
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}

@end
