//
//  QSAPIClientBase+User.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

//Type:   1：商家 2：菜品 3：优惠卷 4：促销 5：文章 6：试吃团   7:  储值卡
typedef enum
{
    kUserGoodType_Merchant = 1,
    kUserGoodType_Food,
    kUserGoodType_Coupon,
    kUserGoodType_Discount,
    kUserGoodType_Article,
    kUserGoodType_TryTaste,
    kUserGoodType_PrepaidCard
}kUserGoodType;

@class QSTagListReturnData;
@class QSMerchantListReturnData;
@class QSFoodListReturnData;
@interface QSAPIClientBase (User)

- (void)userRegister:(NSString *)mobile
            password:(NSString *)password
             success:(void(^)(QSAPIModel *response))success
                fail:(void(^)(NSError *error))fail;

- (void)changePasswordByPhone:(NSString *)mobile
                     password:(NSString *)password
                      success:(void(^)(QSAPIModel *response))success
                         fail:(void(^)(NSError *error))fail;

- (void)updateUserName:(NSString *)name
                   Sex:(NSString *)sex
               success:(void(^)(QSAPIModel *response))success
                  fail:(void(^)(NSError *error))fail;

- (void)updateUserPassword:(NSString *)password
                   NewPassword:(NSString *)newpassowrd
               success:(void(^)(QSAPIModel *response))success
                  fail:(void(^)(NSError *error))fail;

- (void)getVerCode:(NSString *)phone
        merchantId:(NSString *)merchant_id
           success:(void(^)(QSAPIModelString *response))success
              fail:(void(^)(NSError *error))fail;

- (void)bindMobile:(NSString *)old_mobile
         newMobile:(NSString *)new_mobile
           verCode:(NSString *)vercode
           success:(void(^)(QSAPIModel *response))success
              fail:(void(^)(NSError *error))fail;

- (void)bindEmail:(NSString *)old_email
         newEmail:(NSString *)new_email
           verCode:(NSString *)vercode
           success:(void(^)(QSAPIModel *response))success
              fail:(void(^)(NSError *error))fail;

- (void)uploadUserPortrait:(UIImage *)image
                   success:(void(^)(QSAPIModelString *response))success
                      fail:(void(^)(NSError *error))fail;

- (void)changeUserPortraitUrl:(NSString *)url
                      success:(void(^)(QSAPIModel *response))success
                         fail:(void(^)(NSError *error))fail;


- (void)randomTagListSuccess:(void(^)(QSTagListReturnData *response))success
                 fail:(void(^)(NSError *error))fail;

- (void)userTagListSuccess:(void(^)(QSTagListReturnData *response))success
                      fail:(void(^)(NSError *error))fail;

- (void)userTagUpdate:(NSMutableArray *)tag_list
           success:(void(^)(QSAPIModel *response))success
              fail:(void(^)(NSError *error))fail;

- (void)userTagAdd:(NSString *)tag_id
           success:(void(^)(QSAPIModel *response))success
              fail:(void(^)(NSError *error))fail;

- (void)userTagDelete:(NSString *)tag_id
           success:(void(^)(QSAPIModel *response))success
              fail:(void(^)(NSError *error))fail;


- (void)userMerchantAddCollect:(NSString *)merchant_id
                       success:(void(^)(QSAPIModelDict *response))success
                          fail:(void(^)(NSError *error))fail;

- (void)userMerchantDelCollect:(NSString *)merchant_id
                       success:(void(^)(QSAPIModelDict *response))success
                          fail:(void(^)(NSError *error))fail;

- (void)userMerchantList:(NSInteger)page
                 success:(void(^)(QSMerchantListReturnData *response))success
                    fail:(void(^)(NSError *error))fail;

- (void)userMerchantIsCollect:(NSString *)merchant_id
                      success:(void(^)(QSAPIModelDict *response))success
                         fail:(void(^)(NSError *error))fail;

- (void)userFoodAddCollect:(NSString *)goods_id
                       success:(void(^)(QSAPIModelDict *response))success
                          fail:(void(^)(NSError *error))fail;

- (void)userFoodDelCollect:(NSString *)goods_id
                       success:(void(^)(QSAPIModelDict *response))success
                          fail:(void(^)(NSError *error))fail;

- (void)userFoodList:(NSInteger)page
                 success:(void(^)(QSFoodListReturnData *response))success
                    fail:(void(^)(NSError *error))fail;

- (void)userFoodIsCollect:(NSString *)goods_id
                      success:(void(^)(QSAPIModelDict *response))success
                         fail:(void(^)(NSError *error))fail;

- (void)userAddGood:(NSString *)be_id
               type:(kUserGoodType)type
            success:(void(^)(QSAPIModelDict *response))success
               fail:(void(^)(NSError *error))fail;

- (void)userDelGood:(NSString *)be_id
               type:(kUserGoodType)type
            success:(void(^)(QSAPIModelDict *response))success
               fail:(void(^)(NSError *error))fail;

- (void)translateWithUrl:(NSString *)url
                    type:(NSString *)type
                 success:(void(^)(NSData *response))success
                    fail:(void(^)(NSError *error))fail;

/**
 *  @author         yangshengmeng, 14-12-23 10:12:14
 *
 *  @brief          给当前用户发送短信
 *
 *  @param msg      短信内容
 *  @param callBack 发送成功或失败后的回调
 *
 *  @since          2.0
 */
- (void)sendPhoneMessageForCurrentUser:(NSString *)msg andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack;

/**
 *  @author yangshengmeng, 15-01-14 14:01:49
 *
 *  @brief  获取服务端的访问token
 *
 *  @since  2.0
 */
- (void)getToken:(void(^)(BOOL flag,NSString *token))callBack;

@end

