//
//  QSPrepaidCardTableViewCell.m
//  Eating
//
//  Created by ysmeng on 14/11/28.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidCardTableViewCell.h"
#import "QSConfig.h"
#import "QSBlockActionButton.h"
#import "QSAPI.h"
#import "UIImageView+AFNetworking.h"
#import "QSAPIModel+CouponList.h"
#import "NSDate+QSDateFormatt.h"
#import "NSString+Name.h"
#import "UIView+UI.h"

#import <objc/runtime.h>

//关联
static char InfoShowRootViewKey;
static char VolumeTypeImageKey;
static char InstructionKey;
static char SoldCountKey;
static char RightTipsInfoRootViewKey;

static char foodImageKey;
@implementation QSPrepaidCardTableViewCell

//************************************
//             初始化/UI搭建
//************************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCellType:(PREPAIDCARD_NORMAL_CELLTYPE)cellType
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        //创建不同的UI
        [self createPrepaidCardNormalCellUIWithType:cellType];
    }
    return self;
}

//根据类型分发创建UI
- (void)createPrepaidCardNormalCellUIWithType:(PREPAIDCARD_NORMAL_CELLTYPE)cellType
{
    //底view
    UIImageView *rootView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, DeviceWidth-20.0f, 100.0f)];
    
    //判断是否是加载没有记录的cell
    if (cellType == NONEPRPAIDCARD_CELL_PREPAIDCT) {
        rootView.frame = CGRectMake(rootView.frame.origin.x, rootView.frame.origin.y, rootView.frame.size.width, 25.0f);
        rootView.image = [UIImage imageNamed:@"prepaidcard_list_none"];
        
        //提示信息
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 2.5f, rootView.frame.size.width-20.0f, rootView.frame.size.height-5.0f)];
        tipsLabel.font = [UIFont systemFontOfSize:14.0f];
        tipsLabel.text = @"暂无记录";
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.textColor = kBaseLightGrayColor;
        [rootView addSubview:tipsLabel];
        
        //加载
        [self.contentView addSubview:rootView];
        
        return;
    }
    
    //加载区别视图
    [self setDifferentCellSubviews:rootView andCellType:cellType];
    
    //创建子视图
    [self createInfoView:rootView];
    
    //添加
    [self.contentView addSubview:rootView];
    
    //关联
    objc_setAssociatedObject(self, &InfoShowRootViewKey, rootView, OBJC_ASSOCIATION_ASSIGN);
}

//为不同类型的cell加载不同的区别视图
- (void)setDifferentCellSubviews:(UIImageView *)view andCellType:(PREPAIDCARD_NORMAL_CELLTYPE)cellType
{
    switch (cellType) {
        case FIRSTLINE_CELL_PREPAIDCT:
            view.image = [UIImage imageNamed:@"prepaidcard_list_first"];
            break;
            
        case MIDDLELINE_CELL_PREPAIDCT:
            view.image = [UIImage imageNamed:@"prepaidcard_list_normal"];
            break;
            
        case LASTLINE_CELL_PREPAIDCT:
            view.image = [UIImage imageNamed:@"prepaidcard_list_last"];
            break;
            
        case ADDMORE_LASTLINE_CELL_PREPAIDCT:
            view.image = [UIImage imageNamed:@"prepaidcard_list_lastspecial"];
            //添加更多按钮
            break;
            
        case SINGLELINE_CELL_PREPAIDCT:
            view.image = [UIImage imageNamed:@"prepaidcard_list_single"];
            break;
            
        default:
            break;
    }
}

