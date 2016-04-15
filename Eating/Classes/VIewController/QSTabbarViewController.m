//
//  QSTabbarViewController.m
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSTabbarViewController.h"
#import "QSConfig.h"
#import "QSIndexViewController.h"
#import "QSRecommendViewController.h"
#import "QSMerchantViewController.h"
#import "QSUserCenterViewController.h"
#import "QSSearchViewController.h"
#import "GuideViewController.h"
#import "QSBottomTitleBlockButton.h"

#import <objc/runtime.h>

static char guidkey;

@interface QSTabbarViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) QSIndexViewController *indexViewController;
@property (nonatomic, strong) QSRecommendViewController *recommendViewController;
@property (nonatomic, strong) QSMerchantViewController *merchantViewcController;
@property (nonatomic, strong) QSUserCenterViewController *userCenterViewController;
@property (nonatomic, strong) QSSearchViewController *searchViewController;

@property (nonatomic, strong) NSMutableArray *navViewControllers;
@property (nonatomic, strong) QSViewController *currentViewController;
@property (nonatomic, strong) QSLoginViewController *loginViewController;


@end

@implementation QSTabbarViewController

+ (QSTabbarViewController *)sharedTabBarController {
    static dispatch_once_t pred = 0;
    static QSTabbarViewController *shared_tabBarController = nil;
    
    dispatch_once(&pred, ^{
        shared_tabBarController = [[self alloc] init];
    });
    
    return shared_tabBarController;
}

- (QSIndexViewController *)indexViewController
{
    if (!_indexViewController) {
        _indexViewController = [[QSIndexViewController alloc] init];
    }
    return _indexViewController;
}

- (QSRecommendViewController *)recommendViewController
{
    if (!_recommendViewController) {
        _recommendViewController = [[QSRecommendViewController alloc] init];
    }
    return _recommendViewController;
}

- (QSMerchantViewController *)merchantViewcController
{
    if (!_merchantViewcController) {
        _merchantViewcController = [[QSMerchantViewController alloc] init];
    }
    return _merchantViewcController;
}


- (QSUserCenterViewController *)userCenterViewController
{
    if (!_userCenterViewController) {
        _userCenterViewController = [[QSUserCenterViewController alloc] init];
    }
    return _userCenterViewController;
}

- (QSSearchViewController *)searchViewController
{
    if (!_searchViewController) {
        _searchViewController = [[QSSearchViewController alloc] init];
    }
    return _searchViewController;
}

- (QSLoginViewController *)loginViewController
{
    _loginViewController = [[QSLoginViewController alloc] init];
    return _loginViewController;
}

- (NSMutableArray *)navViewControllers
{
    if (!_navViewControllers) {
        _navViewControllers = [[NSMutableArray alloc] init];
    }
    return _navViewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupUI];
    
    [self setupViewControllers];
    
    [self onTabbarButtonAction:self.tabButton1];
    
    [self setupNotification];
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"Splash"]) {
        
        GuideViewController *viewVC = [[GuideViewController alloc] init];
        viewVC.delegate = self;
        [self.view addSubview:viewVC.view];
        objc_setAssociatedObject(self, &guidkey, viewVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    } else {
        
        
        
    }
}

- (void)introDidFinish
{
    
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"Splash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    GuideViewController *viewVC = objc_getAssociatedObject(self, &guidkey);
    [viewVC.view removeFromSuperview];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)setupViewControllers
{
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:self.indexViewController];
    nav1.delegate = self;
    [nav1 setNavigationBarHidden:YES];
    
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:self.recommendViewController];
    nav2.delegate = self;
    [nav2 setNavigationBarHidden:YES];
    
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:self.merchantViewcController];
    nav3.delegate = self;
    [nav3 setNavigationBarHidden:YES];
    
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:self.userCenterViewController];
    nav4.delegate = self;
    [nav4 setNavigationBarHidden:YES];
    
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:self.searchViewController];
    nav5.delegate = self;
    [nav5 setNavigationBarHidden:YES];
    
    
    [self.navViewControllers addObject:nav1];
    [self.navViewControllers addObject:nav2];
    [self.navViewControllers addObject:nav3];
    [self.navViewControllers addObject:nav4];
    [self.navViewControllers addObject:nav5];
}

