//
//  QSNormalNavigationBar.h
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//事件类型
typedef enum
{
    TURN_BACK_NBNAT = 0,
    DETAIL_NBNAT,
    
    //搭食团事件
    LOCATION_NBNAT,
    FOODTOPIC_NBNAT,
    INTERESTED_NBNAT,
    SYSTEMIC_NBNAT,
    
    DEFAULT_NBNAT
}NAVIGATION_BAR_NORMAL_ACTION_TYPE;

//频道栏类型
typedef enum{
    
    DEFAULT_NBNCT = 0,
    FOODGROUD_NBNCT
    
}NAVIGATION_BAR_NORMAL_CHANNEL_TYPE;

//回调block
typedef void (^NBNCALLBCK_BLOCK)(NAVIGATION_BAR_NORMAL_ACTION_TYPE actionType,BOOL flag);

@interface QSNormalNavigationBar : UIImageView

//回调block
@property (nonatomic,copy) NBNCALLBCK_BLOCK callBack;

//*******************************
//           导航栏添加左中右子视图
//*******************************
- (void)addTurnBackButton;

- (void)setLeftView:(UIView *)view;

- (void)setMiddleView:(UIView *)view;

- (void)setMiddleTitle:(NSString *)title;

- (void)setRightView:(UIView *)view;

//创建搭吃团的channelBar
- (void)createFoodGroudChannelBar;

//*******************************
//           添加最部功能按钮
//*******************************
- (void)setChannelBarWithType:(NAVIGATION_BAR_NORMAL_CHANNEL_TYPE)channelType;

@end
