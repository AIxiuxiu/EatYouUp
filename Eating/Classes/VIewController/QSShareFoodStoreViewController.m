//
//  QSShareFoodStoreViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSShareFoodStoreViewController.h"
#import "QSBlockActionButton.h"
#import "QSAddImageView.h"
#import "QSStarRemark.h"
#import "QSShareTopicView.h"
#import "QSTextField.h"

#import <objc/runtime.h>

//输入框tag
#define TAG_SHAREDETECTIVE_STORE_INPUTFIELD_ROOT 150

//关联
static char RootScrollViewKey;
@interface QSShareFoodStoreViewController () <UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>{
    CGFloat _startLevel;
}

@end

@implementation QSShareFoodStoreViewController

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _startLevel = 6.0f;
    }
    
    return self;
}

//**********************************
//             UI搭建
//**********************************
#pragma mark - UI搭建
- (void)createNavigationBar
{
    [super createNavigationBar];
    [self setMiddleTitle:@"探店分享"];
    
    //右侧提交按钮
    UIButton *rightButton = [UIButton createBlockActionButton:CGRectMake(0.0f, 0.0f, 22.0f, 15.0f) andStyle:[QSButtonStyleModel createShareFoodStoreActivityConfirmButtonStyle] andCallBack:^(UIButton *button) {
        
    }];
    [self setRightView:rightButton];
}

//主展示UI
- (void)createMiddleMainShowView
{
    //消取scroll view自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //底部滚动scrollview
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 105.0f, DeviceWidth, DeviceHeight - 105.0f)];
    
    //隐藏滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    //设置代理
    scrollView.delegate = self;
    
    //添加子控件
    [self createInputView:scrollView];
    
    //加载
    [self.view addSubview:scrollView];
    
    //关联
    objc_setAssociatedObject(self, &RootScrollViewKey, scrollView, OBJC_ASSOCIATION_ASSIGN);
}

//加载输入控件
- (void)createInputView:(UIScrollView *)scrollView
{
#if 1
    //记录纵向高度
    CGFloat contentHeight = 0.0f;
    
    //tag值迭代
    int i = 0;
    
    //店名
    QSTextField *marName = [[QSTextField alloc] initWithFrame:CGRectMake(10.0f, 5.0f, DeviceWidth-20.0f, 44.0f)];
    marName.delegate = self;
    marName.placeholder = @"探店商家名称";
    marName.font = [UIFont systemFontOfSize:14.0f];
//    marName.borderStyle = UITextBorderStyleRoundedRect;
    marName.layer.cornerRadius = 6.0f;
    marName.backgroundColor = [UIColor whiteColor];
    marName.clearButtonMode = UITextFieldViewModeAlways;
    marName.tag = TAG_SHAREDETECTIVE_STORE_INPUTFIELD_ROOT + i;
    [scrollView addSubview:marName];
    contentHeight = contentHeight + 44.0f + 5.0f;
    i++;
    
    //城市
    QSTextField *city = [[QSTextField alloc] initWithFrame:CGRectMake(10.0f, contentHeight+5.0f, (DeviceWidth-30.0f)/2.0f+10.0f, 44.0f)];
    city.delegate = self;
    city.placeholder = @"城市";
    city.font = [UIFont systemFontOfSize:14.0f];
//    city.borderStyle = UITextBorderStyleRoundedRect;
    city.layer.cornerRadius = 6.0f;
    city.backgroundColor = [UIColor whiteColor];
    city.clearButtonMode = UITextFieldViewModeAlways;
    city.tag = TAG_SHAREDETECTIVE_STORE_INPUTFIELD_ROOT + i;
    [scrollView addSubview:city];
    i++;
    
    //区域
    QSTextField *area = [[QSTextField alloc] initWithFrame:CGRectMake((DeviceWidth-30.0f)/2.0f+30.0f, contentHeight+5.0f, (DeviceWidth-30.0f)/2.0f-10.0f, 44.0f)];
    area.delegate = self;
    area.placeholder = @"区域";
    area.font = [UIFont systemFontOfSize:14.0f];
//    area.borderStyle = UITextBorderStyleRoundedRect;
    area.layer.cornerRadius = 6.0f;
    area.backgroundColor = [UIColor whiteColor];
    area.clearButtonMode = UITextFieldViewModeAlways;
    area.tag = TAG_SHAREDETECTIVE_STORE_INPUTFIELD_ROOT + i;
    [scrollView addSubview:area];
    contentHeight = contentHeight + 44.0f + 5.0f;
    i++;
    
    //城市和区域右箭头
    UIButton *arrowButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowButton1 setImage:[UIImage imageNamed:@"sharefoodstore_city_arrow"] forState:UIControlStateNormal];
    arrowButton1.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    city.rightViewMode = UITextFieldViewModeAlways;
    [city setRightView:(UIView *)arrowButton1];
    
    UIButton *arrowButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowButton2 setImage:[UIImage imageNamed:@"sharefoodstore_city_arrow"] forState:UIControlStateNormal];
    arrowButton2.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    area.rightViewMode = UITextFieldViewModeAlways;
    [area setRightView:(UIView *)arrowButton2];
    
    //地址
    QSTextField *address = [[QSTextField alloc] initWithFrame:CGRectMake(10.0f, contentHeight+5.0f, DeviceWidth-20.0f, 44.0f)];
    address.delegate = self;
    address.placeholder = @"商家地址";
    address.font = [UIFont systemFontOfSize:14.0f];
