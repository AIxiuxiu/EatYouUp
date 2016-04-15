//
//  QSButtonStyleModel.h
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;
@class UIFont;
@interface QSButtonStyleModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,retain) UIColor *bgColor;
@property (nonatomic,retain) UIColor *bgColorHighlighted;
@property (nonatomic,retain) UIColor *titleNormalColor;
@property (nonatomic,retain) UIColor *titleHightedColor;
@property (nonatomic,retain) UIColor *titleSelectedColor;
@property (nonatomic,retain) UIColor *borderColor;
@property (nonatomic,assign)  float borderWith;
@property (nonatomic,assign) float cornerRadio;
@property (nonatomic,copy) NSString *imagesNormal;
@property (nonatomic,copy) NSString *imagesHighted;
@property (nonatomic,copy) NSString *imagesSelected;
@property (nonatomic,copy) UIFont *titleFont;
@property (nonatomic,copy) NSString *aboveImage;

//**************************************
//          类方法创建常用风格
//**************************************
+ (QSButtonStyleModel *)createTurnBackButtonStyle;
+ (QSButtonStyleModel *)createLocationButtonStyle;
+ (NSArray *)createFoodGroudButtonStyleArray;
+ (QSButtonStyleModel *)createFoodDetectiveEditButtonStyle;
+ (QSButtonStyleModel *)createFoodDetectiveAddButtonStyle;
+ (QSButtonStyleModel *)createFoodDetectiveFreeButtonStyle;
+ (QSButtonStyleModel *)createAddFoodStoreLocalButtonStyle;
+ (QSButtonStyleModel *)createAddFoodStoreVerificationCodeButtonStyle;
+ (QSButtonStyleModel *)createAddFoodStoreSignUpButtonStyle;
+ (QSButtonStyleModel *)createJoinFreeActivityButtonStyle;
+ (QSButtonStyleModel *)createTryActivitiesShareButtonStyle;
+ (QSButtonStyleModel *)createTryActivitiesSignUpButtonStyle;
+ (QSButtonStyleModel *)createFreeActivitiesSignUpButtonStyle;
+ (QSButtonStyleModel *)createMyDetectiveNavigationMiddleItemStyle;
+ (QSButtonStyleModel *)createMarDetectiveArticleInterestedButtonStyle;
+ (QSButtonStyleModel *)createShareFoodStoreActivityConfirmButtonStyle;

//**************************************
//          清空风格
//**************************************
- (void)clearButtonStyle;

@end
