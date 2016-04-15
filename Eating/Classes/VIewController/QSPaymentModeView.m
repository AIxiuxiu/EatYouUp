//
//  QSPaymentModeView.m
//  Eating
//
//  Created by ysmeng on 14/12/1.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPaymentModeView.h"
#import "QSConfig.h"
#import "QSBlockActionButton.h"

@interface QSPaymentModeView (){
    QSPAYMENTMODE_TYPE _currentType;
}

@end

@implementation QSPaymentModeView

#pragma mark - 弹出支付方式选择窗口
+ (void)showPaymentTypeChoice:(UIView *)target andType:(QSPAYMENTMODE_TYPE)type andCallBack:(void(^)(NSString *typeName,QSPAYMENTMODE_TYPE payType))callBack
{
    QSPaymentModeView *paymentModel = [[QSPaymentModeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, target.frame.size.width, target.frame.size.height) andType:type andCallBack:callBack];
    [target addSubview:paymentModel];
    
    [UIView animateWithDuration:0.3 animations:^{
        paymentModel.alpha = 1.0f;
    }];
}

#pragma mark - 初始化/UI搭建
- (instancetype)initWithFrame:(CGRect)frame andType:(QSPAYMENTMODE_TYPE)type andCallBack:(void(^)(NSString *typeName,QSPAYMENTMODE_TYPE payType))callBack
{
    if (self = [super initWithFrame:frame]) {
        //初始为透明
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
        
        //初始为隐藏状态
        self.alpha = 0.0f;
        
        //保存当前类型
        _currentType = type;
        
        //保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
        //创建UI
        [self createPaymodelUI];
        
        //添加退出事件
        [self addSelfSingleTapGesture];
    }
    
    return self;
}

//创建UI
- (void)createPaymodelUI
{
    //主显示view:60 + 5 * 60 = 360
    UIView *mainShowView = [[UIView alloc] initWithFrame:CGRectMake(40.0f, 90.0f, self.frame.size.width-80.0f, 360.0f)];
    mainShowView.backgroundColor = [UIColor whiteColor];
    mainShowView.layer.cornerRadius = 12.0f;
    [self addPaymentMode:mainShowView];
    [self addSubviewSingleTapGesture:mainShowView];
    [self addSubview:mainShowView];
}

//添加支付方式选择项
- (void)addPaymentMode:(UIView *)view
{
    //标题说明
    UILabel *intruduce = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 20.0f, view.frame.size.width-20.0f, 20.0f)];
    intruduce.textAlignment = NSTextAlignmentCenter;
    intruduce.textColor = kBaseGrayColor;
    intruduce.font = [UIFont systemFontOfSize:14.0f];
    intruduce.text = @"选择支付方式";
    [view addSubview:intruduce];
    
    //分隔线
    UILabel *sepLine = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 50.0f, view.frame.size.width - 20.0f, 0.5f)];
    sepLine.backgroundColor = kBaseLightGrayColor;
    sepLine.alpha = 0.6f;
    [view addSubview:sepLine];
    
    //取得支付方式数据
    NSArray *paymentModeList = [self getPaymentModeTypeList];
    if ([paymentModeList count] > 5) {
        [self addPaymentModeScrollView:view andTypeList:paymentModeList andYPoint:60.0f];
    } else {
        [self createPayentModeSubviews:view andTypeList:paymentModeList andYPoint:60.0f];
    }
}

//如果支付方式比效多，则添加底滚动视图
- (void)addPaymentModeScrollView:(UIView *)view andTypeList:(NSArray *)typeList andYPoint:(CGFloat)ypoint
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, ypoint, view.frame.size.width, view.frame.size.height-ypoint)];
    scrollView.contentSize = CGSizeMake(view.frame.size.width, [typeList count] * 60.0f);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [view addSubview:scrollView];
    [self createPayentModeSubviews:scrollView andTypeList:typeList andYPoint:0.0f];
}

//添加支付方式子视图
- (void)createPayentModeSubviews:(UIView *)view andTypeList:(NSArray *)typeList andYPoint:(CGFloat)ypoint
{
    
    for (int i = 0; i < [typeList count]; i++) {
        //数据
        NSDictionary *tempDict = typeList[i];
        
        //选择框
        UIButton *choiceButton = [UIButton createBlockActionButton:CGRectMake(20.0f, ypoint+15.0f+i*60.0f, 30.0f, 30.0f) andStyle:nil andCallBack:^(UIButton *button) {
            if (self.callBack) {
                self.callBack([tempDict valueForKey:@"typeImageName"],[[tempDict valueForKey:@"type"]  intValue]);
            }
            
            //移除
            [self parmentModeHidden];
        }];
        [choiceButton setImage:[UIImage imageNamed:@"takeout_fill_checkbox_selected"] forState:UIControlStateSelected];
        [choiceButton setImage:[UIImage imageNamed:@"takeout_fill_checkbox_selected"] forState:UIControlStateHighlighted];
        [choiceButton setImage:[UIImage imageNamed:@"takeout_fill_checkbox"] forState:UIControlStateNormal];
        [view addSubview:choiceButton];
        
        //图片button
        UIButton *imageButton = [UIButton createBlockActionButton:CGRectMake(70.0f, ypoint+15.0f+i*60.0f, 94, 30.0f) andStyle:nil andCallBack:^(UIButton *button) {
            if (self.callBack) {
                self.callBack([tempDict valueForKey:@"typeImageName"],[[tempDict valueForKey:@"type"]  intValue]);
            }
            
            //移除
            [self parmentModeHidden];
        }];
        [imageButton setImage:[UIImage imageNamed:[tempDict valueForKey:@"typeImageName"]] forState:UIControlStateNormal];
        [view addSubview:imageButton];
        
        if (i+1 == _currentType) {
            choiceButton.selected = YES;
            imageButton.selected = YES;
        }
    }
}

#pragma mark - 获取支付方式列表
- (NSArray *)getPaymentModeTypeList
{
    return @[@{@"typeImageName" : @"prepaidcard_order_paymentmode_taobao",@"type" : @"1"}];
}

#pragma mark - 单击非功能区域时，自动移除
- (void)addSelfSingleTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPaymentModeView:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)addSubviewSingleTapGesture:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPaymentModeView:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tap];
}

- (void)hiddenPaymentModeView:(UITapGestureRecognizer *)tap
{
    if (tap.view == self) {
        //回调
        if (self.callBack) {
            self.callBack(nil,DEFAULT_QSPT);
        }
        [self parmentModeHidden];
    }
}

#pragma mark - 移除动画
- (void)parmentModeHidden
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
