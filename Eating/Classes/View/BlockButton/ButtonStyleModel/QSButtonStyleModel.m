//
//  QSButtonStyleModel.m
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSButtonStyleModel.h"
#import "QSConfig.h"

#import <UIKit/UIKit.h>

//plist文件相关宏
#define FOODGROUD_PLISTNAME @"QSFoodGroud"
#define PLIST_TYPE @"plist"
#define FOODGROUD_HEADERCHANNEL_ARRAY @"channel"
#define FOODGROUD_HEADERCHANNEL_BUTTON_IMAGE_NORMAL @"normal"
#define FOODGROUD_HEADERCHANNEL_BUTTON_IMAGE_HIGHLIGHTED @"highlighted"

@implementation QSButtonStyleModel

#pragma mark - 导航栏返回按钮风格
+ (QSButtonStyleModel *)createTurnBackButtonStyle
{
    QSButtonStyleModel *styleModel = [[QSButtonStyleModel alloc] init];
    styleModel.imagesNormal = @"back_btn";
    styleModel.imagesHighted = @"back_btn_click";
    return styleModel;
}

#pragma mark - 导航栏定位按钮风格
+ (QSButtonStyleModel *)createLocationButtonStyle
{
    QSButtonStyleModel *styleModel = [[QSButtonStyleModel alloc] init];
    styleModel.imagesNormal = @"foodgroud_nav_local_normal";
    styleModel.imagesHighted = @"foodgroud_nav_local_highlighted";
    return styleModel;
}

#pragma mark - 搭吃团channel按钮风格数据
+ (NSArray *)createFoodGroudButtonStyleArray
{
    //取得数据
    NSString *path = [[NSBundle mainBundle] pathForResource:FOODGROUD_PLISTNAME ofType:PLIST_TYPE];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *channelArray = [dict valueForKey:FOODGROUD_HEADERCHANNEL_ARRAY];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in channelArray) {
        QSButtonStyleModel *model = [[QSButtonStyleModel alloc] init];
        model.imagesNormal = [obj valueForKey:FOODGROUD_HEADERCHANNEL_BUTTON_IMAGE_NORMAL];
        model.imagesSelected = [obj valueForKey:FOODGROUD_HEADERCHANNEL_BUTTON_IMAGE_HIGHLIGHTED];
        
        [tempArray addObject:model];
    }
    
    return [NSArray arrayWithArray:tempArray];
}

#pragma mark - 美食侦探按钮风格
+ (QSButtonStyleModel *)createFoodDetectiveEditButtonStyle
{
    QSButtonStyleModel *buttonStyle = [[QSButtonStyleModel alloc] init];
    buttonStyle.imagesNormal = @"fooddetective_edit_normal";
    buttonStyle.imagesHighted = @"fooddetective_edit_highlighted";
    return buttonStyle;
}

+ (QSButtonStyleModel *)createFoodDetectiveAddButtonStyle
{
    QSButtonStyleModel *buttonStyle = [[QSButtonStyleModel alloc] init];
    buttonStyle.imagesNormal = @"fooddetective_add_normal";
    buttonStyle.imagesHighted = @"fooddetective_add_highlighted";
    return buttonStyle;
}

+ (QSButtonStyleModel *)createFoodDetectiveFreeButtonStyle
{
    QSButtonStyleModel *buttonStyle = [[QSButtonStyleModel alloc] init];
    buttonStyle.imagesNormal = @"fooddetective_free_normal";
    buttonStyle.imagesHighted = @"fooddetective_free_highlighted";
    return buttonStyle;
}

+ (QSButtonStyleModel *)createAddFoodStoreLocalButtonStyle
{
    //fooddetective_add_local_normal
    QSButtonStyleModel *buttonStyle = [[QSButtonStyleModel alloc] init];
    buttonStyle.imagesNormal = @"fooddetective_add_local_normal";
    buttonStyle.imagesHighted = @"fooddetective_add_local_highlighted";
    return buttonStyle;
}

+ (QSButtonStyleModel *)createAddFoodStoreVerificationCodeButtonStyle
{
    //fooddetective_add_local_normal
    QSButtonStyleModel *buttonStyle = [[QSButtonStyleModel alloc] init];
    buttonStyle.bgColor = kBaseHighlightedGrayBgColor;
    return buttonStyle;
}

