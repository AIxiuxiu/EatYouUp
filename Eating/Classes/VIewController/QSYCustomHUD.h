//
//  QSYCustomHUD.h
//  Eating
//
//  Created by ysmeng on 14/12/14.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSYCustomHUD : UIView

/**
 *  @author yangshengmeng, 14-12-14 12:12:17
 *
 *  @brief  加盖HUD
 *
 *  @return 返回当前HUD的指针
 *
 *  @since  2.0
 */
+ (instancetype)showOperationHUD:(UIView *)targetView;

/**
 *  @author yangshengmeng, 14-12-14 12:12:17
 *
 *  @brief  加盖HUD
 *
 *  @return 返回当前HUD的指针
 *
 *  @since  2.0
 */
+ (instancetype)hiddenOperationHUD;

@end
