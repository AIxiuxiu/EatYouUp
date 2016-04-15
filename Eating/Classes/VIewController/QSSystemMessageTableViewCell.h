//
//  QSSystemMessageTableViewCell.h
//  Eating
//
//  Created by ysmeng on 15/1/14.
//  Copyright (c) 2015年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSSystemMessageTableViewCell : UITableViewCell

/**
 *  @author     yangshengmeng, 15-01-14 12:01:33
 *
 *  @brief      显示系统消息
 *
 *  @param msg  显示系统消息
 *
 *  @since      2.0
 */
- (void)updateSystemMessage:(NSString *)msg;

@end
