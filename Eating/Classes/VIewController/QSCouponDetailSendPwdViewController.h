//
//  QSCouponDetailSendPwdViewController.h
//  Eating
//
//  Created by ysmeng on 15/1/7.
//  Copyright (c) 2015年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSCouponDetailSendPwdViewController : UIViewController

/**
 *  @author         yangshengmeng, 15-01-07 15:01:14
 *
 *  @brief          显示发送消息窗口
 *
 *  @param phone    手机号码
 *  @param msg      消息
 *
 *  @return         返回消息窗口指针
 *
 *  @since          2.0
 */
+ (instancetype)showSendMessageWithPhone:(NSString *)phone andMessage:(NSString *)msg;

/**
 *  @author         yangshengmeng, 15-01-07 15:01:32
 *
 *  @brief          根据手机号码初始化发送密码窗口
 *
 *  @param phone    手机号码
 *
 *  @return         返回发送密码窗口
 *
 *  @since          2.0
 */
- (instancetype)initWithPhoneNumber:(NSString *)phone andMessage:(NSString *)msg;

@end
