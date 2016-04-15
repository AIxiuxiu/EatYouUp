//
//  QSPrepaidCardDetailTabbarView.h
//  Eating
//
//  Created by ysmeng on 14/11/29.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//回调
typedef enum
{
    DETAUL_PDTC = 0,
    FIRST_BUTTON_PDTC,
    SECONDE_BUTTON_PDTC,
    THIRD_BUTTON_PDTC,
    FOUR_BUTTON_PDTC
    
}PREPAIDCARD_DETAIL_TABBAR_CALLBACKTYPE;

@interface QSPrepaidCardDetailTabbarView : UIView

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(PREPAIDCARD_DETAIL_TABBAR_CALLBACKTYPE actionType))callBack;

@property (nonatomic,copy ) void(^callBack)(PREPAIDCARD_DETAIL_TABBAR_CALLBACKTYPE actionType);

@end