//    address.borderStyle = UITextBorderStyleRoundedRect;
    address.layer.cornerRadius = 6.0f;
    address.backgroundColor = [UIColor whiteColor];
    address.clearButtonMode = UITextFieldViewModeAlways;
    address.tag = TAG_SHAREDETECTIVE_STORE_INPUTFIELD_ROOT + i;
    [scrollView addSubview:address];
    contentHeight = contentHeight + 44.0f + 5.0f;
    i++;
    
    //地点定位图标
    UIButton *localButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [localButton setImage:[UIImage imageNamed:@"fooddetective_add_local_normal"] forState:UIControlStateNormal];
    [localButton setImage:[UIImage imageNamed:@"fooddetective_add_local_highlighted"] forState:UIControlStateHighlighted];
    localButton.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    address.rightViewMode = UITextFieldViewModeAlways;
    [address setRightView:(UIView *)localButton];
    
    //商家印象
    UITextView *marImpression = [[UITextView alloc] initWithFrame:CGRectMake(10.0, contentHeight+5.0f, DeviceWidth-20.0f, 60.0f)];
    marImpression.delegate = self;
    marImpression.showsHorizontalScrollIndicator = NO;
    marImpression.showsVerticalScrollIndicator = NO;
    marImpression.text = @"商家印象";
    marImpression.textColor = kBaseLightGrayColor;
    marImpression.layer.cornerRadius = 6.0f;
    marImpression.font = [UIFont systemFontOfSize:14.0f];
    marImpression.tag = TAG_SHAREDETECTIVE_STORE_INPUTFIELD_ROOT + i;
    [scrollView addSubview:marImpression];
    contentHeight = contentHeight + 60.0f + 5.0f;
    i++;
    
    //添加图片
    QSAddImageView *addImageView = [[QSAddImageView alloc] initWithFrame:CGRectMake(10.0f, contentHeight+5.0f, DeviceWidth-20.0f, 70.0f)];
    addImageView.backgroundColor = [UIColor whiteColor];
    addImageView.layer.cornerRadius = 6.0f;
    [scrollView addSubview:addImageView];
    contentHeight = contentHeight + 70.0f + 5.0f;
    
    //点评
    //商家印象
    UITextView *marRemark = [[UITextView alloc] initWithFrame:CGRectMake(10.0, contentHeight+5.0f, DeviceWidth-20.0f, 60.0f)];
    marRemark.delegate = self;
    marRemark.showsHorizontalScrollIndicator = NO;
    marRemark.showsVerticalScrollIndicator = NO;
    marRemark.text = @"点评内容";
    marRemark.textColor = kBaseLightGrayColor;
    marRemark.layer.cornerRadius = 6.0f;
    marRemark.font = [UIFont systemFontOfSize:14.0f];
    marRemark.tag = TAG_SHAREDETECTIVE_STORE_INPUTFIELD_ROOT + i;
    [scrollView addSubview:marRemark];
    contentHeight = contentHeight + 60.0f + 5.0f;
    i++;
    
    //总体点评
    QSStarRemark *starRemark = [[QSStarRemark alloc] initWithFrame:CGRectMake(10.0, contentHeight+5.0f, DeviceWidth-20.0f, 44.0f) andCallBack:^(CGFloat starLevel) {
        _startLevel = starLevel;
    }];
    starRemark.layer.cornerRadius = 6.0f;
    starRemark.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:starRemark];
    contentHeight = contentHeight + 44.0f + 5.0f;
    
    //分享
    QSShareTopicView *shareTopic = [[QSShareTopicView alloc] initWithFrame:CGRectMake(10.0, contentHeight+5.0f, DeviceWidth-20.0f, 44.0f) andCallBack:^(SHARE_TOPIC_TYPE actionType) {
        [self shareButtonAction:actionType];
    }];
    shareTopic.layer.cornerRadius = 6.0f;
    shareTopic.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:shareTopic];
    contentHeight = contentHeight + 44.0f + 5.0f;
    
    //设置scrollview的contentSize
    if (contentHeight > scrollView.frame.size.height) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, contentHeight+30.0f);
    } else {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height+20.0f);
    }
    
    //添加键盘回收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoverInputView:) name:UIKeyboardWillHideNotification object:nil];
