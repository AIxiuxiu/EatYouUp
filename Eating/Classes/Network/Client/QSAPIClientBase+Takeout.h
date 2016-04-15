//
//  QSAPIClientBase+Takeout.h
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSTakeoutListReturnData;
@class QSTakeoutDetailReturnData;
@class QSAlixPayTakeoutReturnData;
@interface QSAPIClientBase (Takeout)

- (void)userTakeoutOrderListWithMerchantId:(NSString *)merchant_id
                                      page:(NSInteger)pageNum
                                      type:(NSInteger)type
                              success:(void(^)(QSTakeoutListReturnData *response))success
                                 fail:(void(^)(NSError *error))fail;

- (void)takeoutOrderDetail:(NSString *)takeout_id
                   success:(void(^)(QSTakeoutDetailReturnData *response))success
                      fail:(void(^)(NSError *error))fail;

/** user_id         :'64';          //用户id
    merchant_id     :'1';           //商家id
    book_date       :'2015-05-28';  //订单日期
    book_time       :'15:30';       //订单时间
    book_num        :'4';           //订餐人数;
    book_seat_type  :'';            //是否4人座
    book_name       :'李坤定';       //订餐的用户的名字
    book_phone      :'13790022418'; //订餐手机
    book_desc       :'';
    book_menu_arr   :array ( array('id'=>94,'name'=>'聪哥叉烧饭1','pice'=>1),
                             array('id'=>93,'name'=>'知斯蛋糕','pice'=>120),
                             array('id'=>93,'name'=>'知斯蛋糕','pice'=>120), );// 外卖的预定
    coupon_list     :array();
    add             :"";                 //送餐地址
 */
- (void)addTakeout:(NSString *)merchant_id
          bookDate:(NSString *)take_out_date
          bookTime:(NSString *)take_out_time
          bookName:(NSString *)take_out_name
         bookPhone:(NSString *)take_out_phone
          bookDesc:(NSString *)take_out_desc
          totalNum:(NSString *)total_num
        totalMoney:(NSString *)total_money
        bookMenArr:(NSArray *)book_menu_arr
        couponList:(NSArray *)coupon_list
           address:(NSString *)address
               sex:(NSString *)sex
           payType:(NSString *)pay_type
           success:(void(^)(QSAPIModelDictddd *response))success
              fail:(void(^)(NSError *error))fail;

//*user_id int 用户id
//*indent_id int 订单id
//*online_money float 在线支付的
//*pay_type int 支付类型
//*indent_type int 订单类型
//store_card_list array
//结构 array(
//         *store_id  int 用户领取到的储值卡id，
//         *use_val  float 使用的价格
//         *limit_val  float 使用后剩余的价格
//         name string 储值卡的名字
//         )
//store_card_money float 储值卡要给的总价
- (void)makePayOrder:(NSString *)indent_id
        online_money:(NSString *)online_money
            pay_type:(NSString *)pay_type
         indent_type:(NSString *)indent_type
     store_card_list:(NSArray *)store_card_list
             success:(void(^)(QSAlixPayTakeoutReturnData *response))success
                fail:(void(^)(NSError *error))fail;

/**
 *  @author         yangshengmeng, 15-01-06 16:01:28
 *
 *  @brief          储值卡支付
 *
 *  @param dict     储值卡支付的参数
 *  @param callBack 支付的结果
 *
 *  @since          2.0
 */
- (void)prepaidCardPay:(NSDictionary *)dict andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack;

/**
 *  @author             yangshengmeng, 15-01-06 20:01:08
 *
 *  @brief              确认支付结果
 *
 *  @param commitDict   确认参数
 *
 *  @since              2.0
 */
- (void)commitPay:(NSDictionary *)commitDict andCallBack:(void(^)(BOOL flag,NSString *errorInfo,NSString *errorCode))callBack;

@end
