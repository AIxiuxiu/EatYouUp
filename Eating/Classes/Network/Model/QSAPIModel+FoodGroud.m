//
//  QSAPIModel+FoodGroud.m
//  Eating
//
//  Created by ysmeng on 14/12/18.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+FoodGroud.h"

@implementation QSAPIModel (FoodGroud)

@end

#pragma mark - 搭食团列表信息相关的数据模型
@implementation QSFoodGroudListReturnData

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"type" : @"type",
                                      @"info" : @"errorInfo",
                                      @"code" : @"errorCode"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        //获取每个商户信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"foodGroupList" withMapping:[QSYFoodGroudDataModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;

}

@end

@implementation QSYFoodGroudDataModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"id" : @"teamID",
                                      @"user_id" : @"leaderID",
                                      @"team_phone" : @"leaderPhone",
                                      @"user_name" : @"leaderName",
                                      @"status" : @"teamStatus",
                                      @"merchant_id" : @"marID",
                                      @"merchant_name" : @"marchantName",
                                      @"merchant_logo" : @"marIconUrl",
                                      @"merchant_background_image" : @"marBGImageUrl",
                                      @"long" : @"marLong",
                                      @"lat" : @"marLatitute",
                                      @"address" : @"marAddress",
                                      @"scrore" : @"scrore",
                                      @"join_num" : @"sumNumber",
                                      @"real_join" : @"joinedNumber",
                                      @"team_sex_type" : @"addCondiction",
                                      @"team_type" : @"payStyle",
                                      @"is_good" : @"isJoined",
                                      @"add_time" : @"joinTime",
                                      @"team_content" : @"teamComment",
                                      @"team_tag" : @"tagList",
                                      @"team_take_family" : @"canTakeFamilies"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        //获取每个商户信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user_list" toKeyPath:@"memberList" withMapping:[QSYFoodGroudMemberDataModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;

}

/**
 *  @author yangshengmeng, 14-12-18 21:12:35
 *
 *  @brief  获取当前搭吃团的支付方式
 *
 *  @return 返回支付方式说明
 *
 *  @since  2.0
 */
- (NSString *)getPayStyleString
{

    int payStyle = [self.payStyle intValue];
    
    switch (payStyle) {
        case 0:
            
            return @"团长请客";
            
            break;
            
        case 1:
            
            return @"AA";
            
            break;
            
        case 2:
            
            return @"成员请客";
            
            break;
            
        default:
            break;
    }
    
    return nil;

}

/**
 *  @author yangshengmeng, 14-12-18 21:12:38
 *
 *  @brief  获取当前搭团的限制条件：男，女，不限
 *
 *  @return 返回限制条件说胆字符串
 *
 *  @since  2.0
 */
- (NSString *)getAddCondictionString
{

    int condiction = [self.addCondiction intValue];
    
    switch (condiction) {
        case 0:
            
            return @"限女士";
            
            break;
            
        case 1:
            
            return @"限男士";
            
            break;
            
        case 2:
            
            return @"不限男女";
            
            break;
            
        default:
            break;
    }
    
    return nil;

}

/**
 *  @author yangshengmeng, 14-12-21 15:12:56
 *
 *  @brief  获取搭食团的创建人ID
 *
 *  @return 返回ID
 *
 *  @since  2.0
 */
- (NSString *)getCreatorID
{

    return self.leaderID;

}

@end

/**
 *  @author yangshengmeng, 14-12-18 15:12:09
 *
 *  @brief  搭食团成员基本信息
 *
 *  @since  2.0
 */
@implementation QSYFoodGroudMemberDataModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"user_id" : @"userID",
                                      @"user_name" : @"userName",
                                      @"logo" : @"userIcon",
                                      @"status" : @"status",
                                      @"team_id" : @"teamID"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
                
    });
    
    ///返回mapping结果
    return shared_mapping;

}

@end

@implementation QSMyFoodGroudListReturnData

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"type" : @"type",
                                      @"info" : @"errorInfo",
                                      @"code" : @"errorCode"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        //获取每个商户信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"foodGroupList" withMapping:[QSYMyFoodGroudDataModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;

}

@end

@implementation QSYMyFoodGroudDataModel

+ (RKObjectMapping *)objectMapping
{
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"id" : @"teamID",
                                      @"user_id" : @"leaderID",
                                      @"team_phone" : @"leaderPhone",
                                      @"user_name" : @"leaderName",
                                      @"status" : @"teamStatus",
                                      @"merchant_id" : @"marID",
                                      @"merchant_name" : @"marchantName",
                                      @"merchant_logo" : @"marIconUrl",
                                      @"merchant_background_image" : @"marBGImageUrl",
                                      @"_long" : @"marLong",
                                      @"lat" : @"marLatitute",
                                      @"address" : @"marAddress",
                                      @"scrore" : @"scrore",
                                      @"join_num" : @"sumNumber",
                                      @"real_join" : @"joinedNumber",
                                      @"team_sex_type" : @"addCondiction",
                                      @"team_type" : @"payStyle",
                                      @"add_time" : @"joinTime",
                                      @"team_content" : @"teamComment",
                                      @"team_tag" : @"tagList",
                                      @"team_take_family" : @"canTakeFamilies",
                                      @"user_id" : @"authorID",
                                      @"leader_user_name" : @"authorName",
                                      @"team_phone" : @"authorPhone",
                                      @"leader_logo" : @"authorIcon"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        //获取每个商户信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user_list" toKeyPath:@"memberList" withMapping:[QSYFoodGroudMemberDataModel objectMapping]]];
                
    });
    
    ///返回mapping结果
    return shared_mapping;
    
}

