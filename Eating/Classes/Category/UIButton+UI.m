//
//  UIButton+UI.m
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "UIButton+UI.h"
#import "QSConfig.h"

@implementation UIButton (UI)

- (void)roundButton
{
    [self roundCornerRadius:CGRectGetWidth(self.frame)/2];
    
}

- (void)roundCornerRadius:(CGFloat)radius
{
    if (radius == 0.0) {
        [self.layer setCornerRadius:kButtonDefaultCornerRadius];
    }
    else{
        [self.layer setCornerRadius:radius];
    }
}


- (void)customButton:(kCustomButtonType)buttonType
{
    CGRect frame = self.frame;
    UIImageView *icon = [[UIImageView alloc] init];
    if (buttonType == kCustomButtonType_ChatToMerchant) {
        frame.size.width = 80;
        frame.size.height = 30;
        self.frame = frame;
        icon.frame = CGRectMake(0, 6, 18, 18);
        icon.image = IMAGENAME(@"merchant_chat.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitle:@"     咨询商户" forState:UIControlStateNormal];
        [self setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
    }
    else if (buttonType == kCustomButtonType_CallToMerchant){
        frame.size.width = 80;
        frame.size.height = 30;
        self.frame = frame;
        icon.frame = CGRectMake(0, 6, 18, 18);
        icon.image = IMAGENAME(@"merchant_call.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitle:@"     呼叫商户" forState:UIControlStateNormal];
        [self setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
    }
    else if (buttonType == kCustomButtonType_Consume){
        frame.size.width = 80;
        frame.size.height = 28;
        self.frame = frame;
        icon.frame = CGRectMake(12, 5, 10, 15);
        icon.image = IMAGENAME(@"merchant_icon_consume.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundColor:kBaseBlueColor];
        [self roundCornerRadius:15];
    }
    else if (buttonType == kCustomButtonType_Distance){
        frame.size.width = 80;
        frame.size.height = 28;
        self.frame = frame;
        icon.frame = CGRectMake(12, 7, 10, 15);
        icon.image = IMAGENAME(@"merchant_icon_distance-1.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundColor:kBaseBlueColor];
        [self roundCornerRadius:15];
    }
    else if (buttonType == kCustomButtonType_CallTakout){
        frame.size.width = 100;
        frame.size.height = 28;
        self.frame = frame;
        icon.frame = CGRectMake(12, 6, 16, 16);
        icon.image = IMAGENAME(@"foodlist_footer_icon_call.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitle:@"     致电商家" forState:UIControlStateNormal];
        [self setBackgroundColor:kBaseOrangeColor];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_IndexCellDistance){
        frame.size.width = 70;
        frame.size.height = 21;
        self.frame = frame;
        icon.frame = CGRectMake(9, 6, 7, 9);
        icon.image = IMAGENAME(@"recommend_icon_distance.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    }
    else if (buttonType == kCustomButtonType_RegisterLiscense){
        for (UIView *vi in self.subviews) {
            if (vi.tag == 999) {
                [vi removeFromSuperview];
                break;
            }
        }
        frame.size.width = 300;
        frame.size.height = 30;
        self.frame = frame;
        icon.tag = 999;
        icon.frame = CGRectMake(9, 6, 18, 18);
        if (self.selected) {
            icon.image = IMAGENAME(@"register_icon_declare_click.png");
        }
        else{
            icon.image = IMAGENAME(@"register_icon_declare.png");
        }
        [self addSubview:icon];
        [self setTitle:@"     我已看过并同意吃订你《用户使用协议》" forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    else if (buttonType == kCustomButtonType_FoodTakeout){
        frame.size.width = 100;
        frame.size.height = 28;
        self.frame = frame;
        icon.frame = CGRectMake(12, 6, 16, 16);
        icon.image = IMAGENAME(@"food_footer_icon_takeout.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitle:@"     外卖点餐" forState:UIControlStateNormal];
        [self setBackgroundColor:kBaseOrangeColor];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_FoodBook){
        frame.size.width = 100;
        frame.size.height = 28;
        self.frame = frame;
        icon.frame = CGRectMake(12, 6, 16, 16);
        icon.image = IMAGENAME(@"food_footer_icon_book.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitle:@"     预约订座" forState:UIControlStateNormal];
        [self setBackgroundColor:kBaseOrangeColor];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_CommentMakeRecommend){
        frame.size.width = 148;
        frame.size.height = 44;
        self.frame = frame;
        icon.frame = CGRectMake(37, 15, 11, 13);
        icon.image = IMAGENAME(@"comment_make_icon_menu.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [self setTitle:@"     推荐菜单" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_CommentMakeConsume){
        frame.size.width = 148;
        frame.size.height = 44;
        self.frame = frame;
        icon.frame = CGRectMake(37, 15, 11, 13);
        icon.image = IMAGENAME(@"comment_make_icon_consume.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [self setTitle:@"     人均消费" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_PayReceived){
        for (UIView *vi in self.subviews) {
            if (vi.tag == 999) {
                [vi removeFromSuperview];
                break;
            }
        }
        frame.size.width = 120;
        frame.size.height = 43;
        self.frame = frame;
        icon.frame = CGRectMake(10, 15, 13, 13);
        icon.tag = 999;
        if (self.selected) {
            icon.image = IMAGENAME(@"takeout_fill_checkbox_selected.png");

        }
        else{
            icon.image = IMAGENAME(@"takeout_fill_checkbox.png");

        }
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [self setTitle:@"     餐到付款" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_PayOnline){
        for (UIView *vi in self.subviews) {
            if (vi.tag == 999) {
                [vi removeFromSuperview];
                break;
            }
        }
        frame.size.width = 120;
        frame.size.height = 43;
        self.frame = frame;
        icon.frame = CGRectMake(10, 15, 13, 13);
        icon.tag = 999;
        if (self.selected) {
            icon.image = IMAGENAME(@"takeout_fill_checkbox_selected.png");
            
        }
        else{
            icon.image = IMAGENAME(@"takeout_fill_checkbox.png");
            
        }
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [self setTitle:@"     在线支付" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_PayCard){
        for (UIView *vi in self.subviews) {
            if (vi.tag == 999) {
                [vi removeFromSuperview];
                break;
            }
        }
        frame.size.width = 120;
        frame.size.height = 43;
        self.frame = frame;
        icon.frame = CGRectMake(10, 15, 13, 13);
        icon.tag = 999;
        if (self.selected) {
            icon.image = IMAGENAME(@"takeout_fill_checkbox_selected.png");
            
        }
        else{
            icon.image = IMAGENAME(@"takeout_fill_checkbox.png");
            
        }
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [self setTitle:@"        储值卡支付" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_TakeoutOrderProgree){
        frame.size.width = 80;
        frame.size.height = 30;
        self.frame = frame;
        icon.frame = CGRectMake(0, 6, 16, 18);
        icon.image = IMAGENAME(@"takeout_icon_orderprogress.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitle:@"     进度详情" forState:UIControlStateNormal];
        [self setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
    }
    else if (buttonType == kCustomButtonType_NoUseCoupon){
        for (UIView *vi in self.subviews) {
            if (vi.tag == 999) {
                [vi removeFromSuperview];
                break;
            }
        }
        self.frame = frame;
        icon.frame = CGRectMake(10, 15, 13, 13);
        icon.tag = 999;
        if (self.selected) {
            icon.image = IMAGENAME(@"takeout_fill_checkbox_selected.png");
            
        }
        else{
            icon.image = IMAGENAME(@"takeout_fill_checkbox.png");
            
        }
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [self setTitle:@"     不使用优惠" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_UseCoupon){
        for (UIView *vi in self.subviews) {
            if (vi.tag == 999) {
                [vi removeFromSuperview];
                break;
            }
        }
        self.frame = frame;
        icon.frame = CGRectMake(10, 15, 13, 13);
        icon.tag = 999;
        if (self.selected) {
            icon.image = IMAGENAME(@"takeout_fill_checkbox_selected.png");
            
        }
        else{
            icon.image = IMAGENAME(@"takeout_fill_checkbox.png");
            
        }
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [self setTitle:@"     使用优惠" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_Male){
        for (UIView *vi in self.subviews) {
            if (vi.tag == 999) {
                [vi removeFromSuperview];
                break;
            }
        }
        frame.size.width = 80;
        frame.size.height = 30;
        self.frame = frame;
        icon.frame = CGRectMake(10, 8, 13, 13);
        icon.tag = 999;
        if (self.selected) {
            icon.image = IMAGENAME(@"takeout_fill_checkbox_selected.png");
            
        }
        else{
            icon.image = IMAGENAME(@"takeout_fill_checkbox.png");
            
        }
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [self setTitle:@" 男" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_Female){
        for (UIView *vi in self.subviews) {
            if (vi.tag == 999) {
                [vi removeFromSuperview];
                break;
            }
        }
        frame.size.width = 80;
        frame.size.height = 30;
        self.frame = frame;
        icon.frame = CGRectMake(10, 8, 13, 13);
        icon.tag = 999;
        if (self.selected) {
            icon.image = IMAGENAME(@"takeout_fill_checkbox_selected.png");
            
        }
        else{
            icon.image = IMAGENAME(@"takeout_fill_checkbox.png");
            
        }
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [self setTitle:@" 女" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_SetDefaultDeliveryAddress){
        for (UIView *vi in self.subviews) {
            if (vi.tag == 999) {
                [vi removeFromSuperview];
                break;
            }
        }
        frame.size.width = 180;
        frame.size.height = 30;
        self.frame = frame;
        icon.frame = CGRectMake(0, 8, 13, 13);
        icon.tag = 999;
        if (self.selected) {
            icon.image = IMAGENAME(@"takeout_fill_checkbox_selected.png");
            
        }
        else{
            icon.image = IMAGENAME(@"takeout_fill_checkbox.png");
            
        }
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [self setTitle:@"   设置为默认送餐地址" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
        [self roundCornerRadius:13];
    }
    else if (buttonType == kCustomButtonType_ItemSelect){

        icon.frame = CGRectMake(self.frame.size.width-20, 17, 6, 10);
        icon.image = IMAGENAME(@"button_arrow");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    }
    else if (buttonType == kCustomButtonType_FoodViewTimes){
        frame.size.width = 60;
        frame.size.height = 21;
        self.frame = frame;
        icon.frame = CGRectMake(0, 6, 15, 9);
        icon.image = IMAGENAME(@"user_collection_food_readed.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
    }
    else if (buttonType == kCustomButtonType_foodLike){
        frame.size.width = 60;
        frame.size.height = 21;
        self.frame = frame;
        icon.frame = CGRectMake(0, 6, 10, 9);
        icon.image = IMAGENAME(@"user_collection_food_like.png");
        [self addSubview:icon];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
    }
    else if (buttonType == kCustomButtonType_Address){
        [self.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
        
        CGSize size = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(DeviceWidth-20, 21) lineBreakMode:NSLineBreakByWordWrapping];
        frame.size.width = size.width+20;
        frame.size.height = 21;
        self.frame = frame;
        
        icon.frame = CGRectMake(0, 6, 7, 9);
        icon.image = IMAGENAME(@"merchant_icon_distance.png");
        [self addSubview:icon];
        
        
        UIImageView *icon1 = [[UIImageView alloc] init];
        icon1.frame = CGRectMake(3+size.width, 7, 4, 7);
        icon1.image = IMAGENAME(@"little_arrow.png");
        [self addSubview:icon1];
        

    }
}

@end
