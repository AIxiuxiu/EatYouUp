//
//  QSMyDetectiveViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMyDetectiveViewController.h"
#import "QSMyDiaryView.h"
#import "QSMyTaskView.h"
#import "QSMyDiaryNavigationMiddleItemView.h"
#import "QSNormalNavigationBar.h"

#import <objc/runtime.h>

//关联
static char navigationMiddleItemKey;
@interface QSMyDetectiveViewController (){
    NSString *_turnBackInfo;//返回VC的信息
}

@property (nonatomic,strong) QSMyTaskView *myTaskView;
@property (nonatomic,strong) QSMyDiaryView *myDiaryView;

@end

@implementation QSMyDetectiveViewController
//*******************************
//             初始化/UI搭建
//*******************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        _turnBackInfo = @"default";
        
    }
    return self;
}

//重写导航栏
- (void)createNavigationBar
{
    
    [super createNavigationBar];
    
    //创建导航栏中间按钮
    QSMyDiaryNavigationMiddleItemView *middleBar = [[QSMyDiaryNavigationMiddleItemView alloc] initWithFrame:CGRectMake(83.0f, 35.0f, 155.0f, 21.0f)];
    middleBar.callBack = ^(MYDETECTIVE_TOPIC_CALLBACK_TYPE actionType){
        [self navigationMiddleItemAction:actionType];
    };
    
    [self setNavigationBarMiddleView:middleBar];
    
    //关联
    objc_setAssociatedObject(self, &navigationMiddleItemKey, middleBar, OBJC_ASSOCIATION_ASSIGN);
    
    //添加滑动手势
    [self addLeftAndRightGuesture];
}

- (void)createMainShowView
{
    [super createMainShowView];
    
    //创建两个主题view
    self.myTaskView = [[QSMyTaskView alloc] initWithFrame:CGRectMake(0.0f, 90.0f, self.view.frame.size.width, self.view.frame.size.height-90.0f)];
    [self.view addSubview:self.myTaskView];
    [self.view sendSubviewToBack:self.myTaskView];
    
    self.myDiaryView = [[QSMyDiaryView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 100.0f, self.view.frame.size.width, self.view.frame.size.height-100.0f)];
    [self.view addSubview:self.myDiaryView];
    [self.view sendSubviewToBack:self.myDiaryView];
}

#pragma mark - 返回事件
- (void)turnBackPerform
{
    //判断返回标识
    if ([_turnBackInfo isEqualToString:@"default"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //如果是通过参加活动进入我的任务，则返回活动页面
    if ([_turnBackInfo isEqualToString:@"jointActivity"]) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[[self.navigationController.viewControllers count]-3] animated:YES];
    }
}

//*****************************
//              导航栏事件分发
//*****************************
#pragma mark - 导航栏事件分发
- (void)navigationBarAction:(NAVIGATION_BAR_NORMAL_ACTION_TYPE)actionType
{
    
}

//*****************************
//             导航栏中间按钮事件
//*****************************
#pragma mark - 导航栏中间按钮事件
- (void)navigationMiddleItemAction:(MYDETECTIVE_TOPIC_CALLBACK_TYPE)actionType
{
    switch (actionType) {
        case MYTASK_ACTIONTYPE:
            [self showMyTaskView:YES];
            break;
            
        case MYDIARY_ACTIONTYPE:
            [self showMyDiaryView:YES];
            break;
            
        default:
            break;
    }
}

//*****************************
//             任务/日记视图切换
//*****************************
#pragma mark - 任务/日记视图切换
- (void)showMyTaskView:(BOOL)flag
{
    if (flag) {
        [UIView animateWithDuration:0.3 animations:^{
            self.myTaskView.frame = CGRectMake(0.0f, self.myTaskView.frame.origin.y, self.myTaskView.frame.size.width, self.myTaskView.frame.size.height);
        } completion:^(BOOL finished) {
            //完成后加载数据
            [self.myTaskView loadMyTaskData];
        }];
        
        //美食日记隐藏
        [self showMyDiaryView:NO];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.myTaskView.frame = CGRectMake(-DeviceWidth, self.myTaskView.frame.origin.y, self.myTaskView.frame.size.width, self.myTaskView.frame.size.height);
    }];
}

- (void)showMyDiaryView:(BOOL)flag
{
    if (flag) {
        [UIView animateWithDuration:0.3 animations:^{
            self.myDiaryView.frame = CGRectMake(0.0f, self.myDiaryView.frame.origin.y, self.myDiaryView.frame.size.width, self.myDiaryView.frame.size.height);
        } completion:^(BOOL finished) {
            //完成后加载数据
            [self.myDiaryView loadMyDiaryData];
        }];
        
        //我的任务隐藏
        [self showMyTaskView:NO];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.myDiaryView.frame = CGRectMake(DeviceWidth, self.myDiaryView.frame.origin.y, self.myDiaryView.frame.size.width, self.myDiaryView.frame.size.height);
    }];
}

//********************************
//             任务/日记视图手势切换
//********************************
#pragma mark - 任务/日记视图手势切换
- (void)addLeftAndRightGuesture
{
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipRightAction:)];
    [swipRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipRight];
    
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipLeftAction:)];
    [swipLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipLeft];
}

- (void)swipLeftAction:(UISwipeGestureRecognizer *)swip
{
    //判断"美食日记"当前是否显示
    if (self.myDiaryView.frame.origin.x == 0.0f) {
        return;
    }
    
    //显示"美食日记"
    [self showMyDiaryView:YES];
    
    //导航栏按钮状态修改
    [self resetNavigationMiddleItemStatu];
}

- (void)swipRightAction:(UISwipeGestureRecognizer *)swip
{
    //判断"我的任务"当前是否显示
    if (self.myTaskView.frame.origin.x == 0.0f) {
        return;
    }
    
    //显示"我的任务"
    [self showMyTaskView:YES];
    [self resetNavigationMiddleItemStatu];
}

- (void)resetNavigationMiddleItemStatu
{
    QSMyDiaryNavigationMiddleItemView *nav = objc_getAssociatedObject(self, &navigationMiddleItemKey);
    [nav resetTopicButtonSelectedStyle];
}

@end
