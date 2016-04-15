//
//  QSUseNoticeViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSUseNoticeViewController.h"
#import "QSAPIModel+CouponDetail.h"
#import "NSDate+QSDateFormatt.h"

#import <objc/runtime.h>

//关联
static char ValidDateFieldKey;
static char AppointmentFieldKey;
static char MarServiceFieldKey;
@interface QSUseNoticeViewController ()<UITextFieldDelegate>

@property (nonatomic,retain) QSYCouponDetailDataModel *dataModel;//!<使用知须模型

@end

@implementation QSUseNoticeViewController

/**
 *  @author         yangshengmeng, 14-12-12 15:12:39
 *
 *  @brief          通过使用详情信息模型创建使用知悉页面
 *
 *  @param model    使用知须数据模型
 *
 *  @return         返回使用知悉页面
 *
 *  @since          2.0
 */
#pragma mark - 以使用知须数据模型初始化
- (instancetype)initWithDataModel:(QSYCouponDetailDataModel *)model
{
    self = [super init];
    if (self) {
        
        ///保存model
        self.dataModel = model;
        
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
    [self setNavigationBarMiddleTitle:@"使用须知"];
}

///重写主显示区域UI搭建
- (void)createMainShowView
{
    [super createMainShowView];
    
    //底view
    UIScrollView *rootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, DeviceWidth, DeviceHeight-64.0f)];
    
    //去除滚动条
    rootView.showsHorizontalScrollIndicator = NO;
    rootView.showsVerticalScrollIndicator = NO;
    
    //透明背景
    rootView.backgroundColor = [UIColor clearColor];
    
    //添加信息显示view
    [self createInfoSubviews:rootView];
    
    //添加到主view上
    [self.view addSubview:rootView];
}

/*
 *  @author yangshengmeng, 14-12-09 14:12:46
 *
 *  @brief  在scrollview上添加信息显示的子view，方便超出高度时滚动适配
 *
 *  @param scrollView 所有信息显示的父view
 *
 *  @since eating2.0-ysm001
 */
