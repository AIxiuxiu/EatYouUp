//
//  QSBindMobileViewController.m
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSBindMobileViewController.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"
#import "QSPhoneVerification.h"

@interface QSBindMobileViewController ()

@property (nonatomic, unsafe_unretained) BOOL hadBindMobile;
@property (nonatomic, copy) NSString *vercode;
@end

@implementation QSBindMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak QSBindMobileViewController *weakSelf = self;
    self.exchangemobile2verButton = [[QSPhoneVerification alloc] initWithFrame:CGRectMake(DeviceWidth-74-20, 0, 74, 45) andPhoneField:self.exchangemobile2TextField andCallBack:^(NSString *verCode) {
        weakSelf.vercode = verCode;
    }];
    [self.exchangemobile2TextField setRightViewMode:UITextFieldViewModeAlways];
    self.exchangemobile2TextField.rightView = self.exchangemobile2verButton;
    
    self.bindverButton = [[QSPhoneVerification alloc] initWithFrame:CGRectMake(DeviceWidth-74-20, 0, 74, 45) andPhoneField:self.bindmobileTextField andCallBack:^(NSString *verCode) {
        weakSelf.vercode = verCode;
    }];
    [self.bindmobileTextField setRightViewMode:UITextFieldViewModeAlways];
    self.bindmobileTextField.rightView = self.bindverButton;
}

- (void)setupUI
{
    [self.bindmobileView roundCornerRadius:5];
    [self.bindverView roundCornerRadius:5];
    [self.bindconfirmButton roundCornerRadius:5];
    [self.exchangemobile1View roundCornerRadius:5];
    [self.exchangemobile2View roundCornerRadius:5];
    [self.exchangeverView roundCornerRadius:5];
    [self.exchangeconfirmButton roundCornerRadius:5];
    
    [self onSwButtonAction:nil];
}


- (IBAction)onSwButtonAction:(id)sender
{
    _hadBindMobile = ![[UserManager sharedManager].userData.iphone isEqualToString:@""] && [UserManager sharedManager].userData.iphone;
    self.bindView.hidden = _hadBindMobile;
    self.exchangeView.hidden = !_hadBindMobile;
    
    self.titleLabel.text = _hadBindMobile ? @"换绑手机" : @"绑定手机";
    
}

- (IBAction)onConfirmButtonAction:(id)sender
{
    __weak QSBindMobileViewController *weakSelf = self;
    if (_hadBindMobile) {
        if (![self.vercode isEqualToString:self.exchangeverTextField.text]) {
            return;
        }
        [self showLoadingHud];
        [[QSAPIClientBase sharedClient] bindMobile:self.exchangemobile1TextField.text
                                         newMobile:self.exchangemobile2TextField.text
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
        [[QSAPIClientBase sharedClient] bindMobile:nil
                                         newMobile:self.bindmobileTextField.text
                                           verCode:self.bindverTextField.text
                                           success:^(QSAPIModel *response) {
                                               [weakSelf hideLoadingHud];
                                               [weakSelf showTip:weakSelf.view tipStr:@"修改成功"];

                                           } fail:^(NSError *error) {
                                               [weakSelf hideLoadingHud];
                                           }];
    }
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
