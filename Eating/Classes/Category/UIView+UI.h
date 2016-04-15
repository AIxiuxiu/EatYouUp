//
//  UIView+UI.h
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSTakeoutOrderListCell.h"

typedef enum
{
    kCouponType_Member,     //会员
    kCouponType_Limit,      //限时
    kCouponType_Cash,       //代金券
    kCouponType_Exchange,   //兑换券
    kCouponType_Discount,   //折扣券
    kCouponType_Dish        //菜品
}kCouponType;

typedef enum
{
    
    kFoodType_New = 1,
    kFoodType_Hot,
    kFoodType_Recommend,
    
}kFoodType;

@interface UIView (UI)

- (void)roundView;

- (void)roundCornerRadius:(CGFloat)radius;

- (void)customView:(kCouponType)couponType;

- (void)customFoodView:(kFoodType)foodType;

+ (UIView *)listHeaderView:(NSString *)title;

+ (UIView *)listFooterView:(NSString *)foodCount and:(NSString *)foodAmount;

- (void)takeoutDetailOrderLogoView:(kTakeoutOrderStatus)orderType;

- (void)bookDetailOrderLogoView:(kBookOrderStatus)orderType bookno:(NSString *)book_no;

+ (UIView *)priceViewWithPrice:(NSString *)price Color:(UIColor *)color;

+ (UIView *)discountViewWithDiscount:(NSString *)discount Color:(UIColor *)color;

+ (UIView *)takeoutCountWithNum:(NSString *)num Color:(UIColor *)color;

+ (UIView *)bookCountWithNum:(NSString *)num Color:(UIColor *)color;
@end