- (void)createInfoSubviews:(UIScrollView *)scrollView
{
    ///记录纵向的y轴坐标，最后判断是否需要滚动适配
    CGFloat ypoint = 30.0f;
    
    ///有效期
    UITextField *validDateField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, 44.0f)];
    validDateField.borderStyle = UITextBorderStyleRoundedRect;
    validDateField.text = [NSString stringWithFormat:@"%@至%@",[NSDate formatIntegerIntervalToDateString:self.dataModel.startTime],[NSDate formatIntegerIntervalToDateString:self.dataModel.lastTime]];
    validDateField.textAlignment = NSTextAlignmentRight;
    validDateField.textColor = kBaseGrayColor;
    validDateField.font = [UIFont systemFontOfSize:14.0f];
    validDateField.delegate = self;
    validDateField.userInteractionEnabled = NO;
    [scrollView addSubview:validDateField];
    objc_setAssociatedObject(self, &ValidDateFieldKey, validDateField, OBJC_ASSOCIATION_ASSIGN);
    ypoint += 49.0f;
    
    ///有效期信息栏右侧提示说明
    UILabel *tipsValidDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 55.0f, 44.0f)];
    tipsValidDateLabel.text = @"有效期";
    tipsValidDateLabel.textColor = kBaseGrayColor;
    tipsValidDateLabel.font = [UIFont systemFontOfSize:14.0f];
    tipsValidDateLabel.textAlignment = NSTextAlignmentCenter;
    validDateField.leftViewMode = UITextFieldViewModeAlways;
    validDateField.leftView = tipsValidDateLabel;
    
    ///预约信息
    UITextField *appointmentField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, 44.0f)];
    appointmentField.borderStyle = UITextBorderStyleRoundedRect;
    appointmentField.text = self.dataModel.moreDetailInfoModel.subscribeDes;
    appointmentField.textAlignment = NSTextAlignmentRight;
    appointmentField.textColor = kBaseGrayColor;
    appointmentField.font = [UIFont systemFontOfSize:14.0f];
    appointmentField.delegate = self;
    appointmentField.userInteractionEnabled = NO;
    [scrollView addSubview:appointmentField];
    objc_setAssociatedObject(self, &AppointmentFieldKey, appointmentField, OBJC_ASSOCIATION_ASSIGN);
    ypoint += 49.0f;
    
    ///预约信息信息栏右侧提示说明
    UILabel *tipsAppointmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 65.0f, 44.0f)];
    tipsAppointmentLabel.text = @"预约信息";
    tipsAppointmentLabel.textColor = kBaseGrayColor;
    tipsAppointmentLabel.font = [UIFont systemFontOfSize:14.0f];
    tipsAppointmentLabel.textAlignment = NSTextAlignmentCenter;
    appointmentField.leftViewMode = UITextFieldViewModeAlways;
    appointmentField.leftView = tipsAppointmentLabel;
    
    ///商家服务
    UITextField *marServiceField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, 44.0f)];
    marServiceField.borderStyle = UITextBorderStyleRoundedRect;
    marServiceField.text = [self formatMarchantService:self.dataModel.marchantBaseInfoModel.marFreeServicesList];
    marServiceField.textAlignment = NSTextAlignmentRight;
    marServiceField.textColor = kBaseGrayColor;
    marServiceField.font = [UIFont systemFontOfSize:14.0f];
    marServiceField.delegate = self;
    marServiceField.userInteractionEnabled = NO;
    [scrollView addSubview:marServiceField];
    objc_setAssociatedObject(self, &MarServiceFieldKey, marServiceField, OBJC_ASSOCIATION_ASSIGN);
    ypoint += 49.0f;
    
    ///商家服务信息栏右侧提示说明
    UILabel *tipsMarServiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 65.0f, 44.0f)];
    tipsMarServiceLabel.text = @"商家服务";
    tipsMarServiceLabel.textColor = kBaseGrayColor;
    tipsMarServiceLabel.font = [UIFont systemFontOfSize:14.0f];
    tipsMarServiceLabel.textAlignment = NSTextAlignmentCenter;
    marServiceField.leftViewMode = UITextFieldViewModeAlways;
    marServiceField.leftView = tipsMarServiceLabel;
    
    ///规则提醒
    NSString *ruleInstructmentString = self.dataModel.moreDetailInfoModel.useNotice;
    UILabel *ruleInstructmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, [ruleInstructmentString calculateStringHeightByFixedWidth:scrollView.frame.size.width-20.0f andFontSize:14.0f])];
    [ruleInstructmentLabel roundCornerRadius:6.0f];
    ruleInstructmentLabel.layer.masksToBounds = YES;
    ruleInstructmentLabel.backgroundColor = [UIColor whiteColor];
    ruleInstructmentLabel.font = [UIFont systemFontOfSize:14.0f];
    ruleInstructmentLabel.textColor = kBaseGrayColor;
    ruleInstructmentLabel.numberOfLines = 0;
    ruleInstructmentLabel.text = ruleInstructmentString;
    [scrollView addSubview:ruleInstructmentLabel];
    ypoint += (ruleInstructmentLabel.frame.size.height + 5.0f);
    
    //温馨提示
    NSString *kindlyReminderString = @"温馨提示\n如需团购发票，请您在消费时向商户咨询。";
    UILabel *kindlyReminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, ypoint, scrollView.frame.size.width-20.0f, [kindlyReminderString calculateStringHeightByFixedWidth:scrollView.frame.size.width-20.0f andFontSize:14.0f])];
    [kindlyReminderLabel roundCornerRadius:6.0f];
    kindlyReminderLabel.layer.masksToBounds = YES;
    kindlyReminderLabel.backgroundColor = [UIColor whiteColor];
    kindlyReminderLabel.font = [UIFont systemFontOfSize:14.0f];
    kindlyReminderLabel.textColor = kBaseGrayColor;
    kindlyReminderLabel.numberOfLines = 0;
    kindlyReminderLabel.text = kindlyReminderString;
    [scrollView addSubview:kindlyReminderLabel];
    ypoint += (kindlyReminderLabel.frame.size.height + 5.0f);
    
    //判断当前布局的ypoint，是否需要开启滚动
    if (ypoint > scrollView.frame.size.height) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, ypoint+10.0f);
    }
    
}

/**
 *  @author         yangshengmeng, 14-12-12 16:12:55
 *
 *  @brief          格式化商家服务信息
 *
 *  @param array    服务端回传的商家服务代码
 *
 *  @since          2.0
 */
- (NSString *)formatMarchantService:(NSArray *)array
{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (NSString *obj in array) {
        
        int code = [obj intValue];
        
        if (code == 1) {
            
            [result appendString:@"免费WiFi | "];
            
        }
        
        if (code == 2) {
            [result appendString:@"免茶位费 | "];
        }
        
        if (code == 3) {
            [result appendString:@"免外卖费 | "];
        }
        
    }
    
    [result replaceCharactersInRange:NSMakeRange(result.length-3, 3) withString:@""];
    
    return result;
}

@end
