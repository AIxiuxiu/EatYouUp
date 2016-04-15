//
//  QSLeftTitleBlockButton.h
//  Eating
//
//  Created by ysmeng on 14/12/1.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSBlockActionButton.h"

@interface UIButton (QSLeftTitleBlockButton)

+ (UIButton *)createLeftTitleButton:(CGRect)frame andStyle:(QSButtonStyleModel *)buttonStyle andCallBack:(void(^)(UIButton *button))callBack;

@end

@interface QSLeftTitleBlockButton : QSBlockActionButton

@end
