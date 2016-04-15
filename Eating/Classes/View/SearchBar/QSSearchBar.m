//
//  QSSearchBar.m
//  Eating
//
//  Created by ysmeng on 14/11/28.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSSearchBar.h"
#import "QSBlockActionButton.h"
#import "QSTextField.h"

@interface QSSearchBar ()<UITextFieldDelegate>

@end

@implementation QSSearchBar

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(SEARCHBAR_ACTION_TYPE actionType,NSString *result))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        //风格
        self.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:62.0f/255.0f blue:47.0f/255.0f alpha:0.6f];
        self.layer.cornerRadius = frame.size.height/2.0f;

        //保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
        //创建UI
        [self createQSSearchBarUI];
        
    }
    return self;
}

//创建搜索栏UI
- (void)createQSSearchBarUI
{
    //输入框
    QSTextField *inputView = [[QSTextField alloc] initWithFrame:CGRectMake(5.0f, 2.5f, self.frame.size.width - 10.0f, self.frame.size.height-5.0f)];
    inputView.delegate = self;
    inputView.placeholder = @"请输入搜索关键字";
    inputView.returnKeyType = UIReturnKeySearch;
    [self addSubview:inputView];
    
    //搜索按钮
    UIButton *searchButton = [UIButton createBlockActionButton:CGRectMake(4.0f, 4.0f, 22.0f, 22.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        //判断是否有内容
        if (self.callBack) {
            self.callBack(SEARCH_ACTION_SAT,inputView.text);
        }
        
        //回收键盘
        [inputView resignFirstResponder];
        
    }];
    [searchButton setImage:[UIImage imageNamed:@"prepaidcard_searchbar_search_button"] forState:UIControlStateNormal];
    inputView.leftViewMode = UITextFieldViewModeAlways;
    [inputView setLeftView:searchButton];
    
    //删除按钮
    UIButton *clearButton = [UIButton createBlockActionButton:CGRectMake(4.0f, 4.0f, 22.0f, 22.0f) andStyle:nil andCallBack:^(UIButton *button) {
        inputView.text = @"";
        if (self.callBack) {
            self.callBack(CLEARINPUT_SAT,nil);
        }
    }];
    [clearButton setImage:[UIImage imageNamed:@"prepaidcard_searchbar_clear"] forState:UIControlStateNormal];
    inputView.rightViewMode = UITextFieldViewModeWhileEditing;
    [inputView setRightView:clearButton];
}

#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
     self.callBack(SEARCH_ACTION_SAT,textField.text);
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *obj in [self subviews]) {
        if ([obj isKindOfClass:[UITextField class]]) {
            [((UITextField *)obj) resignFirstResponder];
        }
    }
}

#pragma mark - 搜索框开始输入/修改/结束输入回调
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.callBack && ([textField.text length] > 0)) {
        self.callBack(DIDBEGINEDIT_SAT,textField.text);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.callBack) {
        self.callBack(DIDENDEDITING_SAT,textField.text);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.callBack && ([textField.text length] > 0)) {
        self.callBack(DIDENDEDITING_SAT,textField.text);
    }
    return YES;
}

@end
