//
//  AppDelegate.h
//  Eating
//
//  Created by System Administrator on 11/11/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,copy) void(^currentControllerCallBack)(NSString *payCode,NSString *payInfo);//当前控制器的回调

/**
 *  @author yangshengmeng, 15-01-14 11:01:46
 *
 *  @brief  返回抢着的消息
 *
 *  @return 返回消息数组
 *
 *  @since  2.0
 */
- (NSArray *)getJPushMessageArray;

/**
 *  @author yangshengmeng, 15-01-14 11:01:30
 *
 *  @brief  返回推送消息的条数
 *
 *  @return 返回推送消息的条数
 *
 *  @since  2.0
 */
- (int)getJPushMessageCount;

/**
 *  @author yangshengmeng, 15-01-14 11:01:13
 *
 *  @brief  更新阅读状态
 *
 *  @since  2.0
 */
- (void)updateReadFlag;

@end

