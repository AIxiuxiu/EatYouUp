//
//  QSOrderFormViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSOrderFormViewController.h"
#import "QSTextField.h"
#import "QSPhoneVerification.h"
#import "QSBlockActionButton.h"
#import "QSBlockActionButton.h"
#import "QSCommitOrderViewController.h"
#import "QSAPIModel+CouponDetail.h"
#import "NSDate+QSDateFormatt.h"
#import "QSDatePickerViewController.h"
#import "ASDepthModalViewController.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"
#import "QSAPIClientBase+Login.h"
#import "QSYOrderNormalFormModel.h"
#import "NSDate+QSDateFormatt.h"
#import "NSString+Name.h"

#import <objc/runtime.h>

///是否进行手机验证码验证
//#define __CHECK_VERIFICATION__

//tag
#define TAG_ORDERFORM_INPUTFIELD_ROOT 250

//关联
static char MainRootViewKey;
@interface QSOrderFormViewController ()<UITextFieldDelegate>{
    
    NSString *_phoneVerificationCode;   //手机验证码
    
    BOOL _userISNewCount;               //!<记录当前购买的手机是否是购买时新注册的用户
    
}

@property (nonatomic,retain) QSYCouponDetailDataModel *dataModel;//!<使用知须模型

@end

@implementation QSOrderFormViewController

/**
 *  @author yangshengmeng, 14-12-12 16:12:43
 *
 *  @brief  根据优惠券的数据模型生成订单页面
 *
 *  @param  model 优惠券模型
 *
 *  @return 返回订单页面
 *
 *  @since  2.0
 */
#pragma mark - 根据优惠券的数据模型生成订单页面
- (instancetype)initWithOrderFormModel:(QSYCouponDetailDataModel *)model
{
    if (self = [super init]) {
        
        ///保存数据模型
        self.dataModel = model;
        
        ///初始化用户状态
        _userISNewCount = NO;
        
    }
    
    return self;
}

//******************************
//             UI搭建
//******************************
#pragma mark - UI搭建
- (void)createMainShowView
{
    //父类方法
    [super createMainShowView];
    [self setNavigationBarMiddleTitle:@"提交订单"];
    
    //底部scrollview
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, DeviceWidth, DeviceHeight-64.0f)];
    
    //背景颜色
    scrollView.backgroundColor = [UIColor clearColor];
    
    //取消滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    //添加输入控件
    [self createInputSubviews:scrollView];
    
    //添加回收键盘事件
    [self addSingleTapAction:scrollView];
    
    [self.view addSubview:scrollView];
    
    //关联
    objc_setAssociatedObject(self, &MainRootViewKey, scrollView, OBJC_ASSOCIATION_ASSIGN);
}

//添加输入控件
- (void)createInputSubviews:(UIScrollView *)scrollView
{
    CGFloat ypoint = 36.0f;
    
    int i = 0;
    for (i = 0; i < 4; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, 44.0f)];
        
        //圆角模式
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        //代理
        textField.delegate = self;
        
        //重置ypoint
        ypoint += 44.0f + 5.0f;
        
        //记录tag
        textField.tag = TAG_ORDERFORM_INPUTFIELD_ROOT + i;
        
        //如果不是第一个输入框，输入内容左侧对齐
        if (i != 0) {
            textField.textAlignment = NSTextAlignmentRight;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        if (i == 0) {
            
            textField.text = [NSString stringWithFormat:@"%@%@(￥%.2f)",self.dataModel.marchantBaseInfoModel.marName,@"储值卡",[self.dataModel.prepaidCardValuePrice floatValue]];
            textField.textColor = kBaseGrayColor;
            
        }
        
        //单价
        if (i == 1) {
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 50.0f, 30.0f)];
            priceLabel.text = @"单价：";
            priceLabel.font = [UIFont systemFontOfSize:14.0f];
            priceLabel.textColor = kBaseLightGrayColor;
            textField.leftView = priceLabel;
            priceLabel.textAlignment = NSTextAlignmentRight;
            textField.leftViewMode = UITextFieldViewModeAlways;
            
            textField.text = [NSString stringWithFormat:@"￥%.2f",[self.dataModel.prepaidCardBuyPrice floatValue]];
            textField.textColor = kBaseGrayColor;
            textField.userInteractionEnabled = NO;
        }
        
        //数量
        if (i == 2) {
            UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 50.0f, 30.0f)];
            count.text = @"数量：";
            count.font = [UIFont systemFontOfSize:14.0f];
            count.textColor = kBaseLightGrayColor;
            textField.leftView = count;
            count.textAlignment = NSTextAlignmentRight;
            textField.leftViewMode = UITextFieldViewModeAlways;
            
            //右侧数字提示
