//
//  RegisterViewController.m
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSRegisterViewController.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"
#import "QSPhoneVerification.h"

@interface QSRegisterViewController ()<UITextFieldDelegate>
{
    UITextField *_firstResponser;
}
@property (nonatomic, copy) NSString *vercode;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, unsafe_unretained) NSInteger pastSecond;
@property (nonatomic, strong) QSPhoneVerification *verButton;

@end

@implementation QSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pastSecond = 60;
    self.handoverButton.enabled = NO;
    [self.handoverButton setBackgroundColor:self.handoverButton.enabled ? kBaseGreenColor : kBaseGrayColor];
    __weak QSRegisterViewController *weakSelf = self;
    self.verButton = [[QSPhoneVerification alloc] initWithFrame:CGRectMake(DeviceWidth-74-20, 0, 74, 45) andPhoneField:self.mobileTextField andCallBack:^(NSString *verCode) {
        weakSelf.vercode = verCode;
    }];
    [self.mobileTextField setRightViewMode:UITextFieldViewModeAlways];
    self.mobileTextField.rightView = self.verButton;
}


- (void)setupUI
{
    self.titleLabel.text = @"注册";
    
    [self.mobileContainView roundCornerRadius:kButtonDefaultCornerRadius];
    [self.verifyContainView roundCornerRadius:kButtonDefaultCornerRadius];
    [self.passwordContainView roundCornerRadius:kButtonDefaultCornerRadius];

    [self.handoverButton roundCornerRadius:kButtonDefaultCornerRadius];

    [self.declareButton customButton:kCustomButtonType_RegisterLiscense];
    
    self.mobileTextField.returnKeyType = UIReturnKeyNext;
    self.verifyTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;

}

- (IBAction)onReadDeclareButtonAction:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    [self.declareButton customButton:kCustomButtonType_RegisterLiscense];
    self.handoverButton.enabled = button.selected;
    [self.handoverButton setBackgroundColor:self.handoverButton.enabled ? kBaseGreenColor : kBaseGrayColor];
}

- (IBAction)onHandoverButtonAction:(id)sender
{
    
    if (![self.verifyTextField.text isEqualToString:self.vercode]) {
        
        [self showTip:self.view tipStr:@"验证码有误，请重新输入"];
        return;
        
    }
    
    [_firstResponser resignFirstResponder];
    __weak QSRegisterViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] userRegister:self.mobileTextField.text
                                        password:self.passwordTextField.text
                                         success:^(QSAPIModel *response) {
                                             
                                             if (response.type) {
                                                 
                                                 [weakSelf showTip:self.view tipStr:@"注册成功"];
                                                 
                                                 ///保存用户信息
                                                 [[NSUserDefaults standardUserDefaults] setObject:self.mobileTextField.text forKey:@"user_login_count"];
                                                 [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"user_login_pwd"];
                                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                                 
                                                 [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                                 
                                             } else {
                                             
                                                 [self showTip:self.view tipStr:response.info];
                                             
                                             }
                                             
                                         } fail:^(NSError *error) {
                                             
                                             [self showTip:self.view tipStr:@"网络繁忙，请稍后再试"];
                                             
                                         }];
}


#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _firstResponser = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.mobileTextField) {
        [self.verifyTextField becomeFirstResponder];
    }
    else if (textField == self.verifyTextField){
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField){
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}

@end
