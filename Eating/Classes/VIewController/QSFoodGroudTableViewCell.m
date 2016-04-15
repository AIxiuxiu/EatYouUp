//
//  QSFoodGroudTableViewCell.m
//  Eating
//
//  Created by ysmeng on 14/12/18.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodGroudTableViewCell.h"
#import "QSImageView.h"
#import "QSConfig.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Name.h"
#import "QSYMemberIconlistView.h"
#import "UIView+UI.h"
#import "QSAPIModel+FoodGroud.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"
#import "QSFoodGroudDetailViewController.h"

#import <objc/runtime.h>

///关联
static char BGImageViewKey;//!<背景图片
static char MemberIconListKey;//!<成员头像列表
static char MarIconViewKey;//!<商户头像
static char MarNameKey;//!<商户名称
static char DistanceInfoKey;//!<距离
static char UserIconKey;//!<用头像
static char CommenderNameKey;//!<团长名字
static char TeamTypeKey;//!<AA，团长请客，成员请客
static char TeamAddStatusKey;//!<团的参加情况
static char TeamAddCondiction;//!<参团的基本说明

@interface QSFoodGroudTableViewCell (){

    NSString *_teamLeaderID;//!<搭食团的团长ID
    NSString *_teamID;      //!<搭食团ID
    
    NSString *_merchantName;//!<商户名

}

@end

@implementation QSFoodGroudTableViewCell

/**
 *  @author                 yangshengmeng, 14-12-18 10:12:40
 *
 *  @brief                  得写初始化方法，方便添加自定我的view
 *
 *  @param style            cell的风格
 *  @param reuseIdentifier  复用的key
 *
 *  @return                 返回当前cell
 *
 *  @since                  2.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///创建自定义的信息展示UI
        [self createFoodGroudUI];
        
    }
    
    return self;
    
}

/**
 *  @author yangshengmeng, 14-12-18 10:12:59
 *
 *  @brief  搭建自定义UI的主入口
 *
 *  @since  2.0
 */
- (void)createFoodGroudUI
{

    ///背景图片
    QSImageView *bgImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,DeviceWidth, DeviceHeight-114.0f)];
    [self.contentView addSubview:bgImageView];
    objc_setAssociatedObject(self, &BGImageViewKey, bgImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///在背景view上，添加其他信息
    [self createFoodGroudUI:bgImageView];

}

/**
 *  @author yangshengmeng, 14-12-18 10:12:21
 *
 *  @brief  在背景图片的view上，添加其他信息的UI
 *
 *  @param  bgView 背景图片view
 *
 *  @since  2.0
 */
