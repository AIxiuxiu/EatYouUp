//
//  QSTabbarViewController.h
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSLoginViewController.h"

@interface QSTabbarViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;

@property (strong, nonatomic) UIButton *tabButton1;
@property (strong, nonatomic) UIButton *tabButton2;
@property (strong, nonatomic) UIButton *tabButton3;
@property (strong, nonatomic) UIButton *tabButton4;
@property (strong, nonatomic) UIButton *tabButton5;

- (void)onTabbarButtonAction:(id)sender;

+ (QSTabbarViewController *)sharedTabBarController;

- (void)showMerchantView;

- (void)showMerchantTakeoutView;

- (void)showLoginViewDict:(NSDictionary *)dict Callback:(void(^)(LOGINVIEW_STATUS))callback;

- (void)hideTabBar;

- (void)showTabBar;

@end
