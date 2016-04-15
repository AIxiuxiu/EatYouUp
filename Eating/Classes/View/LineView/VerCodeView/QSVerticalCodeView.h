//
//  QSVerticalCodeView.h
//  Eating
//
//  Created by ysmeng on 14/11/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//单击事件回调
typedef void (^VERTICALCODEL_VIEW_CALLBACK_BLOCK)(NSString *verCode);

@interface QSVerticalCodeView : UIView

@property (nonatomic,copy) VERTICALCODEL_VIEW_CALLBACK_BLOCK callBack;

@end
