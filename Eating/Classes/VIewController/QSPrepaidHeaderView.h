//
//  QSPrepaidHeaderView.h
//  Eating
//
//  Created by ysmeng on 14/11/28.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSMarchantBaseInfoDataModel;
@interface QSPrepaidHeaderView : UIView

//刷新UI
- (void)updatePrepaidCardHeaderUI:(QSMarchantBaseInfoDataModel *)headerModel;

@end