#if 1
            textField.rightViewMode = UITextFieldViewModeAlways;
            UILabel *countRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
            [countRightLabel roundCornerRadius:15.0f];
            countRightLabel.layer.masksToBounds = YES;
            countRightLabel.text = @"1";
            countRightLabel.font = [UIFont systemFontOfSize:14.0f];
            countRightLabel.textColor = kBaseOrangeColor;
            countRightLabel.backgroundColor = kBaseLightGrayColor;
            countRightLabel.textAlignment = NSTextAlignmentCenter;
            textField.rightView = countRightLabel;
#endif
        }
        
        //数量
        if (i == 3) {
            UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 50.0f, 30.0f)];
            count.text = @"总价：";
            count.font = [UIFont systemFontOfSize:14.0f];
            count.textColor = kBaseLightGrayColor;
            count.textAlignment = NSTextAlignmentRight;
            textField.leftView = count;
            textField.leftViewMode = UITextFieldViewModeAlways;
            
            //显示总价
            textField.text = [NSString stringWithFormat:@"￥%.2f",[self.dataModel.prepaidCardBuyPrice floatValue]];
            textField.textColor = kBaseOrangeColor;
            textField.userInteractionEnabled = NO;
        }
        
        [scrollView addSubview:textField];
    }
    
    //判断是否登录，并创建不同的UI
    [self createConfirmBuyUI:scrollView andYPoint:ypoint+25.0f andTagRoot:i];
    
    //添加键盘回收时的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiddenAction:) name:UIKeyboardWillHideNotification object:nil];
}

