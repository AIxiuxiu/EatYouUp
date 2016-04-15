//
//  QSPhoneVerification.h
//  Eating
//
//  Created by ysmeng on 14/12/1.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSPhoneVerification : UIView

- (instancetype)initWithFrame:(CGRect)frame andPhoneField:(UITextField *)phoneField andCallBack:(void(^)(NSString *verCode))callBack;

@property (nonatomic,copy) void(^callBack)(NSString *verCode);

@end