//加载信息显示视图
- (void)createInfoView:(UIView *)view
{
    
    ///优惠券类型图标
    UIImageView *typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 60.0f, 15.0f)];
    [view addSubview:typeImage];
    objc_setAssociatedObject(self, &VolumeTypeImageKey, typeImage, OBJC_ASSOCIATION_ASSIGN);
    
    ///菜品的图片
    UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 1.0f, 60.0f)];
    [foodImageView roundView];
    [view addSubview:foodImageView];
    objc_setAssociatedObject(self, &foodImageKey, foodImageView, OBJC_ASSOCIATION_ASSIGN);
    
    //说明
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 25.0f, view.frame.size.width - 150.0f, 40.0f)];
    instructionLabel.text = @"价值500元储值卡，现仅售360元，无需预约节假日通用全场通用！";
    instructionLabel.textColor = kBaseGrayColor;
    instructionLabel.font = [UIFont systemFontOfSize:14.0f];
    instructionLabel.numberOfLines = 2;
    [view addSubview:instructionLabel];
    objc_setAssociatedObject(self, &InstructionKey, instructionLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //已售
    UILabel *soldLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, instructionLabel.frame.origin.y+instructionLabel.frame.size.height+5.0f, 180.0f, 15.0f)];
    soldLabel.text = @"已售28392份";
    soldLabel.textColor = kBaseLightGrayColor;
    soldLabel.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:soldLabel];
    objc_setAssociatedObject(self, &SoldCountKey, soldLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///右侧复用的view
    UIView *rightReuseRootView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width-140.0f, 25.0f, 130.0f,view.frame.size.height-25.0f)];
    [view addSubview:rightReuseRootView];
    objc_setAssociatedObject(self, &RightTipsInfoRootViewKey, rightReuseRootView, OBJC_ASSOCIATION_ASSIGN);

}

/**
 *  @author yangshengmeng, 14-12-11 17:12:51
 *
 *  @brief  返回右侧信息显示底view：用来显示价钱、折扣信息等
 *
 *  @return 返回view
 *
 *  @since  2.0
 */
- (UIView *)getRightTipsInfoRootView
{
    UIView *view = objc_getAssociatedObject(self, &RightTipsInfoRootViewKey);
    
    ///先清空
    for (UIView *obj in [view subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    ///添加代金券金额
    
    return view;
}

/**
 *  @author yangshengmeng, 14-12-11 14:12:25
 *
 *  @brief  创建储值卡价钱显示UI：现价、原价
 *
 *  @param  originalPrice 储值卡价值
 *  @param  salePrice     储值卡售价
 *
 *  @since  2.0
 */
#pragma mark - 重新布局储值/优惠折扣/菜口不同的UI
- (void)createPrepaidCardPriceInfo:(NSString *)originalPrice andSalePrice:(NSString *)salePrice
{
    ///获取底view
    UIView *view = [self getRightTipsInfoRootView];
    
    ///计算现价的长度
    CGFloat widthOfCurrentPrice = [[NSString stringWithFormat:@"%.2f", [salePrice floatValue]] calculateStringHeightByFixedHeight:40.0f andFontSize:35.0f];
    
    ///显示现价
    UILabel *currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-widthOfCurrentPrice, 0.0f, widthOfCurrentPrice, 40.0f)];
    currentPriceLabel.text = [NSString stringWithFormat:@"%.2f", [salePrice floatValue]];
    currentPriceLabel.font = [UIFont boldSystemFontOfSize:35.0f];
    currentPriceLabel.textColor = kBaseOrangeColor;
    currentPriceLabel.backgroundColor = [UIColor clearColor];
    currentPriceLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:currentPriceLabel];
    
    //现价前的RMB符号
    UILabel *rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentPriceLabel.frame.origin.x-15.0f, currentPriceLabel.frame.size.height+currentPriceLabel.frame.origin.y-20.0f, 15.0f, 10.0f)];
    rmbLabel.text = kRMBSymbol;
    rmbLabel.textColor = kBaseOrangeColor;
    rmbLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:rmbLabel];
    
    ///计算现价的长度
    CGFloat widthOfOriginalPrice = [[NSString stringWithFormat:@"%.2f", [originalPrice floatValue]] calculateStringHeightByFixedHeight:15.0f andFontSize:12.0f];
    ///原价
    UILabel *originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-widthOfOriginalPrice-15.0f, currentPriceLabel.frame.origin.y+currentPriceLabel.frame.size.height+5.0f, widthOfOriginalPrice, 15.0f)];
    originalPriceLabel.text = [NSString stringWithFormat:@"%.2f", [originalPrice floatValue]];
    originalPriceLabel.font = [UIFont systemFontOfSize:12.0f];
    originalPriceLabel.textColor = kBaseLightGrayColor;
    originalPriceLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:originalPriceLabel];
    
    //划线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, originalPriceLabel.frame.size.height/2.0f-0.5, originalPriceLabel.frame.size.width, 1.0f)];
    lineLabel.backgroundColor = kBaseLightGrayColor;
    [originalPriceLabel addSubview:lineLabel];
    
}

