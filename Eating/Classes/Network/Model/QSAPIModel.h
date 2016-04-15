//
//  QSAPIModel.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@protocol QSObjectMapping <NSObject>

+ (RKObjectMapping *)objectMapping;

@end

@interface QSAPIModel : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSArray *msg;
@property (nonatomic,copy) NSString *info;//!<注册时的回调信息
@property (nonatomic,copy) NSString *code;//!<返回结果的说明编码：比如注册时，已注册：ER0021

@end

@interface QSAPIModelString : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic,copy) NSString *code;//!<返回结果的说明编码：比如注册时，已注册：ER0021

@end

@interface QSAPIModelDict : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type; //!<延迟是否成功
@property (nonatomic, strong) NSString *msg;        //!<预约信息
@property (nonatomic,copy) NSString *ibookID;       //!<预约订单的ID

@end

@interface QSAPIBaseInfoModel : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL flag; //!<请求返回的标记：YES-成功
@property (nonatomic, copy) NSString *errorInfo;    //!<请求返回的说明信息：失败时的原因
@property (nonatomic,copy) NSString *errorCode;     //!<请求返回时的错误编码

@end

@interface QSAPITokenModel : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type; //!<请求返回的标记：YES-成功
@property (nonatomic, copy) NSString *info;         //!<请求返回的说明信息：失败时的原因
@property (nonatomic,copy) NSString *code;          //!<请求返回时的错误编码
@property (nonatomic,copy) NSString *msg;           //!<token字串

@end

@interface QSAPIModelDictddd : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSDictionary *msg;

@end