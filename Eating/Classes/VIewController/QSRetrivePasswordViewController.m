//
//  RetrivePasswordViewController.m
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSRetrivePasswordViewController.h"
#import "QSResetPasswordViewController.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"
#import "QSPhoneVerification.h"

@interface QSRetrivePasswordViewController ()
@property (nonatomic, copy) NSString *vercode;
@property (nonatomic, strong) QSPhoneVerification *verButton;

@end

@implementation QSRetrivePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupUI
{
    self.titleLabel.text = @"密码找回";
    
    [self.mobileContainView roundCornerRadius:kButtonDefaultCornerRadius];
    [self.verifyContainView roundCornerRadius:kButtonDefaultCornerRadius];
    
    [self.handoverButton roundCornerRadius:kButtonDefaultCornerRadius];
    
    self.mobileTextField.returnKeyType = UIReturnKeyNext;
    self.verifyTextField.returnKeyType = UIReturnKeyDone;
    
    __weak QSRetrivePasswordViewController *weakSelf = self;
    self.verButton = [[QSPhoneVerification alloc] initWithFrame:CGRectMake(DeviceWidth-74-10, 0, 74, 45) andPhoneField:self.mobileTextField andCallBack:^(NSString *verCode) {
        weakSelf.vercode = verCode;
    }];
    [self.mobileTextField setRightViewMode:UITextFieldViewModeAlways];
    self.mobileTextField.rightView = self.verButton;

}


- (IBAction)onHandoverButtonAction:(id)sender
{
    if (![self.vercode isEqualToString:self.verifyTextField.text]) {
        return;
    }
    QSResetPasswordViewController *viewVC = [[QSResetPasswordViewController alloc] init];
    viewVC.mobile = self.mobileTextField.text;
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
    if (textField == self.mobileTextField) {
        [self.verifyTextField becomeFirstResponder];
    }
    else if (textField == self.verifyTextField){
        [self.verifyTextField resignFirstResponder];
    }
    return YES;
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