- (void)setupUI
{
    ///计算间隙
    CGFloat gap = (DeviceWidth - 5.0f * 30.0f) / 6.0f;
    CGFloat xpoint = gap;
    
    self.tabButton1 = [UIButton createBottomTitleButton:CGRectMake(xpoint, 3.0f, 30.0f, 45.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        
        
    }];
    xpoint += (30.0f + gap);
    [self.tabBarView addSubview:self.tabButton1];
    
    self.tabButton2 = [UIButton createBottomTitleButton:CGRectMake(xpoint, 3.0f, 30.0f, 45.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        
        
    }];
    xpoint += (30.0f + gap);
    [self.tabBarView addSubview:self.tabButton2];
    
    self.tabButton3 = [UIButton createBottomTitleButton:CGRectMake(xpoint, 3.0f, 30.0f, 45.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        
        
    }];
    xpoint += (30.0f + gap);
    [self.tabBarView addSubview:self.tabButton3];
    
    self.tabButton4 = [UIButton createBottomTitleButton:CGRectMake(xpoint, 3.0f, 30.0f, 45.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        
        
    }];
    xpoint += (30.0f + gap);
    [self.tabBarView addSubview:self.tabButton4];
    
    self.tabButton5 = [UIButton createBottomTitleButton:CGRectMake(xpoint, 3.0f, 30.0f, 45.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        
        
    }];
    xpoint += (30.0f + gap);
    [self.tabBarView addSubview:self.tabButton5];
    
    ///设置标题
    [self.tabButton1 setTitle:@"首页" forState:UIControlStateNormal];
    self.tabButton1.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.tabButton1.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.tabButton2 setTitle:@"精选" forState:UIControlStateNormal];
    self.tabButton2.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.tabButton2.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.tabButton3 setTitle:@"商家" forState:UIControlStateNormal];
    self.tabButton3.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.tabButton3.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.tabButton4 setTitle:@"我的" forState:UIControlStateNormal];
    self.tabButton4.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.tabButton4.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.tabButton5 setTitle:@"搜索" forState:UIControlStateNormal];
    self.tabButton5.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.tabButton5.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    ///设置标题的普通状态和高亮状态颜色
    [self.tabButton1 setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    [self.tabButton1 setTitleColor:kBaseOrangeColor forState:UIControlStateSelected];
    [self.tabButton2 setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    [self.tabButton2 setTitleColor:kBaseOrangeColor forState:UIControlStateSelected];
    [self.tabButton3 setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    [self.tabButton3 setTitleColor:kBaseOrangeColor forState:UIControlStateSelected];
    [self.tabButton4 setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    [self.tabButton4 setTitleColor:kBaseOrangeColor forState:UIControlStateSelected];
    [self.tabButton5 setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    [self.tabButton5 setTitleColor:kBaseOrangeColor forState:UIControlStateSelected];
    
    ///设置图片
    [self.tabButton1 setImage:IMAGENAME(@"tab_icon1") forState:UIControlStateNormal];
    [self.tabButton2 setImage:IMAGENAME(@"tab_icon2") forState:UIControlStateNormal];
    [self.tabButton3 setImage:IMAGENAME(@"tab_icon3") forState:UIControlStateNormal];
    [self.tabButton4 setImage:IMAGENAME(@"tab_icon4") forState:UIControlStateNormal];
    [self.tabButton5 setImage:IMAGENAME(@"tab_icon5") forState:UIControlStateNormal];
    
    [self.tabButton1 setImage:IMAGENAME(@"tab_icon1_click") forState:UIControlStateSelected];
    [self.tabButton2 setImage:IMAGENAME(@"tab_icon2_click") forState:UIControlStateSelected];
    [self.tabButton3 setImage:IMAGENAME(@"tab_icon3_click") forState:UIControlStateSelected];
    [self.tabButton4 setImage:IMAGENAME(@"tab_icon4_click") forState:UIControlStateSelected];
    [self.tabButton5 setImage:IMAGENAME(@"tab_icon5_click") forState:UIControlStateSelected];
    
    ///添加按钮事件
    [self.tabButton1 addTarget:self action:@selector(onTabbarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabButton2 addTarget:self action:@selector(onTabbarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabButton3 addTarget:self action:@selector(onTabbarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabButton4 addTarget:self action:@selector(onTabbarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabButton5 addTarget:self action:@selector(onTabbarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tabButton1.tag = 50;
    self.tabButton2.tag = 51;
    self.tabButton3.tag = 52;
    self.tabButton4.tag = 53;
    self.tabButton5.tag = 54;
}

- (void)showLoginView:(NSString *)username and:(NSString *)password
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    _loginViewController.username = username ? username : @"";
    _loginViewController.password = password ? password : @"";

    if (!iOS7) {
        CGPoint center;
        center.x = DeviceMidX;
        center.y = [UIScreen mainScreen].bounds.size.height/2 - 20;
        nav.view.center = center;
    }
    else{
        CGPoint center;
        center.x = DeviceMidX;
        center.y = [UIScreen mainScreen].bounds.size.height/2 + 0;
        nav.view.center = center;
    }
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (void)showLoginViewDict:(NSDictionary *)dict Callback:(void (^)(LOGINVIEW_STATUS))callback
{
    NSString *username = dict[@"username"];
    NSString *password = dict[@"password"];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    _loginViewController.username = username ? username : @"";
    _loginViewController.password = password ? password : @"";
    _loginViewController.loginViewStatusCallback = ^(LOGINVIEW_STATUS status){
        callback(status);
    };
    if (!iOS7) {
        CGPoint center;
        center.x = DeviceMidX;
        center.y = [UIScreen mainScreen].bounds.size.height/2 - 20;
        nav.view.center = center;
    }
    else{
        CGPoint center;
        center.x = DeviceMidX;
        center.y = [UIScreen mainScreen].bounds.size.height/2 + 0;
        nav.view.center = center;
    }
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (void)onTabbarButtonAction:(id)sender
{
    UIButton *button = sender;
    
    self.tabButton1.selected = NO;
    self.tabButton2.selected = NO;
    self.tabButton3.selected = NO;
    self.tabButton4.selected = NO;
    self.tabButton5.selected = NO;
    
    [self.currentViewController.view removeFromSuperview];
    
    if (button.tag - 50 == 0) {
        self.tabButton1.selected = YES;
    }
    else if (button.tag - 50 == 1){
        self.tabButton2.selected = YES;
    }
    else if (button.tag - 50 == 2){
        self.tabButton3.selected = YES;
    }
    else if (button.tag - 50 == 3){
        self.tabButton4.selected = YES;
    }
    else if (button.tag - 50 == 4){
        self.tabButton5.selected = YES;
    }
    
    self.currentViewController = self.navViewControllers[button.tag-50];
    [self.view insertSubview:self.currentViewController.view belowSubview:self.tabBarView];
}

- (void)showMerchantView
{
    self.merchantViewcController.showTakeoutList = NO;
    [self onTabbarButtonAction:self.tabButton3];
}

- (void)showMerchantTakeoutView
{
    self.merchantViewcController.showTakeoutList = YES;
    [self onTabbarButtonAction:self.tabButton3];
}

- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlerNotification:)
                                                 name:kPresentLoginViewNotification
                                               object:nil];
}

- (void)handlerNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kPresentLoginViewNotification]) {
        NSDictionary *dict = notification.object;
        NSString *username = dict[@"username"];
        NSString *password = dict[@"password"];
        [self showLoginView:username and:password];
    }
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{;
    if ([viewController isKindOfClass:[QSIndexViewController class]] ||
        [viewController isKindOfClass:[QSRecommendViewController class]] ||
        (([viewController isKindOfClass:[QSMerchantViewController class]]) && !((QSMerchantViewController *)viewController).showBackButton) ||
        [viewController isKindOfClass:[QSUserCenterViewController class]] ||
        [viewController isKindOfClass:[QSSearchViewController class]])
    {
        [self showTabBar];
        
    }
    else
    {
        [self hideTabBar];
    }
}

- (void)hideTabBar
{
    [UIView animateWithDuration:0.3f animations:^(void) {
        CGPoint center;
        center.x = DeviceMidX;
        center.y = [[UIScreen mainScreen]bounds].size.height + kTabBarHeight;
        if (!iOS7) {
            center.y += 20;
        }
        _tabBarView.center = center;
    }];
}

- (void)showTabBar
{
    [UIView animateWithDuration:0.3f animations:^(void) {
        CGPoint center;
        center.x = DeviceMidX;
        center.y = [[UIScreen mainScreen]bounds].size.height - kTabBarHeight/2;
        if (!iOS7) {
            center.y -= 20;
        }
        _tabBarView.center = center;
    }];
}

@end