/**
 *  @author yangshengmeng, 14-12-11 15:12:34
 *
 *  @brief  添加折扣数字信息
 *
 *  @param  discount 折扣百分比
 *
 *  @since  2.0
 */
- (void)createDiscountInfoUI:(NSString *)discount
{
    
    ///将百分比折扣转化为十进制折扣
    NSString *disString = [discount formatDiscountWithPercent:discount];
    
    ///获取底view
    UIView *view = [self getRightTipsInfoRootView];
    
    ///计算显示所需要的长度
    CGFloat widthOfDiscountLabel = [disString calculateStringHeightByFixedHeight:40.0f andFontSize:35.0f];
    
    ///获取折扣显示label
    UILabel *disCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-widthOfDiscountLabel-10.0f, 0.0f, widthOfDiscountLabel, 40.0f)];
    disCountLabel.font = [UIFont systemFontOfSize:35.0f];
    disCountLabel.text = disString;
    disCountLabel.textColor = kBaseOrangeColor;
    [view addSubview:disCountLabel];
    
    ///折字显示
    ///如若未存在折字的显示视图，则创建
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-20.0f, disCountLabel.frame.origin.y+disCountLabel.frame.size.height-18.0f, 15.0f, 10.0f)];
    tipsLabel.text = @"折";
    tipsLabel.font = [UIFont systemFontOfSize:12.0f];
    tipsLabel.textColor = kBaseOrangeColor;
    [view addSubview:tipsLabel];
    
}

/**
 *  @author         yangshengmeng, 14-12-14 17:12:59
 *
 *  @brief          创建代金券的UI
 *
 *  @param price    代金券面额
 *
 *  @since          2.0
 */
- (void)createVoucherCouponUIWithPrice:(NSString *)price
{
    
    ///获取底view
    UIView *view = [self getRightTipsInfoRootView];
    
    ///将面额转化为两位小数
    NSString *tempPrice = [NSString stringWithFormat:@"%.2f",[price floatValue]];
    
    ///计算显示所需要的长度
    CGFloat widthOfDiscountLabel = [tempPrice calculateStringHeightByFixedHeight:40.0f andFontSize:35.0f];
    
    ///获取折扣显示label
    UILabel *disCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-widthOfDiscountLabel, 0.0f, widthOfDiscountLabel, 40.0f)];
    disCountLabel.font = [UIFont systemFontOfSize:35.0f];
    disCountLabel.text = tempPrice;
    disCountLabel.textColor = kBaseOrangeColor;
    [view addSubview:disCountLabel];
    
    ///金钱前面的人民币符号
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(disCountLabel.frame.origin.x-10.0f, disCountLabel.frame.origin.y+disCountLabel.frame.size.height-18.0f, 15.0f, 10.0f)];
    tipsLabel.text = @"￥";
    tipsLabel.font = [UIFont systemFontOfSize:12.0f];
    tipsLabel.textColor = kBaseOrangeColor;
    [view addSubview:tipsLabel];
    
}

/**
 *  @author         yangshengmeng, 14-12-14 18:12:15
 *
 *  @brief          如果有菜品图片，则显示菜品，如果传入nil，则复原说明信息框
 *
 *  @param imageUrl 菜品的地址
 *
 *  @since          2.0
 */
