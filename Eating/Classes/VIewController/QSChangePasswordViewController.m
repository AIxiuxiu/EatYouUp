//
//  QSChangePasswordViewController.m
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSChangePasswordViewController.h"
#import "QSAPIClientBase+User.h"

@interface QSChangePasswordViewController ()

@end

@implementation QSChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)setupUI
{
    self.titleLabel.text = @"修改密码";
    [self.password1View roundCornerRadius:5];
    [self.password2View roundCornerRadius:5];
    [self.password3View roundCornerRadius:5];
    [self.confimButton roundCornerRadius:5];
}

- (IBAction)onConfirmButtonAction:(id)sender
{
    if (![self.password2TextField.text isEqualToString:self.password3TextField.text]) {
        return;
    }
    __weak QSChangePasswordViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] updateUserPassword:self.password1TextField.text
                                           NewPassword:self.password2TextField.text
                                               success:^(QSAPIModel *response) {
                                                   [weakSelf hideLoadingHud];
                                                   [weakSelf showTip:weakSelf.view tipStr:@"修改成功"];
                                                   
                                               } fail:^(NSError *error) {
                                                   [weakSelf hideLoadingHud];
                                               }];
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
