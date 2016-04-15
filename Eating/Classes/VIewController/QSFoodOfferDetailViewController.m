//
//  QSFoodOfferDetailViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/16.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodOfferDetailViewController.h"
#import "QSYFoodDiscountFoodImageTableViewCell.h"
#import "NSString+Name.h"
#import "MJRefresh.h"
#import "QSAPIClientBase+CouponDetail.h"

#import <objc/runtime.h>

///关联
static char FoodDiscountListKey;//!<列表关联

@interface QSFoodOfferDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{

    NSString *_couponID;                    //!<菜品优惠的ID
    
    MYLUNCHBOX_COUPON_TYPE _couponType;     //!<优惠券类型：默认菜品
    
    MYLUNCHBOX_COUPON_STATUS _couponStatus; //!<菜品状态
    
    NSString *_discountTitle;               //!<标题
    
    NSString *_commentInfo;                 //!<优惠说明信息
    
    NSString *_discount;                    //!<当前的折扣
    NSMutableArray *_foodImageList;         //!<每个菜品优惠信息的数组
    
}

@end

@implementation QSFoodOfferDetailViewController

/**
 *  @author wangshupeng, 14-12-27 10:12:50
 *
 *  @brief  根据菜品优惠券的ID创建一个菜品详情页面
 *
 *  @return 返回当前页面
 *
 *  @since  2.0
 */
#pragma mark - 初始化
- (instancetype)initWithCouponID:(NSString *)couponID andCouponType:(MYLUNCHBOX_COUPON_TYPE)couponType andCouponStatus:(MYLUNCHBOX_COUPON_STATUS)couponStatus
{

    if (self = [super init]) {
        
        ///保存菜品优惠的信息
        _couponID = [couponID copy];
        
        _couponType = couponType;
        
        _couponStatus = couponStatus;
        
        ///初始化数据源
        _foodImageList = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

///重写导航栏，添加标题
- (void)createNavigationBar
{
    
    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"优惠详情"];
    
}

- (void)createMainShowView
{

    [super createMainShowView];
    
    ///菜品优惠的列表
    UITableView *foodDiscountList = [[UITableView alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, 90.0f, DEFAULT_MAX_WIDTH, DeviceHeight-90.0f) style:UITableViewStyleGrouped];
    
    ///取消滚动条
    foodDiscountList.showsHorizontalScrollIndicator = NO;
    foodDiscountList.showsVerticalScrollIndicator = NO;
    
    ///数据源/代理
    foodDiscountList.dataSource = self;
    foodDiscountList.delegate = self;
    
    ///取消分隔状态
    foodDiscountList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///取消背景颜色
    foodDiscountList.backgroundColor = [UIColor clearColor];
    
    ///添加头部刷新
    [foodDiscountList addHeaderWithTarget:self action:@selector(requestFoodOfferDetailInfo)];
    [foodDiscountList headerBeginRefreshing];
    
    ///加载
    [self.view addSubview:foodDiscountList];
    [self.view sendSubviewToBack:foodDiscountList];
    
    objc_setAssociatedObject(self, &FoodDiscountListKey, foodDiscountList, OBJC_ASSOCIATION_ASSIGN);

}

/**
 *  @author wangshupeng, 14-12-27 11:12:22
 *
 *  @brief  请求优惠的详情信息
 *
 *  @since  2.0
 */
#pragma mark - 发起详情信息的网络请求
- (void)requestFoodOfferDetailInfo
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.22 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///封装参数
        NSDictionary *params = @{@"id":_couponID,@"type":[NSString stringWithFormat:@"%d",_couponType]};
        
        ///延迟0.22秒后再请求网络
        [[QSAPIClientBase sharedClient] getCouponDetailWithID:params andCallBack:^(BOOL requestFlag, QSYCouponDetailDataModel *model, NSString *errorInfo, NSString *errorCode) {
            
            ///返回成功
            if (requestFlag) {
                
                ///清空原数据
                [_foodImageList removeAllObjects];
                
                ///添加新的数据
                [_foodImageList addObjectsFromArray:model.foodImageList];
                
                ///保存大标题
                _discountTitle = model.couponName;
                
                ///保存说明信息
                _commentInfo = model.des;
                
                ///保存折扣
                _discount = model.foodOfferDiscount;
                
                ///刷新数据
                [[self getFoodDiscountList] reloadData];
                
                ///结束刷新动画
                [[self getFoodDiscountList] headerEndRefreshing];
                
                return;
                
            }
            
            ///请求失败
            [self showTip:self.view tipStr:@"菜品详情获取失败"];
            
            ///结束刷新动画
            [[self getFoodDiscountList] headerEndRefreshing];
            
            ///返回列表
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
    });

}

