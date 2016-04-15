//
//  QSAPIModel+AddFoodGroud.h
//  Eating
//
//  Created by ysmeng on 14/12/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (AddFoodGroud)

@end

/**
 *  @author yangshengmeng, 14-12-21 17:12:11
 *
 *  @brief  增加搭食团返回的数据
 *
 *  @since  2.0
 */
@interface QSAddFoodGroudReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;     //!<返回状态
@property (nonatomic,copy) NSString *errorInfo;         //!<错误说明信息
@property (nonatomic,copy) NSString *errorCode;         //!<错误代码

@end