//
//  QSYTalkInfoTableViewCell.m
//  Eating
//
//  Created by ysmeng on 14/12/26.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSYTalkInfoTableViewCell.h"
#import "QSImageView.h"
#import "QSConfig.h"
#import "UIView+UI.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Name.h"
#import "NSDate+QSDateFormatt.h"
#import "QSAPIModel+FoodGroud.h"

#import <objc/runtime.h>

///关联
static char UserIconKey;//!<用户头像
static char UserNameKey;//!<用户名
static char SendTimeKey;//!<发送时间
static char MessageKey;//!<聊天信息

@implementation QSYTalkInfoTableViewCell

#pragma mark - 初始化
///初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///搭建UI
        [self createTalkInfoUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createTalkInfoUI
{

    ///头像
    QSImageView *iconView = [[QSImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, 6.0f, 45.0f, 45.0f)];
    [iconView roundView];
    iconView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:iconView];
    objc_setAssociatedObject(self, &UserIconKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    ///用户名字
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width+10.0f, 5.0f, 160.0f, 20.0f)];
    userNameLabel.text = @"李坤锭";
    userNameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    userNameLabel.textColor = kBaseGrayColor;
    [self.contentView addSubview:userNameLabel];
    objc_setAssociatedObject(self, &UserNameKey, userNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///消息发送时间
    UILabel *sendTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth-130.0f, userNameLabel.frame.origin.y+2.5f, 120.0f, 15.0f)];
    sendTimeLabel.text = @"2014-12-26 12:21";
    sendTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    sendTimeLabel.textColor = kBaseLightGrayColor;
    [self.contentView addSubview:sendTimeLabel];
    objc_setAssociatedObject(self, &SendTimeKey, sendTimeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///信息框
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x, userNameLabel.frame.size.height+userNameLabel.frame.origin.y+5.0f, DeviceWidth-userNameLabel.frame.origin.x-10.0f, 40.0f)];
    msgLabel.numberOfLines = 2;
    msgLabel.font = [UIFont systemFontOfSize:14.0f];
    msgLabel.text = @"大家是几点集合的？我可能要迟一点，我们先到先吃吧。";
    msgLabel.textColor = kBaseLightGrayColor;
    [self.contentView addSubview:msgLabel];
    objc_setAssociatedObject(self, &MessageKey, msgLabel, OBJC_ASSOCIATION_ASSIGN);
    
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 74.5f, DeviceWidth, 0.5f)];
    sepLabel.backgroundColor = kBaseLightGrayColor;
    sepLabel.alpha = 0.5f;
    [self.contentView addSubview:sepLabel];

}

/**
 *  @author             yangshengmeng, 14-12-26 10:12:05
 *
 *  @brief              根据信息数据模型，更新cell
 *
 *  @param infoModel    服务端返回的聊天信息数据模型
 *
 *  @since              2.0
 */
#pragma mark - 刷新UI
- (void)updateTalkInfoCellUIWithModel:(QSFoodGroudTalkMessageDataModel *)infoModel
{

    ///更新用户名
    [self updateUserName:infoModel.userName];
    
    ///更新聊天信息
    [self updateTalkMessage:infoModel.message];
    
    ///更新时间
    [self updateMessageSendTime:infoModel.sendTime];
    
    ///更新用户头像
    [self updateUserIcon:infoModel.userLogo];

}

///更新消息时间
- (void)updateMessageSendTime:(NSString *)time
{

    UILabel *label = objc_getAssociatedObject(self, &SendTimeKey);
    if (label && time) {
        
        label.text = [NSDate formatIntegerIntervalToTime_YYMMDD_HHMM:time];
        
    }

}

///更新聊天信息
- (void)updateTalkMessage:(NSString *)msg
{

    UILabel *label = objc_getAssociatedObject(self, &MessageKey);
    if (label && msg) {
        
        label.text = msg;
        
    }

}

///更新用户头像
- (void)updateUserIcon:(NSString *)urlString
{

    UIImageView *iconView = objc_getAssociatedObject(self, &UserIconKey);
    if (iconView && urlString) {
        
        [iconView setImageWithURL:[NSURL URLWithString:[urlString imageUrl]] placeholderImage:nil];
        
    }

}

///更新用户名
- (void)updateUserName:(NSString *)userName
{

    UILabel *label = objc_getAssociatedObject(self, &UserNameKey);
    if (label && userName) {
        
        label.text = userName;
        
    }

}

@end