+ (QSButtonStyleModel *)createAddFoodStoreSignUpButtonStyle
{
    QSButtonStyleModel *buttonStyle = [[QSButtonStyleModel alloc] init];
    buttonStyle.title = @"提交";
    buttonStyle.titleNormalColor = [UIColor whiteColor];
    buttonStyle.titleHightedColor = kBaseOrangeColor;
    buttonStyle.bgColor = kBaseOrangeColor;
    buttonStyle.cornerRadio = 22.0f;
    return buttonStyle;
}

+ (QSButtonStyleModel *)createJoinFreeActivityButtonStyle
{
    QSButtonStyleModel *buttonStyle = [[QSButtonStyleModel alloc] init];
    buttonStyle.title = @"马上参加";
    buttonStyle.titleNormalColor = [UIColor whiteColor];
    buttonStyle.titleHightedColor = kBaseOrangeColor;
    buttonStyle.bgColor = kBaseOrangeColor;
    buttonStyle.cornerRadio = 22.0f;
    return buttonStyle;
}

+ (QSButtonStyleModel *)createTryActivitiesShareButtonStyle
{
    QSButtonStyleModel *model = [[QSButtonStyleModel alloc] init];
    model.imagesNormal = @"fooddetective_tryactivities_share_normal";
    model.imagesHighted = @"fooddetective_tryactivities_share_highlighted";
    return model;
}

+ (QSButtonStyleModel *)createTryActivitiesSignUpButtonStyle
{
    QSButtonStyleModel *model = [[QSButtonStyleModel alloc] init];
    model.title = @"报名活动";
    model.titleNormalColor = [UIColor whiteColor];
    model.titleHightedColor = kBaseLightGrayColor;
    model.bgColor = kBaseGreenColor;
    model.cornerRadio = 17.5f;
    return model;
}

+ (QSButtonStyleModel *)createFreeActivitiesSignUpButtonStyle
{
    QSButtonStyleModel *model = [[QSButtonStyleModel alloc] init];
    model.title = @"我要投名状";
    model.titleFont = [UIFont systemFontOfSize:12.0f];
    model.titleNormalColor = [UIColor whiteColor];
    model.titleHightedColor = kBaseLightGrayColor;
    model.bgColor = kBaseGreenColor;
    model.cornerRadio = 7.5f;
    return model;
}

+ (QSButtonStyleModel *)createMyDetectiveNavigationMiddleItemStyle
{
    QSButtonStyleModel *model = [[QSButtonStyleModel alloc] init];
    model.titleFont = [UIFont boldSystemFontOfSize:14.0f];
    model.titleNormalColor = [UIColor whiteColor];
    model.titleSelectedColor = kBaseOrangeColor;
    model.bgColor = [UIColor clearColor];
    model.bgColorHighlighted = [UIColor whiteColor];
    model.cornerRadio = 10.0f;
    return model;
}

//fooddetective_article_interested_highlighted
+ (QSButtonStyleModel *)createMarDetectiveArticleInterestedButtonStyle
{
    QSButtonStyleModel *model = [[QSButtonStyleModel alloc] init];
    model.imagesNormal = @"fooddetective_article_interested_normal";
    model.imagesHighted = @"fooddetective_article_interested_highlighted";
    return model;
}

+ (QSButtonStyleModel *)createShareFoodStoreActivityConfirmButtonStyle
{
    QSButtonStyleModel *model = [[QSButtonStyleModel alloc] init];
    model.imagesNormal = @"sharefoodstore_confirm_normal";
    model.imagesHighted = @"sharefoodstore_confirm_normal";
    return model;
}

//**************************************
//          清空风格
//**************************************
#pragma mark - 清空风格
- (void)clearButtonStyle
{
    self.title = nil;
    self.bgColor = nil;
    self.titleNormalColor = nil;
    self.titleHightedColor = nil;
    self.titleSelectedColor = nil;
    self.borderColor = nil;
    self.borderWith = 0.0f;
    self.cornerRadio = 0.0f;
    self.imagesNormal = nil;
    self.imagesHighted = nil;
    self.imagesSelected = nil;
    self.titleFont = nil;
    self.aboveImage = nil;
}

@end
