//
//  QSFoodGroudMembersTableViewCell.h
//  Eating
//
//  Created by ysmeng on 14/12/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSFoodGroudMembersDataModel;
@interface QSFoodGroudMembersTableViewCell : UITableViewCell

/**
 *  @author                 yangshengmeng, 14-12-24 14:12:24
 *
 *  @brief                  添加回调的初始化方法
 *
 *  @param style            cell的风格，用系统风格
 *  @param reuseIdentifier  复用标识
 *  @param callBack         回调block
 *
 *  @return                 返回当前创建的cell
 *
 *  @since                  2.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCallBack:(void(^)(NSDictionary *params))callBack;

/**
 *  @author         yangshengmeng, 14-12-24 14:12:01
 *
 *  @brief          根据用户数据模型，更新每个团成员的基本信息
 *
 *  @param model    数据模型
 *
 *  @since          2.0
 */
- (void)updateFoodGroudMembersCellUI:(QSFoodGroudMembersDataModel *)model;

@property (nonatomic,copy) void(^callBack)(NSDictionary *params);//!<回调

@end
