//
//  QSPaymentModeView.h
//  Eating
//
//  Created by ysmeng on 14/12/1.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//支付方式
typedef enum
{
    DEFAULT_QSPT = 0,
    TAOBAO_QSPT,
    TAOBAO_ISEIXTORDER_QSPT
}QSPAYMENTMODE_TYPE;

@interface QSPaymentModeView : UIView

//支付方式选择窗口
+ (void)showPaymentTypeChoice:(UIView *)target andType:(QSPAYMENTMODE_TYPE)type andCallBack:(void(^)(NSString *typeName,QSPAYMENTMODE_TYPE payType))callBack;

- (instancetype)initWithFrame:(CGRect)frame andType:(QSPAYMENTMODE_TYPE)type andCallBack:(void(^)(NSString *typeName,QSPAYMENTMODE_TYPE payType))callBack;

@property (nonatomic,copy) void(^callBack)(NSString *typeName,QSPAYMENTMODE_TYPE payType);

@end
