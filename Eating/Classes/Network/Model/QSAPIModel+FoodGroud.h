//
//  QSAPIModel+FoodGroud.h
//  Eating
//
//  Created by ysmeng on 14/12/18.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (FoodGroud)

@end

/**
 *  @author yangshengmeng, 14-12-18 14:12:28
 *
 *  @brief  请求搭食团列表返回数据
 *
 *  @since  2.0
 */
@interface QSFoodGroudListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码
@property (nonatomic,retain) NSArray *foodGroupList;    //!<搭食团列表

@end

/**
 *  @author yangshengmeng, 14-12-18 14:12:00
 *
 *  @brief  每一个搭食团的基本信息
 *
 *  @since  2.0
 */
@interface QSYFoodGroudDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *teamID;        //!<团ID
@property (nonatomic,copy) NSString *leaderID;      //!<团长ID
@property (nonatomic,copy) NSString *leaderPhone;   //!<团长联系电话
@property (nonatomic,copy) NSString *leaderName;    //!<团长名字
@property (nonatomic,copy) NSString *teamStatus;    //!<团状态：1-已成团，4-已取消

@property (nonatomic,copy) NSString *marID;         //!<商户ID
@property (nonatomic,copy) NSString *marchantName;  //!<商户名称
@property (nonatomic,copy) NSString *marIconUrl;    //!<商户logo
@property (nonatomic,copy) NSString *marBGImageUrl; //!<商户背景图片
@property (nonatomic,copy) NSString *marLong;       //!<商户经度
@property (nonatomic,copy) NSString *marLatitute;   //!<商户纬度
@property (nonatomic,copy) NSString *marAddress;    //!<商户地址
@property (nonatomic,copy) NSString *scrore;        //!<商户评分

@property (nonatomic,copy) NSString *sumNumber;     //!<团的总人数
@property (nonatomic,copy) NSString *joinedNumber;  //!<已经参加的人数
@property (nonatomic,copy) NSString *isJoined;      //!<当前用户是否已参团：1-已参团
@property (nonatomic,copy) NSString *joinTime;      //!<开始时间
@property (nonatomic,copy) NSString *teamComment;   //!<说明
@property (nonatomic,copy) NSArray *tagList;        //!<标签数组

@property (nonatomic,copy) NSString *addCondiction; //!<参团条件
@property (nonatomic,copy) NSString *payStyle;      //!<支付方式
@property (nonatomic,copy) NSString *canTakeFamilies;//!<是否可带家人

@property (nonatomic,copy) NSArray *memberList;     //!<已参团成员列表

/**
 *  @author yangshengmeng, 14-12-18 21:12:35
 *
 *  @brief  获取当前搭吃团的支付方式
 *
 *  @return 返回支付方式说明
 *
 *  @since  2.0
 */
- (NSString *)getPayStyleString;

/**
 *  @author yangshengmeng, 14-12-18 21:12:38
 *
 *  @brief  获取当前搭团的限制条件：男，女，不限
 *
 *  @return 返回限制条件说胆字符串
 *
 *  @since  2.0
 */
- (NSString *)getAddCondictionString;

/**
 *  @author yangshengmeng, 14-12-21 15:12:56
 *
 *  @brief  获取搭食团的创建人ID
 *
 *  @return 返回ID
 *
 *  @since  2.0
 */
- (NSString *)getCreatorID;

@end

/**
 *  @author yangshengmeng, 14-12-18 15:12:09
 *
 *  @brief  搭食团成员基本信息
 *
 *  @since  2.0
 */
@interface QSYFoodGroudMemberDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *userID;    //!<成员ID
@property (nonatomic,copy) NSString *userName;  //!<成员名字
@property (nonatomic,copy) NSString *userIcon;  //!<成员头像
@property (nonatomic,copy) NSString *status;    //!<当前用户参团状态
@property (nonatomic,copy) NSString *teamID;    //!<所在团的ID

@end

/**
 *  @author yangshengmeng, 14-12-18 14:12:28
 *
 *  @brief  请求个人搭食团列表返回数据
 *
 *  @since  2.0
 */
@interface QSMyFoodGroudListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码
@property (nonatomic,retain) NSArray *foodGroupList;    //!<搭食团列表

@end

/**
 *  @author yangshengmeng, 14-12-18 14:12:00
 *
 *  @brief  个人列表中每一个搭食团的基本信息
 *
 *  @since  2.0
 */
@interface QSYMyFoodGroudDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *teamID;        //!<团ID
@property (nonatomic,copy) NSString *leaderID;      //!<团长ID
@property (nonatomic,copy) NSString *leaderPhone;   //!<团长联系电话
@property (nonatomic,copy) NSString *leaderName;    //!<团长名字
@property (nonatomic,copy) NSString *teamStatus;    //!<团状态：1-已成团，4-已取消

@property (nonatomic,copy) NSString *marID;         //!<商户ID
@property (nonatomic,copy) NSString *marchantName;  //!<商户名称
@property (nonatomic,copy) NSString *marIconUrl;    //!<商户logo
@property (nonatomic,copy) NSString *marBGImageUrl; //!<商户背景图片
@property (nonatomic,copy) NSString *marLong;       //!<商户经度
@property (nonatomic,copy) NSString *marLatitute;   //!<商户纬度
@property (nonatomic,copy) NSString *scrore;        //!<商户评分
@property (nonatomic,copy) NSString *marAddress;    //!<商户地址

@property (nonatomic,copy) NSString *sumNumber;     //!<团的总人数
@property (nonatomic,copy) NSString *joinedNumber;  //!<已经参加的人数
@property (nonatomic,copy) NSString *joinTime;      //!<开始时间
@property (nonatomic,copy) NSString *teamComment;   //!<说明
@property (nonatomic,copy) NSArray *tagList;        //!<标签数组
@property (nonatomic,copy) NSArray *memberList;     //!<已参团成员列表