#endif
}

//*******************************
//             分享按钮事件
//*******************************
#pragma mark - 分享按钮事件
- (void)shareButtonAction:(SHARE_TOPIC_TYPE)actionType
{
    switch (actionType) {
        //分享到新浪微博
        case SINA_MICROBLOG_STY:
            NSLog(@"sina");
            break;
            
        //分享到腾讯微博
        case TENCENT_MICROBLOG_STY:
            NSLog(@"tencent");
            break;
        
        //分享到QQ说说
        case QQ_STY:
            NSLog(@"qq");
            break;
            
        //分享到微信
        case WECHAT_STY:
            NSLog(@"wechat");
            break;
            
        default:
            break;
    }
}

//*******************************
//             UITextField回收键盘
//*******************************
#pragma mark - UITextField回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view = objc_getAssociatedObject(self, &RootScrollViewKey);
    for (UIView *obj in [view subviews]) {
        if ([obj isKindOfClass:[UITextField class]]) {
            [((UITextField *)obj) resignFirstResponder];
        }
        
        if ([obj isKindOfClass:[UITextView class]] ) {
            [((UITextView *)obj) resignFirstResponder];
        }
    }
}

//*******************************
//             弹出键盘时输入框滑动
//*******************************
#pragma mark - 弹出键盘时输入框滑动
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //大于103开始滑动
    if (textField.frame.origin.y > 103.0f) {
        UIView *rootView = objc_getAssociatedObject(self, &RootScrollViewKey);
        [UIView animateWithDuration:0.25 animations:^{
            rootView.frame = CGRectMake(rootView.frame.origin.x, textField.frame.origin.y - 103.0f + 60.0f, rootView.frame.size.width, rootView.frame.size.height);
        }];
    } else {
        UIView *rootView = objc_getAssociatedObject(self, &RootScrollViewKey);
        [UIView animateWithDuration:0.25 animations:^{
            rootView.frame = CGRectMake(rootView.frame.origin.x, 105.0f, rootView.frame.size.width, rootView.frame.size.height);
        }];
    }
    
    return YES;
}

//回收键盘时输入框恢复
- (void)recoverInputView:(NSNotification *)notification
{
    UIView *rootView = objc_getAssociatedObject(self, &RootScrollViewKey);
    [UIView animateWithDuration:0.25 animations:^{
        rootView.frame = CGRectMake(rootView.frame.origin.x, 105.0f, rootView.frame.size.width, rootView.frame.size.height);
    }];
}

//***************************************
//UITextView开始编辑时清空内容/结束编辑时，若没有输入内容，则恢复默认信息
//***************************************
#pragma mark - UITextView开始编辑/结束编辑状态修改
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //滑动键盘
    if (textView.frame.origin.y == 152.0f) {
        UIView *rootView = objc_getAssociatedObject(self, &RootScrollViewKey);
        [UIView animateWithDuration:0.25 animations:^{
            rootView.frame = CGRectMake(rootView.frame.origin.x, 105.0f - 83, rootView.frame.size.width, rootView.frame.size.height);
        }];
    }
    
    if (textView.frame.origin.y == 292.0f) {
        UIView *rootView = objc_getAssociatedObject(self, &RootScrollViewKey);
        [UIView animateWithDuration:0.25 animations:^{
            rootView.frame = CGRectMake(rootView.frame.origin.x, 105.0f - 250.0f, rootView.frame.size.width, rootView.frame.size.height);
        }];
    }
    
    if ([textView.text isEqualToString:@"商家印象"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    if ([textView.text isEqualToString:@"点评内容"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!([textView.text length] > 0)) {
        textView.text = @"商家印象";
        textView.textColor = kBaseLightGrayColor;
        if (textView.tag == TAG_SHAREDETECTIVE_STORE_INPUTFIELD_ROOT+5) {
            textView.text = @"点评内容";
        }
    }
}

@end