///返回当前的优惠列表，运用运行时机制，tableview数据在内存中临时保存与取出
- (UITableView *)getFoodDiscountList
{

    return objc_getAssociatedObject(self, &FoodDiscountListKey);

}

/**
 *  @author             wangshupeng, 14-12-27 10:12:15
 *
 *  @brief              返回每个菜品的优惠信息view-cell
 *
 *  @param tableView    每个菜品优惠信息所在的列表
 *  @param indexPath    当前的坐标
 *
 *  @return             返回每个菜品的优惠信息view-cell
 *
 *  @since              2.0
 */
#pragma mark - 返回每个菜品优惠的信息cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellName = @"normalCell";
    QSYFoodDiscountFoodImageTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (nil == myCell) {
        myCell = [[QSYFoodDiscountFoodImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    ///取消选择时的状态
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///刷新UI
    [myCell updateFoodImageInfoWithModel:_foodImageList[indexPath.row] andDiscount:_discount];
    
    return myCell;

}

///返回有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_foodImageList count];
    
}
///返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///约束
    CGFloat tempHeight =  DeviceHeight <= 568.0f ? 160.0f : (160.0f * (DeviceWidth - 2 * MARGIN_LEFT_RIGHT) / 300.0f);
    CGFloat height = tempHeight + 10.0f;
    return height;

}

///返回菜品优惠的标题栏
#pragma mark - 返回菜品优惠tabbleview头部的标题栏
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerName = @"normalHeader";
    
    UILabel *titleLabel = [tableView dequeueReusableCellWithIdentifier:headerName];
    if (nil == titleLabel) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f,DEFAULT_MAX_WIDTH, 20.0f)];
        
    }
    
    ///设置标题格式
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = kBaseGrayColor;
    
    ///设置标题信息
    titleLabel.text = _discountTitle ? _discountTitle : @"暂无";
    
    return titleLabel;

}

#pragma mark--设置列表头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 30.0f;

}

///返回列表脚view
#pragma mark - 返回列表脚view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
    static NSString *footerName = @"normalHeader";
    
    UILabel *commentView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerName];
    CGFloat width = DEFAULT_MAX_WIDTH;
    if (nil == commentView) {
        
        commentView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, width, 20.0f)];
        
    }
    
    ///设置标题格式
    commentView.font = [UIFont boldSystemFontOfSize:12.0f];
    commentView.textColor = kBaseLightGrayColor;
    commentView.numberOfLines = 0;
    
    ///重新计算高度
    if (_commentInfo) {
        
        ///约束内容自适应屏幕最大宽度，防止越界输入
        CGFloat newHeight = [_commentInfo calculateStringHeightByFixedWidth:width andFontSize:12.0f];
        
        ///重置label的宽度
        commentView.frame = CGRectMake(commentView.frame.origin.x, commentView.frame.origin.y, commentView.frame.size.width, newHeight);
        
    }
    
    ///设置标题信息
    commentView.text = _commentInfo ? _commentInfo : @"暂无";
    
    return commentView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    ///重新计算高度
    CGFloat width = DEFAULT_MAX_WIDTH;
    if (_commentInfo) {
        
        CGFloat newHeight = [_commentInfo calculateStringHeightByFixedWidth:width andFontSize:12.0f];
        
        return newHeight;
        
    }
    
    return 30.0f;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}

@end
