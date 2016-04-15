//
//  QSYTalkInfoTableViewCell.h
//  Eating
//
//  Created by ysmeng on 14/12/26.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSFoodGroudTalkMessageDataModel;
@interface QSYTalkInfoTableViewCell : UITableViewCell

/**
 *  @author             yangshengmeng, 14-12-26 10:12:05
 *
 *  @brief              根据信息数据模型，更新cell
 *
 *  @param infoModel    服务端返回的聊天信息数据模型
 *
 *  @since              2.0
 */
- (void)updateTalkInfoCellUIWithModel:(QSFoodGroudTalkMessageDataModel *)infoModel;

@end
