//
//  QSAPIModel+Merchant.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (Merchant)

@end

@interface QSMerchantListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *msg;

@end

@interface QSMerchantDetailData : NSObject<QSObjectMapping>

@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, copy) NSString *merchant_name;
@property (nonatomic, copy) NSString *merchant_branch;
@property (nonatomic, copy) NSString *merchant_alias;
@property (nonatomic, copy) NSString *merchant_logo;
@property (nonatomic, copy) NSString *merchant_image;
@property (nonatomic, copy) NSString *merchant_sounds;
@property (nonatomic, copy) NSString *merchant_video;
@property (nonatomic, copy) NSString *merchant_desc;
@property (nonatomic, copy) NSString *taste_sec;
@property (nonatomic, copy) NSString *environmental_sec;
@property (nonatomic, copy) NSString *service_sec;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *altitude;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *merchant_call;
@property (nonatomic, copy) NSString *merchant_traffic;
@property (nonatomic, copy) NSString *merchant_wifi;
@property (nonatomic, copy) NSString *merchant_marketing_num;
@property (nonatomic, copy) NSString *merchant_per;
@property (nonatomic, copy) NSString *merchant_star;
@property (nonatomic, copy) NSString *merchant_start_time;
@property (nonatomic, copy) NSString *merchant_end_time;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *score_taste;
@property (nonatomic, copy) NSString *score_envirement;
@property (nonatomic, copy) NSString *score_service;
@property (nonatomic, copy) NSString *good_num;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *merchant_othername;
@property (nonatomic, copy) NSString *merchant_manager;
@property (nonatomic, copy) NSString *merchant_manager_phone;
@property (nonatomic, copy) NSString *merchant_phone;
@property (nonatomic, strong) NSMutableArray *pro;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, strong) NSMutableDictionary *free_service;
@property (nonatomic, copy) NSString *merchant_tag_old;
@property (nonatomic, strong) NSMutableDictionary *merchant_tag;
@property (nonatomic, copy) NSString *merchant_ser;
@property (nonatomic, copy) NSString *business_type;
@property (nonatomic, copy) NSString *business_area;
@property (nonatomic, copy) NSString *referrals;



@property (nonatomic, copy) NSString *metro;
@property (nonatomic, copy) NSString *metro_line;
@property (nonatomic, copy) NSString *city_sign;
@property (nonatomic, copy) NSString *hasTimePro;
@property (nonatomic, copy) NSString *hasGreensPro;
@property (nonatomic, copy) NSString *hasVipPro;
@property (nonatomic, copy) NSString *hasMoneyCoup;
@property (nonatomic, copy) NSString *hasDisCoup;
@property (nonatomic, copy) NSString *hasGreensCroup;
@property (nonatomic, copy) NSString *banner;;
@property (nonatomic, copy) NSString *coupon_count;
@property (nonatomic, copy) NSString *team_activity_count;
@property (nonatomic, copy) NSString *isGood;
@property (nonatomic, copy) NSString *isStore;

@property (nonatomic, strong) NSMutableArray *merchant_image_arr;
@property (nonatomic, strong) NSMutableArray *menu_list;
@property (nonatomic, strong) NSMutableArray *mar_menu_list;
@property (nonatomic, strong) NSMutableArray *coup;
@property (nonatomic, strong) NSMutableArray *merchant_ser_new;
@end

@interface QSMerchantIndexReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) QSMerchantDetailData *data;

@end



