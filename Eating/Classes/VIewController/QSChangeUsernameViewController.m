//
//  QSChangeUsernameViewController.m
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSChangeUsernameViewController.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"

@interface QSChangeUsernameViewController ()

@end

@implementation QSChangeUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.usernameTextField.text = [UserManager sharedManager].userData.username;
    
    if ([[UserManager sharedManager].userData.sex isEqualToString:@"1"]) {
        [self onSexButtonAction:self.maleButton];
    }
    else{
        [self onSexButtonAction:self.femaleButton];
    }

}

- (void)setupUI
{
    self.titleLabel.text = @"修改用户名";
    [self.usernameView roundCornerRadius:5];
    [self.sexView roundCornerRadius:5];
    [self.confimButton roundCornerRadius:5];
}

- (IBAction)onSexButtonAction:(id)sender
{
    UIButton *button = sender;
    if (button == self.maleButton) {
        self.femaleButton.selected = NO;
    }
    else{
        self.maleButton.selected = NO;
    }
    button.selected = YES;
    [self.maleButton customButton:kCustomButtonType_Male];
    [self.femaleButton customButton:kCustomButtonType_Female];
    
}

- (IBAction)onConfirmButtonAction:(id)sender
{
    __weak QSChangeUsernameViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] updateUserName:self.usernameTextField.text
                                               Sex:self.maleButton.selected ? @"1" : @"0"
                                           success:^(QSAPIModel *response) {
                                               [weakSelf hideLoadingHud];
                                               [weakSelf showTip:weakSelf.view tipStr:@"修改成功"];
                                               [UserManager sharedManager].userData.username = weakSelf.usernameTextField.text;
                                               [UserManager sharedManager].userData.sex = self.maleButton.selected ? @"1" : @"0";
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
