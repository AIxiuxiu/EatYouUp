//
//  QSAPIModel+User.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"
#import <CoreLocation/CLLocation.h>

@interface QSAPIModel (User)

@end

@interface QSUserReturnCheckData : NSObject<QSObjectMapping>

@property (nonatomic,assign) BOOL type;//!<成功与否的标记
@property (nonatomic,copy) NSString *errorInfo;//!<错误提示信息
@property (nonatomic,copy) NSString *errorCode;//!<错误编码

@end

@class QSUserData;
@interface QSUserReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) QSUserData *userData;

@end

@class AMapReGeocodeSearchResponse;
@interface QSUserData : NSObject<QSObjectMapping>

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *iphone;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *reg_time;
@property (nonatomic, copy) NSString *vip;
@property (nonatomic, copy) NSString *honour;
@property (nonatomic, copy) NSString *iteam_list;
@property (nonatomic, copy) NSString *this_login_time;
@property (nonatomic, copy) NSString *last_login_time;
@property (nonatomic, copy) NSString *this_login_ip;
@property (nonatomic, copy) NSString *last_login_ip;
@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, copy) NSString *tag_list;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *integrity;
@property (nonatomic, copy) NSString *active;
@property (nonatomic, copy) NSString *push_id;
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *temp_key;

@property (nonatomic,copy) NSString *default_address;//!<送餐地址

@property (nonatomic, unsafe_unretained) CLLocationCoordinate2D location;
@property (nonatomic, strong) AMapReGeocodeSearchResponse *reGeocodeSearchResponse;
@property (nonatomic, copy) NSString *adcode;

- (BOOL)hadUserId;

@end

@interface QSTagListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end