//添加购买验证信息的UI
- (void)createConfirmBuyUI:(UIScrollView *)scrollView andYPoint:(CGFloat)ypoint andTagRoot:(int)tagRoot
{
    //底线
    UILabel *lineLabe = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, ypoint+7.0f, scrollView.frame.size.width-20.0f, 1.0f)];
    lineLabe.backgroundColor = kBaseLightGrayColor;
    [scrollView addSubview:lineLabe];
    
    //提示信息
    NSString *tipsString;
    
    if (![UserManager sharedManager].userData) {
        //未登录：显示不登录购买
        tipsString = @"免登录直接购买";
    } else {
        //已登录
        tipsString = @"请输入验证码";
    }
    
    //计算长度
    NSDictionary *sizeArribute = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]};
    CGFloat tipsWidth = [tipsString boundingRectWithSize:CGSizeMake(999.0f, 15.0f) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:sizeArribute context:nil].size.width;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake((scrollView.frame.size.width-tipsWidth)/2.0f, ypoint, tipsWidth, 15.0f)];
    tipsLabel.text = tipsString;
    tipsLabel.font = [UIFont systemFontOfSize:14.0f];
    tipsLabel.backgroundColor = kBaseBackgroundColor;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = kBaseLightGrayColor;
    [scrollView addSubview:tipsLabel];
    
    //手机号码输入框
    ypoint += 20.0f;
    UITextField *phoneNum = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, 44.0f)];
    phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    phoneNum.font = [UIFont systemFontOfSize:14.0f];
    phoneNum.borderStyle = UITextBorderStyleRoundedRect;
    phoneNum.placeholder = @"请输入11位手机号码";
    phoneNum.delegate = self;
    phoneNum.tag = tagRoot + TAG_ORDERFORM_INPUTFIELD_ROOT;
    [scrollView addSubview:phoneNum];
    
    ///判断用户是否已登录并获取手机号码
    NSString *phoneString = [UserManager sharedManager].userData.iphone;
    if ([phoneString length] == 11) {
        phoneNum.text = phoneString;
    }
    
    //手机图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 23.0f, 23.0f)];
    imageView.image = [UIImage imageNamed:@"prepaidcard_order_phone"];
    phoneNum.leftViewMode = UITextFieldViewModeAlways;
    phoneNum.leftView = imageView;
    
    //验证码按钮
    QSPhoneVerification *verView = [[QSPhoneVerification alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 44.0f) andPhoneField:phoneNum andCallBack:^(NSString *verCode) {
        
        ///保存验证码
        if (verCode) {
            _phoneVerificationCode = [verCode copy];
        }
        
    }];
    phoneNum.rightViewMode = UITextFieldViewModeAlways;
    phoneNum.rightView = verView;
    
    //验证码输入框
    ypoint += 49.0f;
    UITextField *verNum = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, 44.0f)];
    verNum.keyboardType = UIKeyboardTypeDefault;
    verNum.borderStyle = UITextBorderStyleRoundedRect;
    verNum.placeholder = @"输入验证码";
    verNum.delegate = self;
    verNum.font = [UIFont systemFontOfSize:14.0f];
    verNum.tag = tagRoot + 1 + TAG_ORDERFORM_INPUTFIELD_ROOT;
    [scrollView addSubview:verNum];
    
    //图片:prepaidcard_order_verification
    UIImageView *verCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 23.0f, 23.0f)];
    verCodeImage.image = [UIImage imageNamed:@"prepaidcard_order_verification"];
    verNum.leftViewMode = UITextFieldViewModeAlways;
    verNum.leftView = verCodeImage;
    
    //提交订单
    ypoint += 49.0f;
    UIButton *comment = [UIButton createBlockActionButton:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, 44.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///验证手机号码是否已填写
        if (![self checkPhoneNumber:phoneNum.text ]) {
            
            phoneNum.layer.borderColor = [[UIColor redColor] CGColor];
            phoneNum.layer.borderWidth = 1.0f;
            [phoneNum becomeFirstResponder];
            
            return;
            
        }
        ///消除手机号码非法颜色
        phoneNum.layer.borderWidth = 0.0f;
        [phoneNum resignFirstResponder];
        
#ifdef __CHECK_VERIFICATION__
        ///判断验证码是否准确
        NSString *inputVerCode = verNum.text;
        NSComparisonResult compareResult = [_phoneVerificationCode compare:inputVerCode options:NSCaseInsensitiveSearch];
        
        BOOL verFlag = NO;
        if (([verNum.text length] > 0) && (compareResult == NSOrderedSame)) {
            verFlag = YES;
        }
        
        if (!verFlag) {
            
            ///如果验证码不正确，提醒并要求重新输入验证码
            verNum.layer.borderColor = [[UIColor redColor] CGColor];
            verNum.layer.borderWidth = 1.0f;
            [verNum becomeFirstResponder];
            return;
            
        }
#endif
        
        ///消除错误状态
        verNum.layer.borderWidth = 0.0f;
        
        //回收键盘
        [verNum resignFirstResponder];
        
        ///进入生成订单页面
        [self commitOrderFormAction:scrollView andPhoneNumber:phoneNum.text];
        
    }];
    [comment setTitle:@"提交订单" forState:UIControlStateNormal];
    [comment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comment setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    comment.backgroundColor = kBaseGreenColor;
    comment.layer.cornerRadius = 6.0f;
    [scrollView addSubview:comment];
    
    //判断是否需要设置滚动
    if (scrollView.frame.size.height < ypoint + 64.0f) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, ypoint+54.0f);
    }
}

- (BOOL)checkPhoneNumber:(NSString *)phone
{
    return [NSString isValidateMobile:phone];
}

