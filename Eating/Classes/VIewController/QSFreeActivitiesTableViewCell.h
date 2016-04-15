//
//  QSFreeActivitiesTableViewCell.h
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSFreeActivitiesStoreModel;
@interface QSFreeActivitiesTableViewCell : UITableViewCell

- (void)updateFreeActivityCellUIWithModel:(QSFreeActivitiesStoreModel *)model;

@end
