//
//  UIView+UI.m
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "UIView+UI.h"
#import "QSConfig.h"

@implementation UIView (UI)

- (void)roundView
{
    [self roundCornerRadius:CGRectGetWidth(self.frame)/2];
    self.layer.masksToBounds = YES;
}

- (void)roundCornerRadius:(CGFloat)radius
{
    if (radius == 0.0) {
        [self.layer setCornerRadius:kButtonDefaultCornerRadius];
    }
    else{
        [self.layer setCornerRadius:radius];
    }
    self.layer.masksToBounds = YES;
}

- (void)customView:(kCouponType)couponType
{
    UIImageView *imView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 60, 15)];
    if (couponType == kCouponType_Member) {
        imView.image = IMAGENAME(@"recommed_cell_couponicon1");
    }
    else if (couponType == kCouponType_Limit){
        imView.image = IMAGENAME(@"recommed_cell_couponicon2");
    }
    else if (couponType == kCouponType_Cash){
        imView.image = IMAGENAME(@"recommed_cell_couponicon3");
    }
    else if (couponType == kCouponType_Exchange){
        imView.image = IMAGENAME(@"recommed_cell_couponicon4");
    }
    else if (couponType == kCouponType_Discount){
        imView.image = IMAGENAME(@"recommed_cell_couponicon5");
    }
    else if (couponType == kCouponType_Dish){
        imView.image = IMAGENAME(@"recommed_cell_couponicon6");
    }
    [self addSubview:imView];
}

- (void)customFoodView:(kFoodType)foodType
{
    UIImageView *imView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 0, 60, 15)];
    if (foodType == kFoodType_New) {
        imView.image = IMAGENAME(@"foodlist_cell_icon_new");
    }
    else if (foodType == kFoodType_Hot){
        imView.image = IMAGENAME(@"foodlist_cell_icon_hot");
    }
    else if (foodType == kFoodType_Recommend){
        imView.image = IMAGENAME(@"foodlist_cell_icon_rec");
    }
    [self addSubview:imView];
}

+ (UIView *)listHeaderView:(NSString *)title
{
    CGRect bound = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((DeviceWidth-80)/2, 0, 80, 50)];
    titleLabel.backgroundColor = kBaseBackgroundColor;
    titleLabel.textColor = kBaseGrayColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.text = title;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 25, bound.size.width-20, 1)];
    line.backgroundColor = kBaseLightGrayColor;
    [view addSubview:line];
    [view addSubview:titleLabel];
    return view;
}

+ (UIView *)listFooterView:(NSString *)foodCount and:(NSString *)foodAmount
{
    
    CGRect bound = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bound.size.width, 50)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
    contentLabel.backgroundColor = kBaseBackgroundColor;
    contentLabel.textColor = kBaseGrayColor;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:17.0];

    NSString *content = [NSString stringWithFormat:@"共%@份美食  总价:￥%@",foodCount,foodAmount];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:content];
    NSRange range1 = NSMakeRange(1, foodCount.length);
    NSRange range2 = NSMakeRange(9+foodCount.length, content.length-9-foodCount.length);
    
    NSArray *colors=[NSArray arrayWithObjects:kBaseOrangeColor,nil];
    
    [string addAttribute:NSForegroundColorAttributeName value:[colors objectAtIndex:0] range:range1];
    [string addAttribute:NSForegroundColorAttributeName value:[colors objectAtIndex:0] range:range2];
    [contentLabel setAttributedText:string];
    
    [view addSubview:contentLabel];
    
    return view;
}

+ (UIView *)priceViewWithPrice:(NSString *)price Color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20+25*price.length, 50)];
    view.backgroundColor = [UIColor clearColor];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 15, 30)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:17.0];
    label1.textColor = color;
    label1.text = @"￥";
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 25*price.length, 50)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:42.0];
    label2.textColor = color;
    label2.text = price;
    
    [view addSubview:label1];
    [view addSubview:label2];

    return view;
}

+ (UIView *)discountViewWithDiscount:(NSString *)discount Color:(UIColor *)color
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20+60, 50)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 15, 30)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:15.0];
    label1.textColor = color;
    label1.text = @"折";
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:42.0];
    label2.textColor = color;
    label2.text = [NSString stringWithFormat:@"%.1f",[discount floatValue]/10];
    
    [view addSubview:label1];
    [view addSubview:label2];
    
    return view;
}

+ (UIView *)takeoutCountWithNum:(NSString *)num Color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20+25*num.length, 50)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25*num.length, 20, 15, 30)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:15.0];
    label1.textColor = color;
    label1.text = @"份";
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25*num.length, 50)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:42.0];
    label2.textColor = color;
    label2.text = num;
    
    [view addSubview:label1];
    [view addSubview:label2];
    
    return view;

}