/**
 *  @author     yangshengmeng, 14-12-12 20:12:20
 *
 *  @brief      返回订单页面的基本信息：订单名、单价、购买数量和总价，对单价和总价进行一次校验
 *
 *  @param view 基本信息所在的父视图
 *
 *  @return     返回校验过的基本信息参数项
 *
 *  @since      2.0
 */
#pragma mark - 封装订单信息
- (QSYOrderNormalFormModel *)getOrderUIBaseInfo:(UIView *)view
{
    ///参数模型
    QSYOrderNormalFormModel *resultModel = [[QSYOrderNormalFormModel alloc] init];
    
    ///订单标题：不需要校验，因为是由应用本身生成
    NSString *orderName = ((UITextField *)[view viewWithTag:TAG_ORDERFORM_INPUTFIELD_ROOT+0]).text;
    resultModel.orderFormTitle = orderName;
    
    ///货物数组
    NSArray *goodList = [self getGoodsListWithField:(UITextField *)[view viewWithTag:TAG_ORDERFORM_INPUTFIELD_ROOT+1] andBuyNumberField:(UITextField *)[view viewWithTag:TAG_ORDERFORM_INPUTFIELD_ROOT+2]];
    if (0 >= [goodList count]) {
        return nil;
    }
    resultModel.goodsList = [goodList mutableCopy];
    
    ///总价
    NSDictionary *goodDict = goodList[0];
    NSString *sumPrice = ((UITextField *)[view viewWithTag:TAG_ORDERFORM_INPUTFIELD_ROOT+3]).text;
    ///校验总价是否等于单价 * 购买总数
    CGFloat sumValue = [[sumPrice substringFromIndex:1] floatValue];
    CGFloat calSum = ([[goodDict valueForKey:@"goods_num"] floatValue] * [[goodDict valueForKey:@"goods_price"] floatValue]);
    if (!(sumValue - calSum < 0.05)) {
        
        ///重新计算总价
        sumPrice = [NSString stringWithFormat:@"%.2f",calSum];
        
    } else {
        
        sumPrice = [sumPrice substringFromIndex:1];
        
    }
    resultModel.totalPrice = sumPrice;
    
    ///添加商户ID
    resultModel.marchantID = self.dataModel.marchantBaseInfoModel.marID;
    
    ///用户ID
    NSString *tempUserId = [UserManager sharedManager].userData.user_id;
    resultModel.userID = [tempUserId intValue] > 0 ? tempUserId : @"-10";
    
    ///用户手机
    NSString *tempPhoneString = ((UITextField *)([view viewWithTag:TAG_ORDERFORM_INPUTFIELD_ROOT+4])).text;
    resultModel.userPhone = tempPhoneString;
    
    ///时间戳
    NSString *tempDate = [NSDate currentDateIntegerString];
    resultModel.buyDate = tempDate;
    
    ///支付方法
    resultModel.payType = @"1";
    
    ///订单类型
    resultModel.orderFormType = @"3";
    
    return resultModel;
}

/**
 *  @author         yangshengmeng, 14-12-12 21:12:10
 *
 *  @brief          返回货物参数字典
 *
 *  @param num      购买货物的数量
 *  @param price    货物单价
 *
 *  @since          2.0
 */
