//
//  QSMyTaskTableViewCell.m
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMyTaskTableViewCell.h"
#import "QSAPIModel+MyTask.h"
#import "QSImageView.h"
#import "UIView+UI.h"
#import "QSConfig.h"
#import "QSBlockActionButton.h"
#import "QSAPI.h"
#import "QSAPIModel+MyTask.h"

#import <objc/runtime.h>

//关联
static char MarIconKey;
static char MarNameKey;
static char DistanceInfoKey;
static char ScoreLabelKey;
static char ActivitiesTimeKey;
static char StarLevelRootView;
@implementation QSMyTaskTableViewCell

//*******************************
//             初始化/UI搭建
//*******************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建UI
        [self createFreeActivityCellUI];
        
        //背景颜色
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

//创建UI
- (void)createFreeActivityCellUI
{
    //信息展示底view
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 25.0f, DeviceWidth-20.0f, 95.0f)];
    [infoView roundCornerRadius:8.0f];
    infoView.backgroundColor = [UIColor whiteColor];
    [self createInfoSubViews:infoView];
    [self.contentView addSubview:infoView];
    
    //icon视图:110
    QSImageView *iconAboveView = [[QSImageView alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 57.0f, 57.0f)];
    [iconAboveView roundView];
    iconAboveView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:iconAboveView];
    
    QSImageView *iconView = [[QSImageView alloc] initWithFrame:CGRectMake(2.5f, 2.50f, 52.0f, 52.0f)];
    [iconView roundView];
    [iconAboveView addSubview:iconView];
    //    iconView.backgroundColor = [UIColor orangeColor];
    objc_setAssociatedObject(self, &MarIconKey, iconView, OBJC_ASSOCIATION_ASSIGN);
}

//添加主展示信息视图
- (void)createInfoSubViews:(UIView *)view
{
    //85.0f
    
    //mar name label
    UILabel *marName = [[UILabel alloc] initWithFrame:CGRectMake(77.0f, 10.0f, 120.0f, 20.0f)];
    marName.text = @"星巴克";
    marName.font = [UIFont boldSystemFontOfSize:16.0f];
    marName.textAlignment = NSTextAlignmentLeft;
    marName.textColor = kBaseGrayColor;
    [view addSubview:marName];
    objc_setAssociatedObject(self, &MarNameKey, marName, OBJC_ASSOCIATION_ASSIGN);
    
    //距离
    QSImageView *distanceView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width-58.0f, 12.0f, 10.0f, 15.0f)];
    distanceView.image = [UIImage imageNamed:@"fooddetective_add_local_normal"];
    [view addSubview:distanceView];
    
    //距离label
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-45.0f, 15.0f, 40.0f, 15.0f)];
    distanceLabel.text = @"150m";
    distanceLabel.font = [UIFont systemFontOfSize:12.0f];
    distanceLabel.textAlignment = NSTextAlignmentLeft;
    distanceLabel.textColor = kBaseLightGrayColor;
    [view addSubview:distanceLabel];
    objc_setAssociatedObject(self, &DistanceInfoKey, distanceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //星星
    UIImageView *startView = [[UIImageView alloc] initWithFrame:CGRectMake(77.0f, 35.0f, 16.0f*5, 13.0f)];
    [view addSubview:startView];
    startView.image = [UIImage imageNamed:@"fooddetective_freefoodstore_star_normal"];
    
    //黄色星星的底view
    UIView *scoreStarRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, startView.frame.size.width, startView.frame.size.height)];
    [startView addSubview:scoreStarRootView];
    scoreStarRootView.clipsToBounds = YES;
    objc_setAssociatedObject(self, &StarLevelRootView, scoreStarRootView, OBJC_ASSOCIATION_ASSIGN);
    
    //黄色星星view
    UIImageView *scoreStarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, startView.frame.size.width, startView.frame.size.height)];
    [scoreStarRootView addSubview:scoreStarView];
    scoreStarView.image = [UIImage imageNamed:@"fooddetective_freefoodstore_star_highlighted"];
    
    //评分
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(77.0f+85.0f, 35.0f, 40.0f, 16.0f)];
    scoreLabel.text = @"4.0分";
    scoreLabel.font = [UIFont systemFontOfSize:12.0f];
    scoreLabel.textAlignment = NSTextAlignmentLeft;
    scoreLabel.textColor = kBaseOrangeColor;
    [view addSubview:scoreLabel];
    objc_setAssociatedObject(self, &ScoreLabelKey, scoreLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 59.5f, view.frame.size.width-15.0f, 1.0f)];
    sepLabel.backgroundColor = kBaseLightGrayColor;
    [view addSubview:sepLabel];
    
    //活动倒计时图标
    QSImageView *timeLogo = [[QSImageView alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height-25.0f, 15.0f, 15.0f)];
    timeLogo.image = [UIImage imageNamed:@"fooddetective_activitieslist_lefttime"];
    [view addSubview:timeLogo];
    
    //活动时间
    UILabel *actTime = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, view.frame.size.height-25.0f, 160.0f, 15.0f)];
    actTime.text = @"2014-05-10至2014-12-31";
    actTime.font = [UIFont systemFontOfSize:12.0f];
    actTime.textAlignment = NSTextAlignmentLeft;
    actTime.textColor = kBaseLightGrayColor;
    [view addSubview:actTime];
    objc_setAssociatedObject(self, &ActivitiesTimeKey, actTime, OBJC_ASSOCIATION_ASSIGN);
    
    //状态
    UIButton *signButton = [UIButton createBlockActionButton:CGRectMake(view.frame.size.width-90.0f, view.frame.size.height-25.0f, 80.0f, 15.0f) andStyle:[QSButtonStyleModel createFreeActivitiesSignUpButtonStyle] andCallBack:^(UIButton *button) {
        
    }];
    [view addSubview:signButton];
}

