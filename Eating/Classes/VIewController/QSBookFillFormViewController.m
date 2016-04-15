//
//  QSBookFillFormViewController.m
//  Eating
//
//  Created by System Administrator on 11/19/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSBookFillFormViewController.h"
#import "QSTakeoutOrderListViewController.h"
#import "ASDepthModalViewController.h"
#import "QSAPIClientBase+Book.h"
#import "QSAPIModel+Book.h"
#import "QSAPIModel+Food.h"
#import "QSDatePickerViewController.h"
#import "QSAPIModel+Merchant.h"
#import "QSAPIModel+FoodGroud.h"
#import "NSDate+QSDateFormatt.h"
#import "QSAPIModel+User.h"

@interface QSBookFillFormViewController ()<UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) QSDatePickerViewController *datePickerVC;

@end

@implementation QSBookFillFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = self.merchantIndexReturnData.data.merchant_name;

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 100, 25)];
    label2.backgroundColor = kBaseGreenColor;
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:11.0];
    label2.text = @"预约订单";
    
    [self.merchantLogoImageView setImageWithURL:[NSURL URLWithString:[self.merchantIndexReturnData.data.merchant_logo imageUrl]] placeholderImage:IMAGENAME(@"merchant_defaultlog")];
    [self.merchantLogoImageView roundView];
    [self.merchantLogoImageView.layer setBorderWidth:3];
    [self.merchantLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.merchantLogoImageView addSubview:label2];
    self.merchantLogoImageView.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.bookScrollView.frame;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 107;
    self.bookScrollView.frame = frame;
}

- (void)setupUI
{
    [self.countButton roundCornerRadius:5];
    [self.seatTypeButton roundCornerRadius:5];
    [self.dateButton roundCornerRadius:5];
    [self.timeButton roundCornerRadius:5];
    [self.mobileView roundCornerRadius:5];
    [self.nameView roundCornerRadius:5];
    
    [self.countButton customButton:kCustomButtonType_ItemSelect];
    [self.seatTypeButton customButton:kCustomButtonType_ItemSelect];
    [self.dateButton customButton:kCustomButtonType_ItemSelect];
    [self.timeButton customButton:kCustomButtonType_ItemSelect];
    [self.sexButton customButton:kCustomButtonType_ItemSelect];
    [self.sexButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    NSString *sexString = [[UserManager sharedManager].userData.sex intValue] == 1 ? @"先生" : @"女士";
    [self.sexButton setTitle:sexString forState:UIControlStateNormal];
    [self.confirmButton roundCornerRadius:18];
    
    NSString *name = [UserManager sharedManager].userData.username ? [UserManager sharedManager].userData.username : nil;
    self.nameTextField.text = name;
    NSString *phone = [UserManager sharedManager].userData.username ? [UserManager sharedManager].userData.iphone : nil;
    self.mobileTextField.text = phone;
    
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.mobileTextField.returnKeyType = UIReturnKeyDone;
    
    ///如若订单模型有数据，则初始化数据
    if (self.teamModel) {
        
        [self initOrderInfoWithModel];
        
    }
    
}

/**
 *  @author yangshengmeng, 14-12-25 15:12:22
 *
 *  @brief  根据预约数据模型初始化控件信息
 *
 *  @since  2.0
 */
- (void)initOrderInfoWithModel
{
    
    ///预约日期
    [self.dateButton setTitle:[NSDate formatIntegerIntervalToDateString:self.teamModel.joinTime] forState:UIControlStateNormal];
    self.dateButton.userInteractionEnabled = NO;
    
    ///预约时间
    [self.timeButton setTitle:[NSDate formatIntegerIntervalToTime_HHMM:self.teamModel.joinTime] forState:UIControlStateNormal];
    self.timeButton.userInteractionEnabled = NO;
    
    ///就餐人数
    [self.countButton setTitle:[NSString stringWithFormat:@"%d",1+[self.teamModel.joinedNumber intValue]] forState:UIControlStateNormal];
    self.countButton.userInteractionEnabled = NO;

    ///用户名
    self.nameTextField.text = self.teamModel.leaderName;
    
    ///联系手机
    self.mobileTextField.text = self.teamModel.leaderPhone;

}

- (IBAction)onSeatNumButton:(id)sender
{
    __weak QSBookFillFormViewController *weakSelf = self;
    _datePickerVC = [[QSDatePickerViewController alloc] init];
    _datePickerVC.pickerType = kPickerType_Item;
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 1 ; i < 100 ; i++) {
        [temp addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _datePickerVC.dataSource = temp;
    [ASDepthModalViewController presentView:_datePickerVC.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
        
    }];
    
    _datePickerVC.onCancelButtonHandler = ^{
        [ASDepthModalViewController dismiss];
    };
    
    _datePickerVC.onItemConfirmButtonHandler = ^(NSInteger row, NSString *item){
        
        [weakSelf.countButton setTitle:item forState:UIControlStateNormal];
        [ASDepthModalViewController dismiss];
        
    };
}

- (IBAction)onSeatTypeButton:(id)sender
{
    __weak QSBookFillFormViewController *weakSelf = self;
    _datePickerVC = [[QSDatePickerViewController alloc] init];
    _datePickerVC.pickerType = kPickerType_Item;
    NSArray *temp = @[@"是",@"否"];
    _datePickerVC.dataSource = [temp mutableCopy];
    [ASDepthModalViewController presentView:_datePickerVC.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
        
    }];
    _datePickerVC.onCancelButtonHandler = ^{
        [ASDepthModalViewController dismiss];
    };
    _datePickerVC.onItemConfirmButtonHandler = ^(NSInteger row, NSString *item){
        [weakSelf.seatTypeButton setTitle:item forState:UIControlStateNormal];
        [ASDepthModalViewController dismiss];
    };
}