- (NSArray *)getGoodsListWithField:(UITextField *)singlePriceField andBuyNumberField:(UITextField *)numberField
{
    ///货物字典
    NSMutableDictionary *goodDict = [[NSMutableDictionary alloc] init];
    
    ///单价
    NSString *singlePrice = singlePriceField.text;
    [goodDict setObject:[singlePrice substringFromIndex:1] forKey:@"goods_price"];
    
    ///购买总数
    NSString *sumNumber = ((UILabel *)numberField.rightView).text;
    ///如果总数量小于等于0，或者大于可购买的数量，则显示有误，并且返回nil
    if ([sumNumber intValue] <=0) {
        
        ///显示红色边框，表示当前项有错误
        numberField.layer.borderColor = [[UIColor redColor] CGColor];
        numberField.layer.borderWidth = 1.0f;
        [numberField becomeFirstResponder];
        
        return nil;
        
    }
    [goodDict setValue:sumNumber forKey:@"goods_num"];
    
    ///判断是否还有剩余券数
    if ([sumNumber intValue] > ([self.dataModel.leftNumOfCoupon intValue])) {
        
        [self showAlertMessageWithTime:0.5 andMessage:@"当前储值卡已被抢购一空，请重新选购" andCallBack:^(CGFloat showTime) {
            
            /**
             *  @author yangshengmeng, 14-12-20 18:12:39
             *
             *  @brief  当发现当前储值卡已售完后，提示，并跳回到列表页面
             *
             *  @since  2.0
             */
            NSInteger sumVC = [self.navigationController.viewControllers count];
            UIViewController *vc = self.navigationController.viewControllers[sumVC-3];
            [self.navigationController popToViewController:vc animated:YES];
            
        }];
        
        return nil;
        
    }
    
    ///添加货物ID
    [goodDict setObject:self.dataModel.couponID forKey:@"goods_id"];
    
    ///添加货物名称
    [goodDict setObject:self.dataModel.couponName forKey:@"goods_name"];
    
    ///添加实际单价
    [goodDict setObject:[singlePrice substringFromIndex:1] forKey:@"goods_sale_money"];

    return [NSArray arrayWithObjects:goodDict, nil];
}

/**
 *  @author             yangshengmeng, 14-12-12 22:12:11
 *
 *  @brief              提交订单前登录或注册检测
 *
 *  @param scrollView   订单基本信息父视图
 *  @param phoneNumber  当前输入的电话号码
 *
 *  @since              2.0
 */
#pragma mark - 提交订单前登录或注册检测
- (void)commitOrderFormAction:(UIScrollView *)scrollView andPhoneNumber:(NSString *)phoneNumber
{
    
    /**
     *  先判断是否已登录，未登录先行注册，注册成功/用户已存在则提交订单
     */
    if (![self checkLoginStatus:NO]) {
        
        ///进行快速注册并登录：判断本地是否已记录有登录信息，有则弹出登录窗口
        NSString *localPhone = [UserManager sharedManager].userData.iphone;
        if ([localPhone length] == 11) {
            [self checkLoginStatus:YES];
            return;
        }
        
        ///快速注册
        [[QSAPIClientBase sharedClient] userRegister:phoneNumber password:[phoneNumber substringFromIndex:5] success:^(QSAPIModel *response) {
            
            ///标记是否新注册用户
            _userISNewCount = YES;
            if ([response.code isEqualToString:@"ER0000"]) {
                
                ///将用户是新注册的情况，保存在本地
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"buy_user_count_status"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            ///进行订单基本信息封装
            [self packNormalOrderInfo:scrollView];
            
        } fail:^(NSError *error) {

            ///其他原因注册失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络不给力，请稍后再试。" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,error);
            
        }];
        
        return;
        
    } else {
    
        ///已登录，直接进入订单基本信息的封装
        [self packNormalOrderInfo:scrollView];
        
    }

}

/**
 *  @author             yangshengmeng, 14-12-12 22:12:13
 *
 *  @brief              登录或注册完成后，进行订单信息的封装
 *
 *  @param scrollView   订单基本信息父视图
 *
 *  @since              2.0
 */
#pragma mark - 登录或注册完成后，进行订单信息的封装
- (void)packNormalOrderInfo:(UIScrollView *)scrollView
{
    
    /**
     *  封装提交订单信息
     *
     */
    ///获取订单页面上的基本信息
    QSYOrderNormalFormModel *baseInfo = [self getOrderUIBaseInfo:scrollView];
    if (nil == baseInfo) {
        
        return;
    }
    
#if 1
    /**
     *  跳转到订单生成页面
     */
    //跳转到提交支付页面
    QSCommitOrderViewController *commitOrder = [[QSCommitOrderViewController alloc] initWithOrderModel:baseInfo];
    [self.navigationController pushViewController:commitOrder animated:YES];
#endif
}

#pragma mark - 数量输入框输入
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    ///将红色边框取消
    textField.layer.borderWidth = 0.0f;
    
    if (textField.tag == 2 + TAG_ORDERFORM_INPUTFIELD_ROOT) {
        
        ///隐藏数量框
        textField.rightViewMode = UITextFieldViewModeNever;
        
#if 0
        ///弹出数量选择窗口
        QSDatePickerViewController *numberPicker = [[QSDatePickerViewController alloc] init];
        numberPicker.pickerType = kPickerType_Item;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (int i = 1 ; i < 100 ; i++) {
            [temp addObject:[NSString stringWithFormat:@"%d",i]];
        }
        numberPicker.dataSource = temp;
        [ASDepthModalViewController presentView:numberPicker.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
            
        }];
        numberPicker.onCancelButtonHandler = ^{
            
            [ASDepthModalViewController dismiss];
            
        };
        numberPicker.onItemConfirmButtonHandler = ^(NSInteger row, NSString *item){
            
            textField.text = item;
            [ASDepthModalViewController dismiss];
            [textField resignFirstResponder];
            
        };
#endif
        
    }
    return YES;
}

