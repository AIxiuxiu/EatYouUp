//
//  QSConfig.h
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#ifndef eating_QSConfig_h
#define eating_QSConfig_h

//Common
#define IMAGENAME(x) [UIImage imageNamed:x]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]<7) ? NO:YES

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define DeviceHeight [[UIScreen mainScreen] bounds].size.height
#define DeviceWidth ([[UIScreen mainScreen] bounds].size.width)
#define DeviceMidX [[UIScreen mainScreen] bounds].size.width/2
#define DeviceMidY [[UIScreen mainScreen] bounds].size.height/2

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SELF(x)      x

//旋转
#define degreeTOradians(x) (M_PI * (x)/180

#define kTabBarHeight 50


#define kBaseOrangeColor        HEXCOLOR(0xF95D4D)
#define kBaseGrayColor          HEXCOLOR(0x888888)
#define kBaseLightGrayColor     HEXCOLOR(0xB6B6B6)
#define kBaseGreenColor         HEXCOLOR(0x2ACEC7)
#define kBaseBlueColor          HEXCOLOR(0x3FABF0)
#define kBaseHighlightedGrayBgColor HEXCOLOR(0xE8DFDB)//232 223 219

#define kBaseBackgroundColor HEXCOLOR(0xF6F0EB)

#define kButtonDefaultCornerRadius 6

//通知
#define kPresentLoginViewNotification               @"kPresentLoginViewNotification"

#define kUserDidLoginNotification                   @"kUserDidLoginNotification"
#define kUserDidLogoutNotification                  @"kUserDidLogoutNotification"
#define kUserDidUpdateLocationNotification          @"kUserDidUpdateLocationNotification"

//导航栏基本属性宏定义
#define fNavigationBarMiddleTitleFont [UIFont boldSystemFontOfSize:22.0f]
#define fNavigationBarMiddleTitleLabelFrame CGRectMake(83.0f, 35.0f, 155.0f, 21.0f)
#define fNavigationBarRightViewFrame CGRectMake(292.0f, 34.0f, 14.0f, 18.0f)

///左右限隙宏
#define MARGIN_LEFT_RIGHT (DeviceWidth >= 375.0f ? 15.0f : 10.0f)

///默认的总宽
#define DEFAULT_MAX_WIDTH (DeviceWidth - 2.0f * MARGIN_LEFT_RIGHT)

//是否进行登录判断宏开关：定义则进行登录验证，不定义则不验证是否登录
#define __CHECK_ISLOGIN__

//人民币符号
#define kRMBSymbol @"￥"

#endif
