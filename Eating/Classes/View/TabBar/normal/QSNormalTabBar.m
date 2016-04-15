//
//  QSNormalTabBar.m
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSNormalTabBar.h"
#import "QSBlockActionButton.h"

#import <objc/runtime.h>

///关联
static char RightButtonKey;//!<右侧按钮
static char MiddleButtonKey;//!<中间按钮
static char LeftButtonKey;//!<左侧按钮

@interface QSNormalTabBar ()

@property (nonatomic,copy) void(^normakTabbarCallBack)(TABBAR_NORMAL_ACTION_TYPE actionType,BOOL flag);//!<底部导航栏回调

@end

@implementation QSNormalTabBar

//*******************************
//             初始化/UI搭建
//*******************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        ///开启用户交互
        self.userInteractionEnabled = YES;
        
        //加载默认图片
        self.image = [UIImage imageNamed:@"foodgroud_tabbar_default_bg"];
        
    }
    
    return self;
}

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
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(TABBAR_NORMAL_ACTION_TYPE actionType,BOOL flag))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///开启用户交互
        self.userInteractionEnabled = YES;
        
        ///保存回调
        if (callBack) {
            self.normakTabbarCallBack = callBack;
        }
        
        //加载默认图片
        self.image = [UIImage imageNamed:@"foodgroud_tabbar_default_bg"];
        
    }
    
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame andTabBarType:(TABBAR_NORMAL_TYPE)tabBarType andCallBack:(void(^)(TABBAR_NORMAL_ACTION_TYPE actionType,BOOL flag))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        ///开启用户交互
        self.userInteractionEnabled = YES;
        
        //加载默认图片
        self.image = [UIImage imageNamed:@"foodgroud_tabbar_default_bg"];
        
        //通过类型创建不同的UI
        [self createUIWithType:tabBarType];
        
    }
    
    return self;
}

//根据类型创建不同的channelBar
- (void)createChannelBarWithType:(TABBAR_NORMAL_TYPE)tabBarType
{
    //通过类型创建不同的UI
    [self createUIWithType:tabBarType];
}

//UI类型过滤
- (void)createUIWithType:(TABBAR_NORMAL_TYPE)tabBarType
{
    switch (tabBarType) {
        case FOODGROUD_TNT:
            [self createFoodGroudUI];
            break;
            
        case FOODDETECTIVE_TNT:
            [self createFoodDetectiveUI];
            break;
            
        default:
            break;
    }
}

//创建搭吃团UI
- (void)createFoodGroudUI
{
    //中间：加团按钮
    UIButton *middleButton = [UIButton createBlockActionButton:CGRectMake(self.frame.size.width/2.0f - 30.0f, -20.0f, 60.0f, 60.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        if (self.normakTabbarCallBack) {
            self.normakTabbarCallBack(MIDDLE_BUTTON_TNAT,YES);
        }
        
    }];
    [middleButton setImage:[UIImage imageNamed:@"foodgroud_jointeam_normal"] forState:UIControlStateNormal];
    [middleButton setImage:[UIImage imageNamed:@"foodgroud_jointeam_highlighted"] forState:UIControlStateHighlighted];
    [self addSubview:middleButton];
    objc_setAssociatedObject(self, &MiddleButtonKey, middleButton, OBJC_ASSOCIATION_ASSIGN);
    
    //左侧：编辑或者新增团按钮
    UIButton *addButton = [UIButton createBlockActionButton:CGRectMake(10.0f, 24.5f, 24.0f, 25.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        if (self.normakTabbarCallBack) {
            self.normakTabbarCallBack(LEFT_BUTTON_TNAT,YES);
        }
        
    }];
    [addButton setImage:[UIImage imageNamed:@"foodgroud_addteam_normal"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"foodgroud_addteam_highlighted"] forState:UIControlStateHighlighted];
    [self addSubview:addButton];
    objc_setAssociatedObject(self, &LeftButtonKey, addButton, OBJC_ASSOCIATION_ASSIGN);
    
    //分享按钮
    UIButton *editButton = [UIButton createBlockActionButton:CGRectMake(self.frame.size.width-35.0f, 24.5f, 20.0f, 25.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        if (self.normakTabbarCallBack) {
            self.normakTabbarCallBack(RIGHT_BUTTON_TNAT,YES);
        }
        
    }];
    [editButton setImage:[UIImage imageNamed:@"foodgroud_tabbar_share"] forState:UIControlStateNormal];
    [self addSubview:editButton];
    objc_setAssociatedObject(self, &RightButtonKey, editButton, OBJC_ASSOCIATION_ASSIGN);
}

