//
//  QSFoodGroudMembersTableViewCell.m
//  Eating
//
//  Created by ysmeng on 14/12/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodGroudMembersTableViewCell.h"
#import "UIView+UI.h"
#import "QSImageView.h"
#import "QSConfig.h"
#import "QSBlockActionButton.h"
#import "QSAPIModel+FoodGroud.h"
#import "UIImageView+AFNetworking.h"

#import <objc/runtime.h>

///关联
static char MemberIconKey;//!<成员logo
static char RemarkStarLevelKey;//!<星星的等级限制
static char RemarkScoreKey;//!<评分

static char MemberNameKey;//!<用户名

@implementation QSFoodGroudMembersTableViewCell

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
#pragma mark - 添加回调的初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCallBack:(void(^)(NSDictionary *params))callBack
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///创建UI
        [self createFoodGroudMembersListCellUI];
        
        ///保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
    }
    
    return self;

}

- (void)createFoodGroudMembersListCellUI
{

    ///头像
    QSImageView *iconView = [[QSImageView alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 50.0f, 50.0f)];
    [iconView roundView];
    iconView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:iconView];
    objc_setAssociatedObject(self, &MemberIconKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    ///成员名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width+10.0f, iconView.frame.origin.y+10.0f, 240.0f, 20.0f)];
    nameLabel.text = @"下午么么茶";
    nameLabel.font = [UIFont systemFontOfSize:16.0f];
    nameLabel.textColor = kBaseGrayColor;
    [self.contentView addSubview:nameLabel];
    objc_setAssociatedObject(self, &MemberNameKey, nameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///白星星
    QSImageView *starWhiteView = [[QSImageView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+5.0f, 50.0f, 10.0f)];
    starWhiteView.image = [UIImage imageNamed:@"fooddetective_freefoodstore_star_normal"];
    [self.contentView addSubview:starWhiteView];
    
    ///黄星星的底view
    UIView *yellowStarRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, starWhiteView.frame.size.width, starWhiteView.frame.size.height)];
    [starWhiteView addSubview:yellowStarRootView];
    objc_setAssociatedObject(self, &RemarkStarLevelKey, yellowStarRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///黄星星:fooddetective_freefoodstore_star_highlighted
    QSImageView *starYellowView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 10.0f)];
    starYellowView.image = [UIImage imageNamed:@"fooddetective_freefoodstore_star_highlighted"];
    [yellowStarRootView addSubview:starYellowView];
    
    ///评分文字label
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(starWhiteView.frame.origin.x+starWhiteView.frame.size.width+5.0f, starWhiteView.frame.origin.y, 60.0f, 15.0f)];
    scoreLabel.text = @"4.0分";
    scoreLabel.textColor = kBaseOrangeColor;
    scoreLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:scoreLabel];
    objc_setAssociatedObject(self, &RemarkScoreKey, scoreLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///聊天图标:
    UIButton *talkButton = [UIButton createBlockActionButton:CGRectMake(DeviceWidth-MARGIN_LEFT_RIGHT-50.0f, 30.0f, 30.0f, 30.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///点击聊天按钮
        
    }];
    [talkButton setImage:[UIImage imageNamed:@"foodgroud_detail_talk_normal"] forState:UIControlStateNormal];
    [talkButton setImage:[UIImage imageNamed:@"foodgroud_detail_talk_highlighted"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:talkButton];
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 89.0f, DEFAULT_MAX_WIDTH, 1.0f)];
    sepLabel.backgroundColor = kBaseLightGrayColor;
    sepLabel.alpha = 0.5f;
    [self.contentView addSubview:sepLabel];

}

/**
 *  @author         yangshengmeng, 14-12-24 14:12:01
 *
 *  @brief          根据用户数据模型，更新每个团成员的基本信息
 *
 *  @param model    数据模型
 *
 *  @since          2.0
 */
#pragma mark - 按数据模型更新UI
- (void)updateFoodGroudMembersCellUI:(QSFoodGroudMembersDataModel *)model
{

    ///更新用户名
    [self updateMembersName:model.userName];
    
    ///更新用户头像
    [self updateUserIcon:model.userIcon];
    
}

///更新用户头像
- (void)updateUserIcon:(NSString *)urlString
{

    UIImageView *iconView = objc_getAssociatedObject(self, &MemberIconKey);
    if (iconView && urlString) {
        
        [iconView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
        
    }

}

///更新用户名
- (void)updateMembersName:(NSString *)name
{

    UILabel *userNameLabel = objc_getAssociatedObject(self, &MemberNameKey);
    if (userNameLabel && name) {
        userNameLabel.text = name;
    }
    
}

@end
