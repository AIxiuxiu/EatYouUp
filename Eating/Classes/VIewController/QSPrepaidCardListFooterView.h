//
//  QSPrepaidCardListFooterView.h
//  Eating
//
//  Created by ysmeng on 14/11/28.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//回调类型
typedef enum
{
    DEFAULT_PLFA = 0,
    LOADMORE_PLFA
}PREPAIDCARD_LIST_FOOTER_ACTIONTYPE;

@interface QSPrepaidCardListFooterView : UIView

//回调block
@property (nonatomic,copy) void(^callBack)(PREPAIDCARD_LIST_FOOTER_ACTIONTYPE actionType,BOOL flag);

- (instancetype)initWithFrame:(CGRect)frame andStatus:(BOOL)status andCallBack:(void(^)(PREPAIDCARD_LIST_FOOTER_ACTIONTYPE actionType,BOOL flag))callBack;

- (void)resetFooterStatus:(BOOL)flag;

@end
