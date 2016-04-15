//
//  QSAPIClientBase+Book.h
//  Eating
//
//  Created by System Administrator on 12/2/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSBookListReturnData;
@class QSBookDetailReturnData;
@interface QSAPIClientBase (Book)
//$iAddUserId = isset($aData['user_id'])?$aData['user_id']:'64';//用户id $iMerId = isset($aData['merchant_id'])?$aData['merchant_id']:'1';//商家id $bookDate = isset($aData['book_date'])?$aData['book_date']:'2015-05-28';//订单日期 $bookTime = isset($aData['book_time'])?$aData['book_time']:'15:30';//订单时间 $bookNum = isset($aData['book_num'])?$aData['book_num']:'4';//订餐人数; $bookSeatType = isset($aData['book_seat_type'])?$aData['book_seat_type']:'';//是否4人座 $bookName = isset($aData['book_name'])?$aData['book_name']:'李坤定';//订餐的用户的名字 $bookPhone = isset($aData['book_phone'])?$aData['book_phone']:'13790022418';//订餐手机 $bookDesc = isset($aData['book_desc'])?$aData['book_desc']:''; $bookMenArr = isset($aData['book_menu_arr'])?$aData['book_menu_arr']:array( array('id'=>94,'name'=>'聪哥叉烧饭1','pice'=>1,'num'=>1), array('id'=>93,'name'=>'知斯蛋糕','pice'=>120,'num'=>1), array('id'=>93,'name'=>'知斯蛋糕','pice'=>120,'num'=>1), );//菜单 
- (void)addBookWithMerchantId:(NSString *)merchant_id
                     BookDate:(NSString *)book_date
                     BookTime:(NSString *)book_time
                      BookNum:(NSString *)book_num
                 BookSeatType:(BOOL)book_seat_type
                     BookName:(NSString *)book_name
                    BookPhone:(NSString *)book_phone
                     BookDesc:(NSString *)book_desc
                      BookSex:(NSString *)book_sex
                   BookMenArr:(NSMutableArray *)book_menu_arr
                      success:(void(^)(QSAPIModelDict *response))success
                         fail:(void(^)(NSError *error))fail;

- (void)bookListWithMerchantId:(NSString *)merchant_id
                          page:(NSInteger)pageNum
                          type:(NSInteger)type
                       success:(void(^)(QSBookListReturnData *response))success
                          fail:(void(^)(NSError *error))fail;

- (void)bookDetailWithBookId:(NSString *)book_id
                     success:(void(^)(QSBookDetailReturnData *response))success
                        fail:(void(^)(NSError *error))fail;

- (void)bookDelayWithMerchantId:(NSString *)merchant_id
                        orderId:(NSString *)order_id
                        success:(void(^)(QSAPIModelDict *response))success
                           fail:(void(^)(NSError *error))fail;

@end