#pragma mark - 数量输入框改变时修改总价
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 2 + TAG_ORDERFORM_INPUTFIELD_ROOT) {
        
        int count = [textField.text intValue];
        textField.rightViewMode = UITextFieldViewModeAlways;
        
        if (count > 1) {
            
            ///判断当前输入数量是否大于可购买总数
            int sumNumber = [self.dataModel.leftNumOfCoupon intValue];
            count = count > sumNumber ? sumNumber : count;
            
            UILabel *countLabel = (UILabel *)textField.rightView;
            countLabel.text = [NSString stringWithFormat:@"%d",count];
            
            //联动修改总价
            UITextField *sumPrice = (UITextField *)[textField.superview viewWithTag:(3 + TAG_ORDERFORM_INPUTFIELD_ROOT)];
            CGFloat singlePrice = [[((UITextField *)[textField.superview viewWithTag:(1 + TAG_ORDERFORM_INPUTFIELD_ROOT)]).text substringFromIndex:1] floatValue];
            sumPrice.text = [NSString stringWithFormat:@"￥%.2f",singlePrice*count];
        }
        
        textField.text = @"";
        
    }
}

#pragma mark - 回收键盘
- (void)addSingleTapAction:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tap];
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap
{
    for (UIView *temp in [tap.view subviews]) {
        if ([temp isKindOfClass:[UITextField class]]) {
            [((UITextField *)temp) resignFirstResponder];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view = objc_getAssociatedObject(self, &MainRootViewKey);
    for (UIView *obj in [view subviews]) {
        if ([obj isKindOfClass:[UITextField class]]) {
            [((UITextField *)obj) resignFirstResponder];
        }
    }
}

#pragma mark - 当键盘挡到输入框时，视图向上滑动
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //193
    if (textField.frame.origin.y >= 193.0f) {
        UIView *view = objc_getAssociatedObject(self, &MainRootViewKey);
        [UIView animateWithDuration:0.25 animations:^{
            view.frame = CGRectMake(view.frame.origin.x, 64.0f-(textField.frame.origin.y - 160.0f), view.frame.size.width, view.frame.size.height);
        }];

    } else {
        UIView *view = objc_getAssociatedObject(self, &MainRootViewKey);
        [UIView animateWithDuration:0.25 animations:^{
            view.frame = CGRectMake(view.frame.origin.x, 64.0f, view.frame.size.width, view.frame.size.height);
        }];
    }
}

#pragma mark - 键盘回收时，视图向下滑
- (void)keyboardWillHiddenAction:(NSNotification *)notification
{
    UIView *view = objc_getAssociatedObject(self, &MainRootViewKey);
    [UIView animateWithDuration:0.25 animations:^{
        view.frame = CGRectMake(view.frame.origin.x, 64.0f, view.frame.size.width, view.frame.size.height);
    }];
}

@end