- (void)resetFoodImageWithImageUrlString:(NSString *)imageUrl
{
    
    ///判断传入的是否是有效的图片址
    if (nil == imageUrl) {
        
        ///如果图片地址有效，则显示图片
        UIImageView *imageView = objc_getAssociatedObject(self, &foodImageKey);
        UILabel *commentLabel = objc_getAssociatedObject(self, &InstructionKey);
        UILabel *soldCount = objc_getAssociatedObject(self, &SoldCountKey);
        
        ///判断说明信息栏的x坐标是否已变动了：如若未变动，则不重新换位置
        CGFloat xpoint = commentLabel.frame.origin.x;
        if (xpoint <= 11.0f) {
            
            imageView.image = nil;
            
            return;
            
        }
        
        ///加载图片
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 1.0f, imageView.frame.size.height);
        imageView.image = nil;
        
        //将说明信息压缩
        commentLabel.frame = CGRectMake(commentLabel.frame.origin.x-75.0f, commentLabel.frame.origin.y, commentLabel.frame.size.width+75.0f, commentLabel.frame.size.height);
        
        ///已售或者活动日期，移动
        soldCount.frame = CGRectMake(soldCount.frame.origin.x-75.0f, soldCount.frame.origin.y, soldCount.frame.size.width, soldCount.frame.size.height);
        
        return;
    }
    
    ///如果图片地址有效，则显示图片
    UIImageView *imageView = objc_getAssociatedObject(self, &foodImageKey);
    UILabel *commentLabel = objc_getAssociatedObject(self, &InstructionKey);
    UILabel *soldCount = objc_getAssociatedObject(self, &SoldCountKey);
    [imageView roundView];
    
    ///判断是否已移动过，移动过则更新图片即可
    if (imageView.frame.size.width >= 59.0f) {
        
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"default_file_super_url"],imageUrl]] placeholderImage:nil];
        
        return;
    }
    
    ///加载图片
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 60.0f, 60.0f);
    [imageView roundView];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"default_file_super_url"],imageUrl]] placeholderImage:nil];
    
    //将说明信息压缩
    commentLabel.frame = CGRectMake(commentLabel.frame.origin.x+75.0f, commentLabel.frame.origin.y, commentLabel.frame.size.width-75.0f, commentLabel.frame.size.height);
    
    ///已售或者活动日期，移动
    soldCount.frame = CGRectMake(soldCount.frame.origin.x+75.0f, soldCount.frame.origin.y, soldCount.frame.size.width, soldCount.frame.size.height);

}

/**
 *  @author     yangshengmeng, 14-12-14 18:12:47
 *
 *  @brief      重置说明栏的宽度：YES-左右只留10.0f间隙，NO-左10.0f,右150.0f
 *
 *  @param flag 是否需要变宽
 *
 *  @since      2.0
 */
- (void)resetcommentLabelWidth:(BOOL)flag
{
    
    return;
    
#if 0
    UILabel *commentLabel = objc_getAssociatedObject(self, &InstructionKey);
    
    ///当前宽度
    CGFloat maxWidh = commentLabel.superview.frame.size.width - 20.0f;
    
    ///如果没变宽，则变宽
    if (flag) {
        
        ///是真，则变为最大宽度
        commentLabel.frame = CGRectMake(10.0f, commentLabel.frame.origin.y, maxWidh, commentLabel.frame.size.height);
        
    } else {
        
        ///修正为原格式
        commentLabel.frame = CGRectMake(10.0f, commentLabel.frame.origin.y, maxWidh-130.0f, commentLabel.frame.size.height);
        
    }
#endif
    
}

//********************************
//             刷新优惠卷基本信息UI
//********************************
#pragma mark - 刷新优惠卷基本信息UI
- (void)updatePrepaidCardCellUI:(QSMarCouponDetailDataModel *)cellModel
{
    ///更新类型图标
    [self updateCouponTypeImage:[self getCouponTypeImageName:cellModel.couponType andSubType:cellModel.couponSubType]];
    
    ///更新优惠券说明
    if ([cellModel.couponType isEqualToString:@"5"]) {
        
        ///储值卡显示名称
        [self updateCouponComment:cellModel.couponName];
        
    } else {
        
        ///如果是优惠券或者促俏，则显示说明
        [self updateCouponComment:cellModel.des];
        
    }
    
    ///更新活动结束日期
    [self updateLimitedDate:[self limitedDateStringFormat:cellModel]];
    
    //获取优惠券类型代码
    MYLUNCHBOX_COUPON_TYPE couponCode = [self formatCouponTypeWithType:cellModel.couponType andSubType:cellModel.couponSubType];
    
    /**
     *  根据优惠券类型,添加不同的折扣/价钱/菜品显示图标
     */
    [self createDifferentInfoSubviewsWithCouponType:couponCode andModel:cellModel];

}

/**
 *  @author yangshengmeng, 14-12-11 13:12:55
 *
 *  @brief  更新截止日期
 *
 *  @param  dateString 日期
 *
 *  @since  2.0
 */