- (void)createFoodGroudUI:(UIView *)bgView
{
    
    ///团员头像信息
    QSYMemberIconlistView *memberList = [[QSYMemberIconlistView alloc] initWithFrame:CGRectMake(15.0f, 60.0f, bgView.frame.size.width-30.0f, (DeviceWidth >= 375.0f ? 55.0f : 45.0f))];
    [bgView addSubview:memberList];
    objc_setAssociatedObject(self, &MemberIconListKey, memberList, OBJC_ASSOCIATION_ASSIGN);
    
    ///商户信息
    QSImageView *marIconAboveView = [[QSImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2.0f-(DeviceWidth >= 375.0f ? 170.0f : 130.0f)/2.0f, memberList.frame.origin.y+memberList.frame.size.height+50.0f, (DeviceWidth >= 375.0f ? 170.0f : 130.0f), (DeviceWidth >= 375.0f ? 170.0f : 130.0f)) andCallBack:^(SINGLETAP_IMAGEVIEW_ACTIONTYPE actionType) {
        
        ///商户点击事件：进入搭食团详情页面
        if (self.clickMerchantLogoCallBack) {
            
            ///创建搭食团详情页面
            QSFoodGroudDetailViewController *foodGroudDetailVC = [[QSFoodGroudDetailViewController alloc] initWithID:_teamLeaderID andTeamID:_teamID andMerchantName:_merchantName];
            self.clickMerchantLogoCallBack(foodGroudDetailVC);
            
        }
        
    }];
    [marIconAboveView roundView];
    marIconAboveView.backgroundColor = [UIColor colorWithRed:266.0f/255.0f green:266.0f/255.0f blue:266.0f/255.0f alpha:0.5];
    [bgView addSubview:marIconAboveView];
    
    QSImageView *marIconView = [[QSImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, marIconAboveView.frame.size.height-10.0f, marIconAboveView.frame.size.height-10.0f)];
    [marIconView roundView];
    [marIconAboveView addSubview:marIconView];
    objc_setAssociatedObject(self, &MarIconViewKey, marIconView, OBJC_ASSOCIATION_ASSIGN);
    
    ///商户其他信息
    QSImageView *marInfoBGView = [[QSImageView alloc] init];
    marInfoBGView.image = [UIImage imageNamed:@"foodgroud_main_marinfo_bg"];
    [bgView addSubview:marInfoBGView];
    
#if 1
    ///商户其他信息的约束
    CGFloat yPoint_marInfoBGView = marIconAboveView.frame.origin.y+marIconAboveView.frame.size.height+1.0f;
    marInfoBGView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *___hVFL_marInfoBGView = @"H:|-(>=10)-[marInfoBGView]-(>=10)-|";
    NSString *___vVFL_marInfoBGView = @"V:|-ypoint-[marInfoBGView(36)]";
    
    ///添加约束
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:marInfoBGView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_marInfoBGView options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(marInfoBGView)]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_marInfoBGView options:NSLayoutFormatAlignAllCenterX metrics:@{@"ypoint":[NSString stringWithFormat:@"%f",yPoint_marInfoBGView]} views:NSDictionaryOfVariableBindings(marInfoBGView)]];
#endif
    ///添加商户信息ui
    [self createMarchantInfoView:marInfoBGView];
    
    ///团长头像
    UIView *userIconAboveView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, bgView.frame.size.height-37.0f-(DeviceWidth >= 375.0f ? 75.0f : 55.0f), (DeviceWidth >= 375.0f ? 75.0f : 55.0f), (DeviceWidth >= 375.0f ? 75.0f : 55.0f))];
    userIconAboveView.backgroundColor = [UIColor whiteColor];
    [userIconAboveView roundView];
    [bgView addSubview:userIconAboveView];
    
    QSImageView *userIcon = [[QSImageView alloc] initWithFrame:CGRectMake(2.5f, 2.5f, userIconAboveView.frame.size.height-5.0f, userIconAboveView.frame.size.height-5.0f) andCallBack:^(SINGLETAP_IMAGEVIEW_ACTIONTYPE actionType) {
        
        ///点击头象事件
        
    }];
    [userIcon roundView];
    [userIconAboveView addSubview:userIcon];
    objc_setAssociatedObject(self, &UserIconKey, userIcon, OBJC_ASSOCIATION_ASSIGN);
    
    ///团长信息底view
    CGFloat xpoint_commenderInfoRootView = userIconAboveView.frame.origin.x+userIconAboveView.frame.size.width/2.0f;
    CGFloat ypoint_commenderInfoRootView = DeviceWidth >= 375.0f ? userIconAboveView.frame.origin.y+7.5f : userIconAboveView.frame.origin.y+5.0f;
    CGFloat height_commenderInfoRootView = DeviceWidth >= 375.0f ? userIcon.frame.size.height-10.0f : userIcon.frame.size.height-5.0f;
    
    UIView *commenderInfoRootView = [[UIView alloc] init];
    commenderInfoRootView.layer.borderColor = [[UIColor whiteColor] CGColor];
    commenderInfoRootView.layer.borderWidth = 2.5f;
    commenderInfoRootView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    commenderInfoRootView.layer.cornerRadius = height_commenderInfoRootView/2.0f;
    commenderInfoRootView.translatesAutoresizingMaskIntoConstraints = NO;
    [bgView insertSubview:commenderInfoRootView belowSubview:userIconAboveView];
    
    ///团长信息view的约束字符串
    NSString *___hVFL_commenderInfoRootView = @"H:|-xpoint-[commenderInfoRootView]-(>=10)-|";
    NSString *___vVFL_commenderInfoRootView = @"V:|-ypoint-[commenderInfoRootView(height)]";
    
    ///团长信息约束
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_commenderInfoRootView options:0 metrics:@{@"xpoint":[NSString stringWithFormat:@"%f",xpoint_commenderInfoRootView]} views:NSDictionaryOfVariableBindings(commenderInfoRootView)]];
    
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_commenderInfoRootView options:0 metrics:@{@"ypoint":[NSString stringWithFormat:@"%f",ypoint_commenderInfoRootView],@"height":[NSString stringWithFormat:@"%f",height_commenderInfoRootView]} views:NSDictionaryOfVariableBindings(commenderInfoRootView)]];
    
    ///添加团长其他信息
    [self createCommenderInfo:commenderInfoRootView];

}