//创建美食侦探团UI
- (void)createFoodDetectiveUI
{
    //编辑按钮
    UIButton *middleButton = [UIButton createBlockActionButton:CGRectMake(self.frame.size.width/2.0f - 30.0f, -20.0f, 60.0f, 60.0f) andStyle:[QSButtonStyleModel createFoodDetectiveEditButtonStyle] andCallBack:^(UIButton *button) {
        if (self.normakTabbarCallBack) {
            self.normakTabbarCallBack(MIDDLE_BUTTON_TNAT,YES);
        }
    }];
    [self addSubview:middleButton];
    
    //添加按钮
    UIButton *addButton = [UIButton createBlockActionButton:CGRectMake(10.0f, 24.5f, 24.0f, 25.0f) andStyle:[QSButtonStyleModel createFoodDetectiveAddButtonStyle] andCallBack:^(UIButton *button) {
        if (self.normakTabbarCallBack) {
            self.normakTabbarCallBack(LEFT_BUTTON_TNAT,YES);
        }
    }];
    [self addSubview:addButton];
    
    //免费按钮
    UIButton *editButton = [UIButton createBlockActionButton:CGRectMake(self.frame.size.width-35.0f, 24.5f, 20.0f, 25.0f) andStyle:[QSButtonStyleModel createFoodDetectiveFreeButtonStyle] andCallBack:^(UIButton *button) {
        if (self.normakTabbarCallBack) {
            self.normakTabbarCallBack(RIGHT_BUTTON_TNAT,YES);
        }
    }];
    [self addSubview:editButton];
}

///显示编辑按钮
- (void)showEditButton:(BOOL)flag
{

    UIImage *normalImage = flag ? [UIImage imageNamed:@"foodgroud_editteam_normal"] : [UIImage imageNamed:@"foodgroud_addteam_normal"];
    UIImage *highImage = flag ? [UIImage imageNamed:@"foodgroud_editteam_highlighted"] : [UIImage imageNamed:@"foodgroud_addteam_highlighted"];
    
    UIButton *button = objc_getAssociatedObject(self, &LeftButtonKey);
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    
}

///显示满员按钮
- (void)resetMiddleButtonStyle:(TABBAR_MIDDLEBUTTON_STYLE)statusStyle
{
    
    switch (statusStyle) {
            ///非团长，未满人，可参团
        case UNFULL_TEAM_UNLEADER_TMS:
            
            [self resetMiddleButtonImage:@"foodgroud_jointeam_normal" andHighlightedImage:@"foodgroud_jointeam_highlighted"];
            
            break;
            
            ///非团长，已满人
        case FULL_TEAM_UNLEADER_TMS:
            
            [self resetMiddleButtonImage:@"foodgroud_team_full" andHighlightedImage:@"foodgroud_team_full_hightlighted"];
            
            break;
            
            ///非团长，已经参团
        case JOINED_TEAM_UNLEADER_TMS:
            
            [self resetMiddleButtonImage:@"foodgroud_exitteam_normal" andHighlightedImage:@"foodgroud_exitteam_highlighted"];
            
            break;
            
            ///团长，未成团
        case UNCOMMIT_LEADER_TEAM_TMS:
            
            [self resetMiddleButtonImage:@"foodgroud_team_full" andHighlightedImage:@"foodgroud_team_full_hightlighted"];
            
            break;
            
            ///团长，已成团
        case COMMIT_LEADER_TEAM_TMS:
            
            [self resetMiddleButtonImage:@"foodgroud_detail_team_commited" andHighlightedImage:@"foodgroud_detail_team_commited_high"];
            
            break;
            
            ///团长，已取消
        case CANCEL_LEADER_TEAM_TMS:
            
            [self resetMiddleButtonImage:@"foodgroud_team_cancel_normal" andHighlightedImage:@"foodgroud_team_cancel_highlighted"];
            
            break;
            
        default:
            
            [self resetMiddleButtonImage:@"foodgroud_jointeam_normal" andHighlightedImage:@"foodgroud_jointeam_highlighted"];
            
            break;
    }

}

- (void)resetMiddleButtonImage:(NSString *)imageName andHighlightedImage:(NSString *)highImageName
{

    UIButton *button = objc_getAssociatedObject(self, &MiddleButtonKey);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];

}

@end
