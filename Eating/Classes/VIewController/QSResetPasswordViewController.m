//
//  ResetPasswordViewController.m
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSResetPasswordViewController.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"

@interface QSResetPasswordViewController ()
{
    UITextField *_firstResponser;
}
@end

@implementation QSResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setupUI
{
    self.titleLabel.text = @"重置密码";

    [self.oldpasswordContainView roundCornerRadius:kButtonDefaultCornerRadius];
    [self.passwordContainView roundCornerRadius:kButtonDefaultCornerRadius];
    [self.newpasswordContainView roundCornerRadius:kButtonDefaultCornerRadius];
    
    [self.handoverButton roundCornerRadius:kButtonDefaultCornerRadius];
    
    self.oldpasswordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.newpasswordTextField.returnKeyType = UIReturnKeyDone;
}

- (IBAction)onHandoverButtonAction:(id)sender
{
    
    if (![self.passwordTextField.text isEqualToString:self.newpasswordTextField.text]) {
        return;
    }
    __weak QSResetPasswordViewController *weakSelf = self;
    [_firstResponser resignFirstResponder];
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] changePasswordByPhone:self.mobile
                                                 password:self.newpasswordTextField.text
                                                  success:^(QSAPIModel *response) {
                                                      [weakSelf showTip:self.view tipStr:@"重置密码成功"];
                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                  } fail:^(NSError *error) {
                                                      
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
    if (textField == self.passwordTextField) {
        [self.newpasswordTextField becomeFirstResponder];
    }
    else if (textField == self.newpasswordTextField){
        [self onHandoverButtonAction:nil];
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
