//
//  QSNotificationDataModel.h
//  Eating
//
//  Created by ysmeng on 15/1/14.
//  Copyright (c) 2015年 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSNotificationDataModel : NSObject

@property (nonatomic,assign) BOOL readFlag;//!<阅读标记：YES-已读 NO-未读

@property (nonatomic,copy) NSString *soundFile;     //!<声音文件
@property (nonatomic,copy) NSString *showMessage;   //!<展现的信息

@property (nonatomic,copy) NSString *messageType;   //!<消息类型
@property (nonatomic,copy) NSString *targetID;      //!<对应类型单据的ID
@property (nonatomic,copy) NSString *messageTitle;  //!<消息标题

@end