- (void)updateLimitedDate:(NSString *)dateString
{
    if (dateString) {
        
        UILabel *dateLabel = objc_getAssociatedObject(self, &SoldCountKey);
        
        if (dateLabel) {
            dateLabel.text = dateString;
        }
        
    }
}

/**
 *  @author yangshengmeng, 14-12-11 14:12:34
 *
 *  @brief  根据优惠券类型返回不同的日期说明：储值卡显示已售出的数量
 *
 *  @param  cellModel 优惠卡数据模型
 *
 *  @return 返回需要显示的信息
 *
 *  @since  2.0
 */
- (NSString *)limitedDateStringFormat:(QSMarCouponDetailDataModel *)cellModel
{
    if ([cellModel.couponType isEqualToString:@"5"]) {
        return [NSString stringWithFormat:@"已售%d份",[cellModel.sumNumOfCoupon intValue]-[cellModel.leftNumOfCoupon intValue]];
    }
    
    return [NSString stringWithFormat:@"有效期至：%@",[NSDate formatIntegerIntervalToDateString:cellModel.lastTime]];
}

/**
 *  @author yangshengmeng, 14-12-11 13:12:58
 *
 *  @brief  更新优惠券说明
 *
 *  @param  des 说明信息
 *
 *  @since  2.0
 */
- (void)updateCouponComment:(NSString *)des
{
    if (des) {
        UILabel *desLabel = objc_getAssociatedObject(self, &InstructionKey);
        desLabel.text = des;
    }
}

/**
 *  @author yangshengmeng, 14-12-11 11:12:00
 *
 *  @brief  根据给定的图片名更新优惠类型图标
 *
 *  @param  imageName 图片名
 *
 *  @since  2.0
 */
- (void)updateCouponTypeImage:(NSString *)imageName
{
    
    UIImageView *typeImage = objc_getAssociatedObject(self, &VolumeTypeImageKey);
    typeImage.image = [UIImage imageNamed:imageName];

}

/**
 *  @author yangshengmeng, 14-12-11 11:12:29
 *
 *  @brief  根据不同的优惠类型返回不同的类型图标
 *
 *  @param  bigType 2：保销优惠   3：优惠券   5：储值卡
 *  @param  subType 促销优惠：1 限时优惠 2 菜品优惠  3 vip优惠
                    促销优惠：1 代金卷   2 折扣卷   3 菜品兑换券
 *
 *  @return 返回对应类型的图标：只有促销和优惠券有图标，其他无图标
 *
 *  @since  2.0
 */
- (NSString *)getCouponTypeImageName:(NSString *)bigType andSubType:(NSString *)subType
{
    
    ///判断是否促销优惠
    if ([bigType isEqualToString:@"2"]) {
        
        //是否限时优惠
        if ([subType isEqualToString:@"1"]) {
            return @"saletype_logo_limitedtime";
        }
        
        //是否菜品优惠
        if ([subType isEqualToString:@"2"]) {
            return @"saletype_logo_foodtype";
        }
        
        //是否vip优惠
        if ([subType isEqualToString:@"3"]) {
            return @"saletype_logo_vip";
        }
        
    }
    
    ///是否优惠券
    if ([bigType isEqualToString:@"3"]) {
        
        //是否代金卷
        if ([subType isEqualToString:@"1"]) {
            return @"saletype_logo_voucher";
        }
        
        //是否折扣卷
        if ([subType isEqualToString:@"2"]) {
            return @"saletype_logo_discount";
        }
        
        //是否菜品兑换券
        if ([subType isEqualToString:@"3"]) {
            return @"saletype_logo_exchangefood";
        }
        
    }
    
    return nil;
}

/**
 *  @author yangshengmeng, 14-12-11 15:12:30
 *
 *  @brief  根据不同的优惠券类型添加不同的信息展示view
 *
 *  @param couponType 优惠券类型
 *  @param dataModel  数据源
 *
 *  @since 2.0
 */