//*******************************
//             刷新UI
//*******************************
#pragma mark - 刷新UI
- (void)updateMyTaskCellUIWithModel:(QSMyTaskDataModel *)model
{
#if 0
    //更新活动店铺图片
    [self updateFreeMarIcon:model.marLogo];
    
    //更新店铺名
    [self updateFreeMarName:[self formatMarName:model.marName andNickName:model.marNickName]];
    
    //更新距离
//    [self updateFreeMarDistance:model.marLatitude];
    
    //更新星星的显示
    [self updateStartLevelImage:[model.marScore floatValue]];
    
    //更新评分
    [self updateFreemarScore:model.marScore];
    
    //更新活动日期
    [self updateFreeActivityTime:[self formateActivitiesDate:model.startTime andEndDate:model.endTime]];
    
    //更新状态
    [self updateFreeActivityStatus:model.currentUserStatu];
#endif
}

//更新活动店铺图片
- (void)updateFreeMarIcon:(NSString *)iconName
{
    if (iconName) {
        UIImageView *iconView = objc_getAssociatedObject(self, &MarIconKey);
        iconView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"default_file_super_url"],iconName]]]];
    }
}

//更新店铺名称
- (void)updateFreeMarName:(NSString *)marName
{
    if (marName) {
        UILabel *name = objc_getAssociatedObject(self, &MarNameKey);
        name.text = marName;
    }
}

//封装店名
- (NSString *)formatMarName:(NSString *)longName andNickName:(NSString *)nickName
{
    if (nickName) {
        return nickName;
    }
    
    return longName;
}

//更新店铺距离
- (void)updateFreeMarDistance:(NSString *)dis
{
    if (dis) {
        UILabel *info = objc_getAssociatedObject(self, &DistanceInfoKey);
        info.text = [NSString stringWithFormat:@"%@m",dis];
    }
}

//更新星星显示
- (void)updateStartLevelImage:(CGFloat)startLevel
{
    CGFloat level = startLevel / 10.0f;
    UIView *view = objc_getAssociatedObject(self, &StarLevelRootView);
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width * level, view.frame.size.height);
}

//更新评分
- (void)updateFreemarScore:(NSString *)score
{
    if (score) {
        UILabel *scoreLabel = objc_getAssociatedObject(self, &ScoreLabelKey);
        scoreLabel.text = [NSString stringWithFormat:@"%@分",score];
    }
}

//更新活动日期
- (void)updateFreeActivityTime:(NSString *)timeString
{
    if (timeString) {
        UILabel *dateLabel = objc_getAssociatedObject(self, &ActivitiesTimeKey);
        dateLabel.text = timeString;
    }
}

//活动时间转换
- (NSString *)formateActivitiesDate:(NSString *)startDate andEndDate:(NSString *)endDate
{
    if (startDate == nil || endDate == nil) {
        return  nil;
    }
    
    //转换为有效日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromStartDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[startDate intValue]];
    NSString *startDateString = [formatter stringFromDate:confromStartDate];
    NSDate *confromEndDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[startDate intValue]];
    NSString *endDateString = [formatter stringFromDate:confromEndDate];
    
    return [NSString stringWithFormat:@"%@至%@",startDateString,endDateString];
}

//更新活动状态
- (void)updateFreeActivityStatus:(NSString *)statu
{
    if (statu) {
        
    }
}

@end
