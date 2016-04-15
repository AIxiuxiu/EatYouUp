//
//  QSMyDiaryTableViewCell.m
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMyDiaryTableViewCell.h"
#import "QSImageView.h"
#import "QSConfig.h"
#import "QSAPI.h"
#import "UIView+UI.h"
#import "UIView+QSGraphicView.h"
#import "QSAPIModel+MyDiary.h"

#import <objc/runtime.h>

//关联key
static char FoodDetectiveNormalIconKey;
static char FoodDetectiveNormalUserNameKey;
static char FoodDetectiveNormalMarNameKey;
static char FoodDetectiveNormalTimeKey;
static char FoodDetectiveNormalReadCountKey;
static char FoodDetectiveNormalCollectCountKey;
static char FoodDetectiveNormalImageKey;
@implementation QSMyDiaryTableViewCell

//*******************************
//              初始化/UI搭建
//*******************************
#pragma mark - 初始化/UI搭建
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        //创建UI
        [self createFoodDetectiveNormalUI];
    }
    
    return self;
}

//创建侦探社普通UI
- (void)createFoodDetectiveNormalUI
{
    //头像
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(19.0f, 10.0f, 33.0f, 33.0f)];
    [icon roundView];
    objc_setAssociatedObject(self, &FoodDetectiveNormalIconKey, icon, OBJC_ASSOCIATION_ASSIGN);
    [self.contentView addSubview:icon];
    
    //用户名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(19.0f, 48.0f, 33.0f, 20.0f)];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    objc_setAssociatedObject(self, &FoodDetectiveNormalUserNameKey, nameLabel, OBJC_ASSOCIATION_ASSIGN);
    nameLabel.textColor = kBaseLightGrayColor;
    [self.contentView addSubview:nameLabel];
    
    //计算高度
    CGFloat width = DeviceWidth;
    CGFloat height = 340.0f / 640.0f * width;
    
    //分隔线
    UIView *sepView = [UIView craphicFoodDetectiveNormalSepView:CGRectMake(31.5f, 69.0f, 8.0f, height - 70.0f)];
    [self.contentView addSubview:sepView];
    
    //底view：170
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(71.0f, 10.0f, DeviceWidth - 81.0f, height - 10.0f)];
    rootView.backgroundColor = [UIColor whiteColor];
    rootView.layer.cornerRadius = 16.0f;
    [self.contentView addSubview:rootView];
    [self createFoodMarInfo:rootView];
}

//美食店基本信息
- (void)createFoodMarInfo:(UIView *)view
{
    //160
    
    //店名
    UILabel *marName = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,10.0f,view.frame.size.width*2.0f/3.0f - 10.0f,15.0f)];
    [view addSubview:marName];
    objc_setAssociatedObject(self, &FoodDetectiveNormalMarNameKey, marName, OBJC_ASSOCIATION_ASSIGN);
    marName.textColor = kBaseGrayColor;
    marName.adjustsFontSizeToFitWidth = YES;
    marName.font = [UIFont boldSystemFontOfSize:18.0f];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width*2.0f/3.0f,10.0f,view.frame.size.width/3.0f - 5.0,15.0f)];
    [view addSubview:timeLabel];
    objc_setAssociatedObject(self, &FoodDetectiveNormalTimeKey, timeLabel, OBJC_ASSOCIATION_ASSIGN);
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = kBaseGrayColor;
    
    //已读图标
    QSImageView *readCountImg = [[QSImageView alloc] initWithFrame:CGRectMake(10.0f,32.0f,26.0f,15.0f)];
    readCountImg.image = [UIImage imageNamed:@"fooddetective_read_img"];
    [view addSubview:readCountImg];
    
    //已读次数
    UILabel *readCount = [[UILabel alloc] initWithFrame:CGRectMake(41.0f,32.0f,40.0f,15.0f)];
    [view addSubview:readCount];
    objc_setAssociatedObject(self, &FoodDetectiveNormalReadCountKey, readCount, OBJC_ASSOCIATION_ASSIGN);
    readCount.adjustsFontSizeToFitWidth = YES;
    readCount.textColor = kBaseGrayColor;
    
    //收藏图标
    QSImageView *collectCountImg = [[QSImageView alloc] initWithFrame:CGRectMake(91.0f,32.0f,15.0f,15.0f)];
    collectCountImg.image = [UIImage imageNamed:@"fooddetective_collect_img"];
    [view addSubview:collectCountImg];
    
    //收藏次数
    UILabel *collectCount = [[UILabel alloc] initWithFrame:CGRectMake(111.0f,32.0f,40.0f,15.0f)];
    [view addSubview:collectCount];
    objc_setAssociatedObject(self, &FoodDetectiveNormalCollectCountKey, collectCount, OBJC_ASSOCIATION_ASSIGN);
    collectCount.adjustsFontSizeToFitWidth = YES;
    collectCount.textColor = kBaseGrayColor;
    
    //图片
    QSImageView *imageView = [[QSImageView alloc] initWithFrame:CGRectMake(10.0f,57.0f,view.frame.size.width - 20.0f,view.frame.size.height - 67.0f)];
    objc_setAssociatedObject(self, &FoodDetectiveNormalImageKey, imageView, OBJC_ASSOCIATION_ASSIGN);
    [view addSubview:imageView];
}

