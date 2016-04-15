//
//  QSBindEMailViewController.m
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSBindEMailViewController.h"
#import "QSPhoneVerification.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"

@interface QSBindEMailViewController ()

@property (nonatomic, unsafe_unretained) BOOL hadBindMail;
@property (nonatomic, copy) NSString *vercode;
@end

@implementation QSBindEMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak QSBindEMailViewController *weakSelf = self;
    self.exchangemail2verButton = [[QSPhoneVerification alloc] initWithFrame:CGRectMake(DeviceWidth-74-20, 0, 74, 45) andPhoneField:self.exchangemail2TextField andCallBack:^(NSString *verCode) {
        weakSelf.vercode = verCode;
    }];
    [self.exchangemail2TextField setRightViewMode:UITextFieldViewModeAlways];
    self.exchangemail2TextField.rightView = self.exchangemail2verButton;
    
    self.bindverButton = [[QSPhoneVerification alloc] initWithFrame:CGRectMake(DeviceWidth-74-20, 0, 74, 45) andPhoneField:self.bindmailTextField andCallBack:^(NSString *verCode) {
        weakSelf.vercode = verCode;
    }];
    [self.bindmailTextField setRightViewMode:UITextFieldViewModeAlways];
    self.bindmailTextField.rightView = self.bindverButton;
    
    [self onSwButtonAction:nil];
}

- (void)setupUI
{
    [self.bindmailView roundCornerRadius:5];
    [self.bindverView roundCornerRadius:5];
    [self.bindconfirmButton roundCornerRadius:5];
    [self.exchangemail1View roundCornerRadius:5];
    [self.exchangemail2View roundCornerRadius:5];
    [self.exchangeverView roundCornerRadius:5];
    [self.exchangeconfirmButton roundCornerRadius:5];

}

- (IBAction)onConfirmButtonAction:(id)sender
{
    __weak QSBindEMailViewController *weakSelf = self;
    if (_hadBindMail) {
        if (![self.vercode isEqualToString:self.exchangeverTextField.text]) {
            return;
        }
        [self showLoadingHud];
        [[QSAPIClientBase sharedClient] bindEmail:self.exchangemail1TextField.text
                                         newEmail:self.exchangemail2TextField.text
                                           verCode:self.exchangeverTextField.text
                                           success:^(QSAPIModel *response) {
                                               [weakSelf hideLoadingHud];
                                               [weakSelf showTip:weakSelf.view tipStr:@"修改成功"];
                                           } fail:^(NSError *error) {
                                               [weakSelf hideLoadingHud];
                                           }];
        
    }
    else{
        if (![self.vercode isEqualToString:self.bindverTextField.text]) {
            return;
        }
        [self showLoadingHud];
        [[QSAPIClientBase sharedClient] bindEmail:nil
                                         newEmail:self.bindmailTextField.text
                                           verCode:self.bindverTextField.text
                                           success:^(QSAPIModel *response) {
                                               [weakSelf hideLoadingHud];
                                               [weakSelf showTip:weakSelf.view tipStr:@"修改成功"];
                                               
                                           } fail:^(NSError *error) {
                                               [weakSelf hideLoadingHud];
                                           }];
    }
}

- (IBAction)onSwButtonAction:(id)sender
{
    
    _hadBindMail = ![[UserManager sharedManager].userData.email isEqualToString:@""] && [UserManager sharedManager].userData.email;
    
    self.bindView.hidden = _hadBindMail;
    self.exchangeView.hidden = !_hadBindMail;
    
    self.titleLabel.text = _hadBindMail ? @"换绑邮箱" : @"绑定邮箱";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