///创建商户信息的子view
- (void)createMarchantInfoView:(UIView *)view
{
    
    ///分店名:WithFrame:CGRectMake(5.0f, 4.0f, view.frame.size.width-58.0f, view.frame.size.height-4.0f)
    UILabel *marNameLabel = [[UILabel alloc] init];
    marNameLabel.font = [UIFont systemFontOfSize:12.0f];
    marNameLabel.textColor = [UIColor whiteColor];
    marNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:marNameLabel];
    objc_setAssociatedObject(self, &MarNameKey, marNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///距离图标:WithFrame:CGRectMake(view.frame.size.width-53.0f, view.frame.size.height/2.0f-2.5f, 7.0f, 9.0f)
    UIImageView *distanceImage = [[UIImageView alloc] init];
    distanceImage.image = [UIImage imageNamed:@"foodgroud_main_mardistance"];
    distanceImage.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:distanceImage];
    
    ///距离:WithFrame:CGRectMake(distanceImage.frame.origin.x+distanceImage.frame.size.width+3.0f, 4.0f, 38.0f, view.frame.size.height-4.0f)
    UILabel *distanceLabel = [[UILabel alloc] init];
    distanceLabel.text = @"150m";
    distanceLabel.font = [UIFont systemFontOfSize:12.0f];
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:distanceLabel];
    objc_setAssociatedObject(self, &DistanceInfoKey, distanceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///编写约束
    NSString *___hVFL_allSubviews = @"H:|-5-[marNameLabel(>=40)]-[distanceImage(7)]-3-[distanceLabel(40)]-5-|";
    NSString *___vVFL_marNameLabel = @"V:|-6-[marNameLabel(30)]";
    NSString *___vVFL_distanceImage = @"V:|-17-[distanceImage(9)]";
    NSString *___vVFL_distanceInfoLabel = @"V:|-6-[distanceLabel(30)]";
    
    ///添加约束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_allSubviews options:0 metrics:nil views:NSDictionaryOfVariableBindings(marNameLabel,distanceImage,distanceLabel)]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_marNameLabel options:0 metrics:nil views:NSDictionaryOfVariableBindings(marNameLabel)]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_distanceImage options:0 metrics:nil views:NSDictionaryOfVariableBindings(distanceImage)]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_distanceInfoLabel options:0 metrics:nil views:NSDictionaryOfVariableBindings(distanceLabel)]];
    
}

/**
 *  @author     yangshengmeng, 14-12-18 12:12:32
 *
 *  @brief      创建团长说明信息视图
 *
 *  @param view 父视图
 *
 *  @since      2.0
 */