//*******************************
//             刷新 UI
//*******************************
#pragma mark - 刷新 UI
//刷新美食侦探社普通cell
- (void)updateMyTaskCellUIWithModel:(QSMyDiaryDataModel *)model
{
    QSMyDiaryDataModel *tempModel = (QSMyDiaryDataModel *)model;
#if 1
    //更新头像
    [self updateUserIcon:tempModel.userIcon];
    
    //更新用户名
    [self updateUserName:tempModel.userName];
    
    //更新分享标题
    [self updateShareTitle:[self formatShareDiaryTitle:model.marName andNickName:model.marNickName]];
    
    //更新修改时间
    if ([tempModel.lastUpdateTime length] > 6) {
        [self updateReaseTime:[self changeTimeWithTimeMedium:tempModel.lastUpdateTime]];
    } else {
        [self updateReaseTime:[self changeTimeWithTimeMedium:tempModel.releaseTime]];
    }
    
    //更新阅读次数
    [self updateReadCount:tempModel.readCount];
    
    //更新喜欢次数
    [self updateCollectCount:tempModel.interestedCount];
    
    //更新店面图片
    if ([tempModel.imageList count] > 0) {
        [self updateMarImage:tempModel.imageList[0]];
    }
#endif
}

//更新头像
- (void)updateUserIcon:(NSString *)imageName
{
    if (nil == imageName) {
        return;
    }
    
    UIImageView *icon = objc_getAssociatedObject(self, &FoodDetectiveNormalIconKey);
    icon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
}

//更新用户名
- (void)updateUserName:(NSString *)name
{
    UILabel *label = objc_getAssociatedObject(self, &FoodDetectiveNormalUserNameKey);
    label.text = name;
}

//更新他享标题
- (void)updateShareTitle:(NSString *)title
{
    if ([title length] > 2) {
        UILabel *titleLabel = objc_getAssociatedObject(self, &FoodDetectiveNormalMarNameKey);
        titleLabel.text = title;
    }
}

//标题格式化
- (NSString *)formatShareDiaryTitle:(NSString *)name andNickName:(NSString *)nickName
{
    if ([nickName length] > 4) {
        return [NSString stringWithFormat:@"%@分享",nickName];
    }
    
    return [NSString stringWithFormat:@"%@分享",name];
}

//更新阅读次数
- (void)updateReadCount:(NSString *)count
{
    UILabel *readCount = objc_getAssociatedObject(self, &FoodDetectiveNormalReadCountKey);
    readCount.text = count;
}

//更新喜欢收藏数
- (void)updateCollectCount:(NSString *)count
{
    UILabel *collectCount = objc_getAssociatedObject(self, &FoodDetectiveNormalCollectCountKey);
    collectCount.text = count;
}

//更新发布时间：如若有最新修改，则显示最新修改时间
- (void)updateReaseTime:(NSString *)timeText
{
    UILabel *timeLabel = objc_getAssociatedObject(self, &FoodDetectiveNormalTimeKey);
    timeLabel.text = [self formatDateInfo:timeText];
}

//日期格式化
- (NSString *)formatDateInfo:(NSString *)dateString
{
    if (dateString == nil || [dateString length] == 0) {
        return @"未知";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *updateDate = [formatter dateFromString:dateString];
    NSDate *now = [NSDate date];
    NSTimeInterval interval = [now timeIntervalSinceDate:updateDate];
    
    //判断时间
    if (interval < 24.0f * 60.0f * 60.0f) {
        return [NSString stringWithFormat:@"今天 %@",
                [dateString substringFromIndex:11]];
    }
    
    if (interval < 2 * 24.0f * 60.0f * 60.0f) {
        return [NSString stringWithFormat:@"昨天 %@",
                [dateString substringFromIndex:11]];
    }
    
    if (interval < 3 * 24.0f * 60.0f * 60.0f) {
        return [NSString stringWithFormat:@"前天 %@",
                [dateString substringFromIndex:11]];
    }
    
    if (interval < 14 * 24.0f * 60.0f * 60.0f) {
        return [NSString stringWithFormat:@"上星期 %@",
                [dateString substringFromIndex:11]];
    }
    
    if (interval < 35.0f * 24.0f * 60.0f * 60.0f) {
        return [NSString stringWithFormat:@"上个月 %@",
                [dateString substringFromIndex:11]];
    }
    
    return [dateString substringFromIndex:5];
}

//将数字日期转化为有效日期
- (NSString *)changeTimeWithTimeMedium:(NSString *)dateTime
{
    //转换为有效日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[dateTime intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

//更新店面图片
- (void)updateMarImage:(QSMyDiaryImageModel *)model
{
    UIImageView *imageView = objc_getAssociatedObject(self, &FoodDetectiveNormalImageKey);
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"default_file_super_url"],model.imageName]]]];
}

@end
