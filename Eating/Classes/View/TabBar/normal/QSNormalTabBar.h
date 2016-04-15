//
//  QSNormalTabBar.h
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//******************************
//  tabBar类型
//******************************
typedef enum
{
    
    DEFAULT_TNT = 0,
    FOODGROUD_TNT,
    FOODDETECTIVE_TNT
    
}TABBAR_NORMAL_TYPE;

//******************************
//  tabBar上的按钮事件类型
//******************************
typedef enum
{
    DEFAULT_TNAT = 0,
    
    //左中右按钮
    MIDDLE_BUTTON_TNAT,
    LEFT_BUTTON_TNAT,
    RIGHT_BUTTON_TNAT
    
}TABBAR_NORMAL_ACTION_TYPE;

///中间按钮的状态
typedef enum
{
    
    DEFAULT_TMS = 0,//!<默认状态
    
    ///非团长时的相关状态
    UNFULL_TEAM_UNLEADER_TMS,//!<非团长，可参团状态
    FULL_TEAM_UNLEADER_TMS,//!<非团长，已经满人，不可以参团的状态
    JOINED_TEAM_UNLEADER_TMS,//!<非团长，当前用户已经参团的状态
    
    ///团长时的相关状态
    UNCOMMIT_LEADER_TEAM_TMS,//!<团长，当前未成团
    COMMIT_LEADER_TEAM_TMS,//!<团长，当前已成团
    CANCEL_LEADER_TEAM_TMS//!<团长，当前团已取消
    
}TABBAR_MIDDLEBUTTON_STYLE;

@interface QSNormalTabBar : UIImageView

/**
 *  @author         yangshengmeng, 14-12-27 09:12:50
 *
 *  @brief          根据回调创建普通底部导航栏
 *
 *  @param frame    在父视图中的大小和位置
 *  @param callBack 回调
 *
 *  @return         返回当前的导航栏
 *
 *  @since          2.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(TABBAR_NORMAL_ACTION_TYPE actionType,BOOL flag))callBack;

//******************************
//  根据类型创建不同的tabBar
//******************************
- (instancetype)initWithFrame:(CGRect)frame andTabBarType:(TABBAR_NORMAL_TYPE)tabBarType andCallBack:(void(^)(TABBAR_NORMAL_ACTION_TYPE actionType,BOOL flag))callBack;

//******************************
//  创建channelBar
//******************************
- (void)createChannelBarWithType:(TABBAR_NORMAL_TYPE)tabBarType;

///显示编辑按钮
- (void)showEditButton:(BOOL)flag;

///显示满员按钮
- (void)resetMiddleButtonStyle:(TABBAR_MIDDLEBUTTON_STYLE)statusStyle;

@end
