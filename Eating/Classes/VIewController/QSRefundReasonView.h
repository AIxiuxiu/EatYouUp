//
//  QSRefundReasonView.h
//  Eating
//
//  Created by ysmeng on 14/12/8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSRefundReasonView : UIView

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(NSString *reason,int index))callBack;

@property (nonatomic,copy) void(^callBack)(NSString *reason,int index);

@end