- (void)createCommenderInfo:(UIView *)view
{

    ///团长名字:WithFrame:CGRectMake(45.0f, 10.0f, view.frame.size.width-55.0f, 15.0f)
    UILabel *commenderNameLabel = [[UILabel alloc] init];
    commenderNameLabel.text = @"夏娃的联想";
    commenderNameLabel.font = [UIFont systemFontOfSize:14.0f];
    commenderNameLabel.textColor = [UIColor whiteColor];
    commenderNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:commenderNameLabel];
    objc_setAssociatedObject(self, &CommenderNameKey, commenderNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///请客说明:WithFrame:CGRectMake(45.0f, commenderNameLabel.frame.origin.y+25.0f, 50.0f, 15.0f)
    UILabel *instructionLabel = [[UILabel alloc] init];
    instructionLabel.text = @"团长请客";
    instructionLabel.font = [UIFont systemFontOfSize:14.0f];
    instructionLabel.textColor = [UIColor whiteColor];
    instructionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:instructionLabel];
    objc_setAssociatedObject(self, &TeamTypeKey, instructionLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///加团条件:WithFrame:CGRectMake(instructionLabel.frame.origin.x+instructionLabel.frame.size.width+5.0f, instructionLabel.frame.origin.y, 40.0f, 15.0f)
    UILabel *addCondiction = [[UILabel alloc] init];
    addCondiction.text = @"限女士";
    addCondiction.font = [UIFont systemFontOfSize:14.0f];
    addCondiction.textColor = [UIColor whiteColor];
    addCondiction.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:addCondiction];
    objc_setAssociatedObject(self, &TeamAddCondiction, addCondiction, OBJC_ASSOCIATION_ASSIGN);
    
    ///加团的情况:WithFrame:CGRectMake(addCondiction.frame.origin.x+addCondiction.frame.size.width+5.0f, addCondiction.frame.origin.y, 40.0f, 15.0f)
    UILabel *addCount = [[UILabel alloc] init];
    addCount.text = @"(12/12)";
    addCount.font = [UIFont systemFontOfSize:14.0f];
    addCount.textColor = [UIColor whiteColor];
    addCount.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:addCount];
    objc_setAssociatedObject(self, &TeamAddStatusKey, addCount, OBJC_ASSOCIATION_ASSIGN);
    
    ///编写约束
    NSString *___hVFL_commenderNameLabel = @"H:|-45-[commenderNameLabel]-5-|";
    NSString *___hVFL_otherSubviews = @"H:|-45-[instructionLabel]-[addCondiction]-[addCount]-(>=15)-|";
    NSString *___vVFL_commenderNameLabel = @"V:|-(>=5,<=10)-[commenderNameLabel(>=15,<=20)]";
    NSString *___vVFL_instructionLabel = @"V:[commenderNameLabel]-(<=10)-[instructionLabel(>=15,<=20)]-(>=5,<=10)-|";
    NSString *___vVFL_addCondiction = @"V:[commenderNameLabel]-(<=10)-[addCondiction(>=15,<=20)]-(>=5,<=10)-|";
    NSString *___vVFL_addCount = @"V:[commenderNameLabel]-(<=10)-[addCount(>=15,<=20)]-(>=5,<=10)-|";
    
    ///添加约束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_commenderNameLabel options:0 metrics:nil views:NSDictionaryOfVariableBindings(commenderNameLabel)]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_commenderNameLabel options:0 metrics:nil views:NSDictionaryOfVariableBindings(commenderNameLabel)]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_otherSubviews options:0 metrics:nil views:NSDictionaryOfVariableBindings(instructionLabel,addCondiction,addCount)]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_instructionLabel options:0 metrics:nil views:NSDictionaryOfVariableBindings(commenderNameLabel,instructionLabel)]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_addCondiction options:0 metrics:nil views:NSDictionaryOfVariableBindings(commenderNameLabel,addCondiction)]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_addCount options:0 metrics:nil views:NSDictionaryOfVariableBindings(commenderNameLabel,addCount)]];

}

/**
 *  @author         yangshengmeng, 14-12-18 10:12:44
 *
 *  @brief          按给定的搭吃团数据模型更新UI
 *
 *  @param model    数据模型
 *
 *  @since          2.0
 */
