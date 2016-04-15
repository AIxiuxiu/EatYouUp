//
//  QSDeliveryDetailViewController.m
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSDeliveryDetailViewController.h"
#import "QSAPIClientBase+Delivery.h"
#import "QSAPIModel+Delivery.h"
#import <ASDepthModalViewController.h>
#import "QSDatePickerViewController.h"
#import "QSAPIModel+User.h"

@interface QSDeliveryDetailViewController ()<UITextFieldDelegate>
{
    UITextField *_firstResponser;
}
@property (nonatomic, unsafe_unretained) BOOL isNewAddress;
@property (nonatomic, strong) QSDatePickerViewController *datePickerVC;

@end

@implementation QSDeliveryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_item) {
        _isNewAddress = NO;
        self.titleLabel.text = @"管理送餐地址";
        if ([self.item.status isEqualToString:@"1"]) {
            self.setDefaultButton.selected = NO;
        }
        else{
            self.setDefaultButton.selected = YES;
        }
        
        
        self.nameTextField.text = self.item.name;
        self.mobileTextField.text = self.item.phone;
        NSArray *temp = [UserManager sharedManager].countyArray;
        NSArray *temp1 = [UserManager sharedManager].countyCodeArray;
        
        NSInteger index = [temp1 indexOfObject:self.item.area];
        if (index <= temp.count-1) {
            [self.countyButton setTitle:temp[index] forState:UIControlStateNormal];
        }
        
        self.addressTextField.text = self.item.address;
        
    }
    else{
        _isNewAddress = YES;
        self.titleLabel.text = @"添加送餐地址";
        self.setDefaultButton.selected = YES;
        self.item = [[QSDeliveryDetailData alloc] init];
    }
    
    
    
    [self onSetDefaultButtonAction:self.setDefaultButton];
}

- (void)setupUI
{
    [self.nameView roundCornerRadius:5];
    [self.mobileView roundCornerRadius:5];
    [self.areaView roundCornerRadius:5];
    [self.addressView roundCornerRadius:5];
    
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.mobileTextField.returnKeyType = UIReturnKeyNext;
    self.addressTextField.returnKeyType = UIReturnKeyDone;
    
}


- (IBAction)onSetDefaultButtonAction:(id)sender
{
    self.setDefaultButton.selected = !self.setDefaultButton.selected;
    [self.setDefaultButton customButton:kCustomButtonType_SetDefaultDeliveryAddress];
    self.item.status = self.setDefaultButton.selected ? @"1" : @"0";
}

- (IBAction)onConfirmButtonAction:(id)sender
{
    [_firstResponser resignFirstResponder];
    self.item.name = self.nameTextField.text;
    self.item.phone = self.mobileTextField.text;
    self.item.address = self.addressTextField.text;
    self.item.pro = @"440000";
    self.item.city = @"440100";
    if (_isNewAddress) {
        [[QSAPIClientBase sharedClient] addDelivery:self.item
                                            success:^(QSAPIModel *response) {
                                                
                                                ///保存默认的送餐地址
                                                [UserManager sharedManager].userData.default_address = self.item.address;
                                                
                                                [self.navigationController popViewControllerAnimated:YES];
                                                
                                            } fail:^(NSError *error) {
                                                
                                            }];
    }
    else{
        [[QSAPIClientBase sharedClient] updateDelivery:self.item
                                               success:^(QSAPIModel *response) {
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               } fail:^(NSError *error) {
                                                   
                                               }];
    }
}

- (IBAction)onAreaButtonAction:(id)sender
{
    __weak QSDeliveryDetailViewController *weakSelf = self;
    _datePickerVC = [[QSDatePickerViewController alloc] init];
    _datePickerVC.pickerType = kPickerType_Item;
    NSArray *temp = [UserManager sharedManager].countyArray;
    NSArray *temp1 = [UserManager sharedManager].countyCodeArray;

    _datePickerVC.dataSource = [temp mutableCopy];
    [ASDepthModalViewController presentView:_datePickerVC.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
        
    }];
    _datePickerVC.onCancelButtonHandler = ^{
        [ASDepthModalViewController dismiss];
    };
    _datePickerVC.onItemConfirmButtonHandler = ^(NSInteger row, NSString *item){
        [weakSelf.countyButton setTitle:item forState:UIControlStateNormal];
        weakSelf.item.area = temp1[row];
        [ASDepthModalViewController dismiss];
    };
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _firstResponser = textField;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.mobileTextField becomeFirstResponder];
    }
    else if (textField == self.mobileTextField){
        [self.addressTextField becomeFirstResponder];
    }
    else if (textField == self.addressTextField){
        [self.addressTextField resignFirstResponder];
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