@property (nonatomic,copy) NSString *addCondiction; //!<参团条件
@property (nonatomic,copy) NSString *payStyle;      //!<支付方式
@property (nonatomic,copy) NSString *canTakeFamilies;//!<是否可带家人

@property (nonatomic,copy) NSString *authorID;      //!<团长ID
@property (nonatomic,copy) NSString *authorName;    //!<团长名字
@property (nonatomic,copy) NSString *authorPhone;   //!<团长电话
@property (nonatomic,copy) NSString *authorIcon;    //!<团长头像

/**
 *  @author yangshengmeng, 14-12-18 21:12:35
 *
 *  @brief  获取当前搭吃团的支付方式
 *
 *  @return 返回支付方式说明
 *
 *  @since  2.0
 */
- (NSString *)getPayStyleString;

/**
 *  @author yangshengmeng, 14-12-18 21:12:38
 *
 *  @brief  获取当前搭团的限制条件：男，女，不限
 *
 *  @return 返回限制条件说胆字符串
 *
 *  @since  2.0
 */
- (NSString *)getAddCondictionString;

/**
 *  @author yangshengmeng, 14-12-21 15:12:56
 *
 *  @brief  获取搭食团的创建人ID
 *
 *  @return 返回ID
 *
 *  @since  2.0
 */
- (NSString *)getCreatorID;

@end

@class QSFoodGroudDetailDataModel;
/**
 *  @author yangshengmeng, 14-12-24 15:12:35
 *
 *  @brief  搭食团详情请求返回时的最外层数据模型
 *
 *  @since  2.0
 */
@interface QSFoodGroudDetailReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码
@property (nonatomic,retain) QSFoodGroudDetailDataModel *detailModel;    //!<搭食团列表

@end

/**
 *  @author yangshengmeng, 14-12-24 15:12:19
 *
 *  @brief  每个搭食团详情的数据模型
 *
 *  @since  2.0
 */
@class QSFoodGroudMerchantDataModel;
@interface QSFoodGroudDetailDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *teamID;//!<搭食团的ID
@property (nonatomic,copy) NSString *commenderID;//!<团长ID
@property (nonatomic,copy) NSString *commenderName;//!<团长名字

@property (nonatomic,retain) NSArray *memberList;//!<成员列表
@property (nonatomic,retain) QSFoodGroudMerchantDataModel *merchantModel;//!<商户信息

@end

/**
 *  @author yangshengmeng, 14-12-24 16:12:10
 *
 *  @brief  商户环境图片模型
 *
 *  @since  2.0
 */
@interface QSFoodGroudMerchantImageModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *imageID;//!<图片ID
@property (nonatomic,copy) NSString *imageLink;//!<图片链接

@end

/**
 *  @author yangshengmeng, 14-12-24 16:12:22
 *
 *  @brief  搭食团里的成员信息模型
 *
 *  @since  2.0
 */
@interface QSFoodGroudMembersDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *userAddID;//!<成员参加当前搭食团时的关联ID
@property (nonatomic,copy) NSString *userID;//!<成员ID
@property (nonatomic,copy) NSString *teamID;//!<当前所在团的ID
@property (nonatomic,copy) NSString *userStatus;//!<当前用户是否已成功入团的状态
@property (nonatomic,copy) NSString *userName;//!<用户名
@property (nonatomic,copy) NSString *userIcon;//!<用户头像

@end

/**
 *  @author yangshengmeng, 14-12-24 16:12:41
 *
 *  @brief  搭食团里使用的商户信息model
 *
 *  @since  2.0
 */
@interface QSFoodGroudMerchantDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *merchantID;//!<商户ID
@property (nonatomic,copy) NSString *merchantName;//!<商户名
@property (nonatomic,copy) NSString *merchantLongitude;//!<商户的经度
@property (nonatomic,copy) NSString *merchantLatitude;//!<商户的纬度
@property (nonatomic,copy) NSString *merchantIcon;//!<商户logo
@property (nonatomic,copy) NSString *merchantScore;//!<商户评分
@property (nonatomic,copy) NSString *merchantCollectCount;//!<商户收藏数

@property (nonatomic,retain) NSArray *imageList;//!商户图集

@end

/**
 *  @author yangshengmeng, 14-12-24 15:12:35
 *
 *  @brief  参加一个搭食团的回调信息
 *
 *  @since  2.0
 */
@interface QSJoinFoodGroudDetailReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码

@end

/**
 *  @author yangshengmeng, 14-12-26 15:12:37
 *
 *  @brief  搭食团聊天时，群聊所有的消息列表返回的模型
 *
 *  @since  2.0
 */
@interface QSFoodGroudTeamTalkMessageListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码

@property (nonatomic,retain) NSArray *messageList;      //!<消息数组

@end

/**
 *  @author yangshengmeng, 14-12-26 15:12:15
 *
 *  @brief  每一个消息的数据模型
 *
 *  @since  2.0
 */
@interface QSFoodGroudTalkMessageDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *teamID;//!<当前消息所在的搭食团ID
@property (nonatomic,copy) NSString *userID;//!<消息发送人的ID
@property (nonatomic,copy) NSString *userName;//!<消息送人的名字
@property (nonatomic,copy) NSString *userLogo;//!<消息发送人的头像
@property (nonatomic,copy) NSString *message;//!<消息内容
@property (nonatomic,copy) NSString *sendTime;//!<发送时间

@end

/**
 *  @author yangshengmeng, 14-12-26 14:12:14
 *
 *  @brief  搭食团群聊时，发送信息后服务端返回的数据模型
 *
 *  @since  2.0
 */
@interface QSFoodGroudTeamTalkSendMessageReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码

@end