#pragma mark - 按给定的搭吃团数据模型更新UI
- (void)updateFoodGroudUIWithModel:(QSYFoodGroudDataModel *)model
{
    ///保存相关ID
    _teamID = [model.teamID copy];
    _teamLeaderID = [((QSYFoodGroudMemberDataModel *)model.memberList[0]).userID copy];
    _merchantName = [model.marchantName copy];
    
    ///把商户相关的信息存在暂时文件中
    NSDictionary *merchantBaseInfoDict = @{@"merchantName" : model.marchantName,
                                           @"merchantID" : model.marID,
                                           @"merchantLat" : model.marLatitute,
                                           @"merchantLong" : model.marLong,
                                           @"merchantIcon" : model.marIconUrl,
                                           @"merchantScore" : model.scrore ? model.scrore : @"0",
                                           @"merchantAddress" : model.marAddress ? model.marAddress : @"广州"};
    [[NSUserDefaults standardUserDefaults] setObject:merchantBaseInfoDict forKey:@"foodgroud_merchant"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ///更新背景图片
    [self updateBGImage:model.marBGImageUrl];
    
    ///更新成员列表
    [self updateMembersIconList:model.memberList];
    
    ///更新商户logo
    [self updateMarchantIcon:model.marIconUrl];
    
    ///更新商户信息
    [self updateMarchantName:[self formatMarchantName:model.marchantName andNickName:nil]];
    
    ///更新距离
    [self updateDistanceInfo:[self calDistanceWithPoint:model.marLong andLatitute:model.marLatitute]];
    
    ///更新用户头像
    [self updateUserIcon:((QSYFoodGroudMemberDataModel *)model.memberList[0]).userIcon];
    
    ///更新团长名字
    [self updateCommenderName:((QSYFoodGroudMemberDataModel *)model.memberList[0]).userName];
    
    ///更新参团条件
    [self updateAddTeamCondiction:[model getAddCondictionString]];
    
    ///更新支付方式
    [self updatePayStyleInstruction:[model getPayStyleString]];
    
    ///更新上前已参团的人数情况
    [self updateTeamAddedStatus:model.sumNumber andLeftNum:model.joinedNumber];
    
    ///检查当前搭食团是否是当前用户创建的
    BOOL flag = [self checkTeamCreator:[model getCreatorID]];
    
    ///判断是否已满人
    if (!flag) {
        
        ///判断当前用户是否已参团
        [self checkCurrentUserIsJoined:model];
        
    }

}

/**
 *  @author             yangshengmeng, 14-12-21 16:12:24
 *
 *  @brief              判断当前用户是否已加入到这前的搭食团中
 *
 *  @param status       加入状态
 *  @param sumString    搭食团总人数
 *  @param leftNum      还可以报名的人数
 *
 *  @since              2.0
 */
- (BOOL)checkCurrentUserIsJoined:(NSString *)sumString andLeft:(NSString *)leftNum
{

    ///判断是否已满人，满人通知列表修改团报名状态
    if ([leftNum intValue] <= 1) {
        
        if (self.callBack) {
            self.callBack(3,TEAM_ISFULL_CFST,nil);
        }
        
        return YES;
        
    } else {
        
        if (self.callBack) {
            self.callBack(0,DEFAULT_CFST,nil);
        }
        
    }

    return NO;
}

/**
 *  @author         yangshengmeng, 14-12-21 16:12:23
 *
 *  @brief          返回当前用户是否参加此团
 *
 *  @param model    团的情况
 *
 *  @since          2.0
 */
- (BOOL)checkCurrentUserIsJoined:(QSYFoodGroudDataModel *)model
{
    NSString *currentID = [UserManager sharedManager].userData.user_id;
    
    for (QSYFoodGroudMemberDataModel *obj in model.memberList) {
        
        if ([currentID isEqualToString:obj.userID]) {
            
            if (self.callBack) {
                self.callBack(1,CURRENT_USER_JOINED_CFST,nil);
            }
            
            return YES;
            
        }
        
    }
    
    if (self.callBack) {
        self.callBack(0,CURRENT_USER_JOINED_CFST,nil);
    }
    
    ///如果没参团，判断是否已满人
    [self checkCurrentUserIsJoined:model.sumNumber andLeft:[NSString stringWithFormat:@"%d",[model.sumNumber intValue]-[model.joinedNumber intValue]]];
    
    return NO;

}

/**
 *  @author             yangshengmeng, 14-12-21 15:12:27
 *
 *  @brief              检测当前的搭食团是否当前用户创建
 *
 *  @param creatorID    本搭团的创建者账号ID
 *
 *  @since              2.0
 */
- (BOOL)checkTeamCreator:(NSString *)creatorID
{

    NSString *loginID = [UserManager sharedManager].userData.user_id;
    if ([creatorID isEqualToString:loginID]) {
        
        if (self.callBack) {
            
            self.callBack(1,ISCURRENT_COUNT_TEAM_CFST,nil);
            
        }
        
        return YES;
        
    }
    
    if (self.callBack) {
        
        self.callBack(0,ISCURRENT_COUNT_TEAM_CFST,nil);
        
    }
    
    return NO;

}

///更新背景图片：传入一个图片的相对地址
- (void)updateBGImage:(NSString *)imageName
{

    UIImageView *bgImage = objc_getAssociatedObject(self, &BGImageViewKey);
    if (bgImage && imageName) {
        
        ///请求图片
        [bgImage setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
        
    }

}

///根据成员数组，更新用户头像列表
- (void)updateMembersIconList:(NSArray *)array
{

    if ([array count] <= 0) {
        return;
    }
    
    QSYMemberIconlistView *listView = objc_getAssociatedObject(self, &MemberIconListKey);
    [listView updateMembersIconListWithArray:array];

}

///更新商户的logo图片，传入一个图片的相对地址
- (void)updateMarchantIcon:(NSString *)iconURLString
{

    if (!iconURLString) {
        return;
    }
    
    UIImageView *marIcon = objc_getAssociatedObject(self, &MarIconViewKey);
    [marIcon setImageWithURL:[NSURL URLWithString:[iconURLString imageUrl]] placeholderImage:nil];

}

///更新商户名称
- (void)updateMarchantName:(NSString *)marchName
{

    UILabel *name = objc_getAssociatedObject(self, &MarNameKey);
    if (name && marchName) {
        name.text = marchName;
    }

}

/**
 *  @author         yangshengmeng, 14-12-18 11:12:14
 *
 *  @brief          根据商户的昵称和名字，返回有效的商户名
 *
 *  @param marName  商户名
 *  @param nickName 商户nichen
 *
 *  @since          2.0
 */
- (NSString *)formatMarchantName:(NSString *)marName andNickName:(NSString *)nickName
{

    if ([nickName length] > 4) {
        return nickName;
    }
    
    return marName;

}

///更新距离
- (void)updateDistanceInfo:(NSString *)dis
{

    UILabel *disLabel = objc_getAssociatedObject(self, &DistanceInfoKey);
    if (disLabel && dis) {
        
        disLabel.text = dis;
        
    }

}

/**
 *  @author             yangshengmeng, 14-12-18 11:12:29
 *
 *  @brief              按给定的经纬度计算和当前用户的距离
 *
 *  @param longitule    经度
 *  @param latitute     纬度
 *
 *  @return             返回距离，单位：m/km
 *
 *  @since              2.0
 */
- (NSString *)calDistanceWithPoint:(NSString *)longitude andLatitute:(NSString *)latitude
{
    
    CLLocationCoordinate2D point1 = [UserManager sharedManager].userData.location;
    CLLocationCoordinate2D point2 = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    
    ///判断用户坐标
    
    
    NSString *distance = [[UserManager sharedManager] distanceBetweenTwoPoint:point1 andPoint2:point2];
    
    return distance;

}

///更新用户头像
- (void)updateUserIcon:(NSString *)iconString
{

    UIImageView *userIcon = objc_getAssociatedObject(self, &UserIconKey);
    if (iconString && userIcon) {
        [userIcon setImageWithURL:[NSURL URLWithString:[iconString imageUrl]] placeholderImage:nil];
    }

}

///更新团长名字
- (void)updateCommenderName:(NSString *)name
{

    UILabel *label = objc_getAssociatedObject(self, &CommenderNameKey);
    if (label && name) {
        
        label.text = name;
        
    }
    
}

///更新参团条件
- (void)updateAddTeamCondiction:(NSString *)con
{

    UILabel *label = objc_getAssociatedObject(self, &TeamAddCondiction);
    if (label && con) {
        
        label.text = con;
        
    }

}

///更新目前参团情况
- (void)updateTeamAddedStatus:(NSString *)sumNum andLeftNum:(NSString *)joinedSum
{

    UILabel *label = objc_getAssociatedObject(self, &TeamAddStatusKey);
    if (label && sumNum && joinedSum) {
        
        label.text = [NSString stringWithFormat:@"(%d/%d)",[joinedSum intValue] + 1,[sumNum intValue]];
        
    }

}

///更新支付方式
- (void)updatePayStyleInstruction:(NSString *)instruct
{

    UILabel *payStyle = objc_getAssociatedObject(self, &TeamTypeKey);
    if (payStyle) {
        payStyle.text = instruct;
    }

}

/**
 *  @author         yangshengmeng, 14-12-21 21:12:38
 *
 *  @brief          更新个人的搭食团列表UI
 *
 *  @param model    个人的搭食团数据模型
 *
 *  @since          2.0
 */
#pragma mark - 个人的搭食团列表UI更新
- (void)updateMyFoodGroudUIWithModel:(QSYMyFoodGroudDataModel *)model
{
    
    ///保存相关ID
    _teamID = [model.teamID copy];
    _teamLeaderID = [((QSYFoodGroudMemberDataModel *)model.memberList[0]).userID copy];
    _merchantName = [model.marchantName copy];
    
    ///把商户相关的信息存在暂时文件中
    NSDictionary *merchantBaseInfoDict = @{@"merchantName" : model.marchantName,
                                           @"merchantID" : model.marID,
                                           @"merchantLat" : model.marLatitute,
                                           @"merchantLong" : model.marLong,
                                           @"merchantIcon" : model.marIconUrl,
                                           @"merchantScore" : model.scrore ? model.scrore : @"0",
                                           @"merchantAddress" : model.marAddress ? model.marAddress : @"广州"};
    [[NSUserDefaults standardUserDefaults] setObject:merchantBaseInfoDict forKey:@"foodgroud_merchant"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    ///更新背景图片
    [self updateBGImage:model.marBGImageUrl];
    
    ///更新成员列表
    [self updateMembersIconList:model.memberList];
    
    ///更新商户logo
    [self updateMarchantIcon:model.marIconUrl];
    
    ///更新商户信息
    [self updateMarchantName:[self formatMarchantName:model.marchantName andNickName:nil]];
    
    ///更新距离
    [self updateDistanceInfo:[self calDistanceWithPoint:model.marLong andLatitute:model.marLatitute]];
    
    ///更新用户头像
    [self updateUserIcon:model.authorIcon];
    
    ///更新团长名字
    [self updateCommenderName:model.authorName];
    
    ///更新参团条件
    [self updateAddTeamCondiction:[model getAddCondictionString]];
    
    ///更新支付方式
    [self updatePayStyleInstruction:[model getPayStyleString]];
    
    ///更新目前已参团的人数情况
    [self updateTeamAddedStatus:model.sumNumber andLeftNum:model.joinedNumber];
    
    ///检查当前搭食团是否是当前用户创建的
    if (![self checkTeamCreator:[model getCreatorID]]) {
     
        ///判断当前用户是否已参团
        [self checkCurrentUserIsJoined:model];
        
    }

}

@end