/**
 *  @author yangshengmeng, 14-12-18 21:12:35
 *
 *  @brief  获取当前搭吃团的支付方式
 *
 *  @return 返回支付方式说明
 *
 *  @since  2.0
 */
- (NSString *)getPayStyleString
{
    
    int payStyle = [self.payStyle intValue];
    
    switch (payStyle) {
        case 0:
            
            return @"团长请客";
            
            break;
            
        case 1:
            
            return @"AA";
            
            break;
            
        case 2:
            
            return @"成员请客";
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

/**
 *  @author yangshengmeng, 14-12-18 21:12:38
 *
 *  @brief  获取当前搭团的限制条件：男，女，不限
 *
 *  @return 返回限制条件说胆字符串
 *
 *  @since  2.0
 */
- (NSString *)getAddCondictionString
{
    
    int condiction = [self.addCondiction intValue];
    
    switch (condiction) {
        case 0:
            
            return @"限女士";
            
            break;
            
        case 1:
            
            return @"限男士";
            
            break;
            
        case 2:
            
            return @"不限男女";
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

/**
 *  @author yangshengmeng, 14-12-21 15:12:56
 *
 *  @brief  获取搭食团的创建人ID
 *
 *  @return 返回ID
 *
 *  @since  2.0
 */
- (NSString *)getCreatorID
{
    
    return self.leaderID;
    
}

@end

#pragma mark - 搭食团详情信息相关的数据模型
/**
 *  @author yangshengmeng, 14-12-24 15:12:35
 *
 *  @brief  搭食团详情请求返回时的最外层数据模型
 *
 *  @since  2.0
 */
@implementation QSFoodGroudDetailReturnData

+ (RKObjectMapping *)objectMapping
{
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"type" : @"type",
                                      @"info" : @"errorInfo",
                                      @"code" : @"errorCode"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        //获取每个商户信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"detailModel" withMapping:[QSFoodGroudDetailDataModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
    
}

@end

/**
 *  @author yangshengmeng, 14-12-24 15:12:19
 *
 *  @brief  每个搭食团详情的数据模型
 *
 *  @since  2.0
 */
@implementation QSFoodGroudDetailDataModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"id" : @"teamID",
                                      @"user_id" : @"commenderID",
                                      @"user_name" : @"commenderName"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        //获取成员列表
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user_list" toKeyPath:@"memberList" withMapping:[QSFoodGroudMembersDataModel objectMapping]]];
        
        //获取商户信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"merchant_msg" toKeyPath:@"merchantModel" withMapping:[QSFoodGroudMerchantDataModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;

}

@end

@implementation QSFoodGroudMembersDataModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"id" : @"userAddID",
                                      @"user_id" : @"userID",
                                      @"team_id" : @"teamID",
                                      @"status" : @"userStatus",
                                      @"user_name" : @"userName",
                                      @"logo" : @"userIcon"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;

}

@end

@implementation QSFoodGroudMerchantDataModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"id" : @"merchantID",
                                      @"merchant_name" : @"merchantName",
                                      @"longitude" : @"merchantLongitude",
                                      @"latitude" : @"merchantLatitude",
                                      @"merchant_logo" : @"merchantIcon",
                                      @"score" : @"merchantScore",
                                      @"good_num" : @"merchantCollectCount"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        ///获取商户环境图片信息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"imagelist" toKeyPath:@"imageList" withMapping:[QSFoodGroudMerchantImageModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;

}

@end

@implementation QSFoodGroudMerchantImageModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"id" : @"imageID",
                                      @"image_link" : @"imageLink"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;

}

@end

@implementation QSJoinFoodGroudDetailReturnData

+ (RKObjectMapping *)objectMapping
{
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"type" : @"type",
                                      @"info" : @"errorInfo",
                                      @"code" : @"errorCode"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
    
}

@end

@implementation QSFoodGroudTeamTalkMessageListReturnData

+ (RKObjectMapping *)objectMapping
{
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"type" : @"type",
                                      @"info" : @"errorInfo",
                                      @"code" : @"errorCode"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
        ///解析成员消息
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"messageList" withMapping:[QSFoodGroudTalkMessageDataModel objectMapping]]];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
    
}

@end

@implementation QSFoodGroudTalkMessageDataModel

+ (RKObjectMapping *)objectMapping
{
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"team_id" : @"teamID",
                                      @"user_id" : @"userID",
                                      @"user_name" : @"userName",
                                      @"logo" : @"userLogo",
                                      @"context" : @"message",
                                      @"add_time" : @"sendTime"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
    
}

@end

@implementation QSFoodGroudTeamTalkSendMessageReturnData

+ (RKObjectMapping *)objectMapping
{
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"type" : @"type",
                                      @"info" : @"errorInfo",
                                      @"code" : @"errorCode"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
    
}

@end