//
//  QSMyTaskTableViewCell.h
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSMyTaskDataModel;
@interface QSMyTaskTableViewCell : UITableViewCell

- (void)updateMyTaskCellUIWithModel:(QSMyTaskDataModel *)model;

@end
