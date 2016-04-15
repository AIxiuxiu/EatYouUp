//
//  UIButton+UI.h
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kCustomButtonType_ChatToMerchant,
    kCustomButtonType_CallToMerchant,
    kCustomButtonType_TakeoutOrderProgree,
    kCustomButtonType_Consume,
    kCustomButtonType_Distance,
    kCustomButtonType_CallTakout,
    kCustomButtonType_IndexCellDistance,
    kCustomButtonType_RegisterLiscense,
    kCustomButtonType_FoodBook,
    kCustomButtonType_FoodTakeout,
    kCustomButtonType_CommentMakeRecommend,
    kCustomButtonType_CommentMakeConsume,
    kCustomButtonType_PayReceived,
    kCustomButtonType_PayOnline,
    kCustomButtonType_PayCard,
    kCustomButtonType_NoUseCoupon,
    kCustomButtonType_UseCoupon,
    kCustomButtonType_Male,
    kCustomButtonType_Female,
    kCustomButtonType_SetDefaultDeliveryAddress,
    kCustomButtonType_ItemSelect,
    kCustomButtonType_FoodViewTimes,
    kCustomButtonType_foodLike,
    kCustomButtonType_Address
}kCustomButtonType;

@interface UIButton (UI)

- (void)roundButton;

- (void)roundCornerRadius:(CGFloat)radius;

- (void)customButton:(kCustomButtonType)buttonType;

@end