#pragma mark - 根据不同的优惠券类型添加不同的信息展示view
- (void)createDifferentInfoSubviewsWithCouponType:(MYLUNCHBOX_COUPON_TYPE)couponType andModel:(QSMarCouponDetailDataModel *)dataModel
{
    switch (couponType) {
            
            ///储值卡
        case PREPAIDCARD_MCT:
        {
            ///重置说明label的尺寸
            [self resetcommentLabelWidth:NO];
            
            ///创建储值卡特有的UI
            [self createPrepaidCardPriceInfo:dataModel.prepaidCardValuePrice andSalePrice:dataModel.prepaidCardBuyPrice];
            
            ///去除菜品图片
            [self resetFoodImageWithImageUrlString:nil];
        }
            break;
            
            ///折扣券
        case FASTENING_VOLUME_MCT:
        {
            ///重置说明label的尺寸
            [self resetcommentLabelWidth:NO];
            
            [self createDiscountInfoUI:dataModel.foodOfferDiscount];
            [self resetFoodImageWithImageUrlString:nil];
        }
            break;
            
            ///菜品兑换券
        case EXCHANGE_VOLUME_MCT:
        {
            ///重置说明label的尺寸
            [self resetcommentLabelWidth:YES];
            
            [self getRightTipsInfoRootView];
            [self resetFoodImageWithImageUrlString:dataModel.foodImage];
        }
            break;
            
            ///代金券
        case VOUCHER_MCT:
        {
            ///重置说明label的尺寸
            [self resetcommentLabelWidth:NO];
            
            [self createVoucherCouponUIWithPrice:dataModel.coucherValue];
            [self resetFoodImageWithImageUrlString:nil];
        }
            break;
            
            ///限时优惠
        case TIMELIMITEDOFF_MCT:
        {
            ///重置说明label的尺寸
            [self resetcommentLabelWidth:NO];
            
            [self createDiscountInfoUI:dataModel.limitedTimeDiscount];
            [self resetFoodImageWithImageUrlString:nil];
        }
            break;
            
            ///菜品优惠
        case FOODOFF_MCT:
        {
            ///重置说明label的尺寸
            [self resetcommentLabelWidth:NO];
            
            [self createDiscountInfoUI:dataModel.foodOfferDiscount];
            [self resetFoodImageWithImageUrlString:dataModel.foodImage];
        }
            break;
            
            ///会员优惠
        case MEMBERDISCOUNT_MCT:
        {
            ///重置说明label的尺寸
            [self resetcommentLabelWidth:NO];
            
            [self createDiscountInfoUI:dataModel.vipDiscount];
            [self resetFoodImageWithImageUrlString:nil];
        }
            break;
            
        default:
            ///重置说明label的尺寸
            [self resetcommentLabelWidth:NO];
            [self resetFoodImageWithImageUrlString:nil];
            break;
    }
}

/**
 *  @author yangshengmeng, 14-12-11 15:12:24
 *
 *  @brief  根据优惠券大小类，格式化为代码定义的优惠券类型并返回类型编码
 *
 *  @param  bigType 优惠券类型
 *  @param  subType 优惠类小类
 *
 *  @return 返回编码实现中的优惠券编码
 *
 *  @since  2.0
 */
#pragma mark - 将服务端返回的优惠券类型转为类型代码
- (MYLUNCHBOX_COUPON_TYPE)formatCouponTypeWithType:(NSString *)bigType andSubType:(NSString *)subType
{
    ///返回储值卡类型
    if ([bigType isEqualToString:@"5"]) {
        return PREPAIDCARD_MCT;
    }
    
    ///判断是否促销优惠
    if ([bigType isEqualToString:@"2"]) {
        
        //是否限时优惠
        if ([subType isEqualToString:@"1"]) {
            return TIMELIMITEDOFF_MCT;
        }
        
        //是否菜品优惠
        if ([subType isEqualToString:@"2"]) {
            return FOODOFF_MCT;
        }
        
        //是否vip优惠
        if ([subType isEqualToString:@"3"]) {
            return MEMBERDISCOUNT_MCT;
        }
        
    }
    
    ///是否优惠券
    if ([bigType isEqualToString:@"3"]) {
        
        //是否代金卷
        if ([subType isEqualToString:@"1"]) {
            return VOUCHER_MCT;
        }
        
        //是否折扣卷
        if ([subType isEqualToString:@"2"]) {
            return FASTENING_VOLUME_MCT;
        }
        
        //是否菜品兑换券
        if ([subType isEqualToString:@"3"]) {
            return EXCHANGE_VOLUME_MCT;
        }
        
    }
    
    ///返回默认类型
    return DEFAULT_MCT;
}

@end
