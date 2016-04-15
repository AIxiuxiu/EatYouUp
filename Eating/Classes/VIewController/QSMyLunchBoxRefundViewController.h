//
//  QSMyLunchBoxRefundViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@interface QSMyLunchBoxRefundViewController : QSPrepaidChannelImageViewController

@property (nonatomic,copy) void(^refundSuccessCallBack)(int flag);

@end