- (IBAction)onBookDateButton:(id)sender
{
    __weak QSBookFillFormViewController *weakSelf = self;
    _datePickerVC = [[QSDatePickerViewController alloc] init];
    _datePickerVC.pickerType = kPickerType_Date;
    [ASDepthModalViewController presentView:_datePickerVC.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
        
    }];
    _datePickerVC.onCancelButtonHandler = ^{
        [ASDepthModalViewController dismiss];
    };
    _datePickerVC.onDateConfirmButtonHandler = ^(NSDate *date, NSString *dateStr){
        [weakSelf.dateButton setTitle:dateStr forState:UIControlStateNormal];
        [ASDepthModalViewController dismiss];
    };
}

- (IBAction)onBookTimeButton:(id)sender
{
    
    __weak QSBookFillFormViewController *weakSelf = self;
    _datePickerVC = [[QSDatePickerViewController alloc] init];
    _datePickerVC.pickerType = kPickerType_Time;
    [ASDepthModalViewController presentView:_datePickerVC.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
        
    }];
    
    _datePickerVC.onCancelButtonHandler = ^{
        
        [ASDepthModalViewController dismiss];
        
    };
    
    _datePickerVC.onDateConfirmButtonHandler = ^(NSDate *date, NSString *dateStr){
        
        [weakSelf.timeButton setTitle:dateStr forState:UIControlStateNormal];
        [ASDepthModalViewController dismiss];
        
    };
    
}

- (IBAction)onSexButtonAction:(id)sender
{
    __weak QSBookFillFormViewController *weakSelf = self;
    _datePickerVC = [[QSDatePickerViewController alloc] init];
    _datePickerVC.pickerType = kPickerType_Item;
    NSArray *temp = @[@"先生",@"女士"];
    _datePickerVC.dataSource = [temp mutableCopy];
    [ASDepthModalViewController presentView:_datePickerVC.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
        
    }];
    _datePickerVC.onCancelButtonHandler = ^{
        [ASDepthModalViewController dismiss];
    };
    _datePickerVC.onItemConfirmButtonHandler = ^(NSInteger row, NSString *item){
        [weakSelf.sexButton setTitle:item forState:UIControlStateNormal];
        [ASDepthModalViewController dismiss];
    };
}

- (IBAction)onConfirmButtonAction:(id)sender
{
    
    if ([self.nameTextField.text isEqualToString:@""]) {
        
        [self showTip:self.view tipStr:@"请输入姓名"];
        return;
        
    }
    
    if ([self.mobileTextField.text isEqualToString:@""]) {
        
        [self showTip:self.view tipStr:@"请输入联系电话"];
        return;
        
    }
    
    __weak QSBookFillFormViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] addBookWithMerchantId:self.merchant_id
                                                 BookDate:self.dateButton.titleLabel.text
                                                 BookTime:self.timeButton.titleLabel.text
                                                BookNum:self.countButton.titleLabel.text
                                             BookSeatType:[self.seatTypeButton.titleLabel.text isEqualToString:@"是"] ? YES : NO
                                                 BookName:self.nameTextField.text
                                                BookPhone:self.mobileTextField.text
                                                 BookDesc:nil
                                                  BookSex:[self.sexButton.titleLabel.text isEqualToString:@"先生"] ? @"1" : @"0"
                                               BookMenArr:nil
                                                  success:^(QSAPIModelDict *response) {
                                                      
                                                      ///预约成功
                                                      [weakSelf hideLoadingHud];
                                                      
                                                      ///预约成功提示
                                                      [self showTip:self.view tipStr:@"预约成功！" andCallBack:^(){
                                                          
                                                          ///判断是否是成团操作
                                                          if (self.teamModel) {
                                                              
                                                              if (self.commitTeamCallBack) {
                                                                  self.commitTeamCallBack(response.type,response.msg);
                                                              }
                                                              
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                              return;
                                                          }
                                                      
                                                          QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
                                                          viewVC.orderListType = kOrderListType_Book;
                                                          [viewVC setValue:@"3" forKey:@"turnBackIndex"];
                                                          [weakSelf.navigationController pushViewController:viewVC animated:YES];
                                                      
                                                      }];
                                                      
                                                  } fail:^(NSError *error) {
                                                      
                                                      ///预约失败
                                                      [weakSelf hideLoadingHud];
                                                      [weakSelf showTip:self.view tipStr:@"预约失败"];
                                                      
                                                  }];
    
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.bookScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y+60) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.mobileTextField) {
        [self.bookScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.mobileTextField becomeFirstResponder];
    }
    else if (textField == self.mobileTextField){
        [self.mobileTextField resignFirstResponder];
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