+ (UIView *)bookCountWithNum:(NSString *)num Color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20+25*num.length, 50)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25*num.length, 20, 15, 30)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:15.0];
    label1.textColor = color;
    label1.text = @"人";
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25*num.length, 50)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:42.0];
    label2.textColor = color;
    label2.text = num;
    
    [view addSubview:label1];
    [view addSubview:label2];
    
    return view;
}


- (void)takeoutDetailOrderLogoView:(kTakeoutOrderStatus)orderType
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.width-2, self.frame.size.height-2)];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(32, 15, 34, 34)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, 100, 30)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:17.0];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 100, 25)];
    label2.backgroundColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:10.0];
    label2.text = @"外卖订单";
    [vi addSubview:label1];
    [vi addSubview:label2];
    [vi addSubview:logo];
    [self addSubview:vi];
    if (orderType == kTakeoutOrderStatus_Unpay) {
        logo.image = IMAGENAME(@"takeout_orderdetail_logo1.png");
        label1.text = @"待付款";
        label2.textColor = kBaseGreenColor;
        vi.backgroundColor = kBaseGreenColor;
    }
    else if (orderType == kTakeoutOrderStatus_Pay){
        logo.image = IMAGENAME(@"takeout_orderdetail_logo2.png");
        label1.text = @"送餐中";
        label2.textColor = kBaseOrangeColor;
        vi.backgroundColor = kBaseOrangeColor;
    }
    else if (orderType == kTakeoutOrderStatus_Delivered){
        logo.image = IMAGENAME(@"takeout_orderdetail_logo3.png");
        label1.text = @"已签收";
        label2.textColor = kBaseGrayColor;
        vi.backgroundColor = kBaseGrayColor;
    }
    else if (orderType == kTakeoutOrderStatus_Cancelled){
        logo.image = IMAGENAME(@"takeout_orderdetail_logo4.png");
        label1.text = @"已取消";
        label2.textColor = kBaseGrayColor;
        vi.backgroundColor = kBaseGrayColor;
    }
    [vi roundView];
    [vi.layer setBorderColor:[UIColor blackColor].CGColor];
    [vi.layer setBorderWidth:1];
    
    [self roundView];
    [self.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.layer setBorderWidth:3];
    [self clipsToBounds];
    vi.layer.masksToBounds = YES;
    self.layer.masksToBounds = YES;
    [self addSubview:vi];
}

- (void)bookDetailOrderLogoView:(kBookOrderStatus)orderType bookno:(NSString *)book_no
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.width-2, self.frame.size.height-2)];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(32, 15, 34, 34)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, 100, 30)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:17.0];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 100, 25)];
    label2.backgroundColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:10.0];
    label2.text = @"预约订单";
    [vi addSubview:label1];
    [vi addSubview:label2];
    [vi addSubview:logo];
    [self addSubview:vi];
    
    if (orderType == kBookOrderStatus_UnConfirm) {
        logo.image = IMAGENAME(@"takeout_orderstatus_icon2.png");
        label1.text = @"待确认";
        label2.textColor = kBaseGreenColor;
        vi.backgroundColor = kBaseGreenColor;
    }
    else if (orderType == kBookOrderStatus_Booking){
        logo.image = IMAGENAME(@"takeout_orderstatus_icon2.png");
        label1.text = @"预约中";
        label2.textColor = kBaseGreenColor;
        vi.backgroundColor = kBaseGreenColor;
    }
    else if (orderType == kBookOrderStatus_Inqueue){
        logo.image = IMAGENAME(@"takeout_orderstatus_icon2.png");
        label1.text = book_no;
        label2.textColor = kBaseOrangeColor;
        vi.backgroundColor = kBaseOrangeColor;
    }
    else if (orderType == kBookOrderStatus_Confirmed){
        logo.image = IMAGENAME(@"takeout_orderstatus_icon3.png");
        label1.text = @"已到号";
        label2.textColor = kBaseOrangeColor;
        vi.backgroundColor = kBaseOrangeColor;
    }
    else if (orderType == kBookOrderStatus_Inshop){
        logo.image = IMAGENAME(@"takeout_orderstatus_icon3.png");
        label1.text = @"已到店";
        label2.textColor = kBaseGrayColor;
        vi.backgroundColor = kBaseGrayColor;
    }
    else if (orderType == kBookOrderStatus_RestCanceled || orderType == kBookOrderStatus_ClientCanceled){
        logo.image = IMAGENAME(@"takeout_orderstatus_icon4.png");
        label1.text = @"已取消";
        label2.textColor = kBaseGrayColor;
        vi.backgroundColor = kBaseGrayColor;
    }
    [vi roundView];
    [vi.layer setBorderColor:[UIColor blackColor].CGColor];
    [vi.layer setBorderWidth:1];
    
    [self roundView];
    [self.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.layer setBorderWidth:3];
    [self clipsToBounds];
    vi.layer.masksToBounds = YES;
    self.layer.masksToBounds = YES;
    [self addSubview:vi];
}

@end
