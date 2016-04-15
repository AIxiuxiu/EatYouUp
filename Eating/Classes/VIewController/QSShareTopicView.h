//
//  QSShareTopicView.h
//  Eating
//
//  Created by ysmeng on 14/11/26.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//回调事件类型
typedef enum
{
    DEFAULT_STY = 0,
    SINA_MICROBLOG_STY,
    TENCENT_MICROBLOG_STY,
    QQ_STY,
    WECHAT_STY
}SHARE_TOPIC_TYPE;

//回调block
typedef void (^SHARE_FOODSTORE_TOMICRBLOG_BLOCK)(SHARE_TOPIC_TYPE actionType);

@interface QSShareTopicView : UIView

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(SHARE_FOODSTORE_TOMICRBLOG_BLOCK)callBack;

@property (nonatomic,copy) SHARE_FOODSTORE_TOMICRBLOG_BLOCK callBack;

@end
