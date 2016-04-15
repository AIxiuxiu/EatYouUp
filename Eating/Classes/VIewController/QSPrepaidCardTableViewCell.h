//
//  QSPrepaidCardTableViewCell.h
//  Eating
//
//  Created by ysmeng on 14/11/28.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//cell类型
typedef enum
{
    DEFAULT_PREPAIDCT = 0,
    FIRSTLINE_CELL_PREPAIDCT,
    MIDDLELINE_CELL_PREPAIDCT,
    LASTLINE_CELL_PREPAIDCT,
    ADDMORE_LASTLINE_CELL_PREPAIDCT,
    NONEPRPAIDCARD_CELL_PREPAIDCT,
    SINGLELINE_CELL_PREPAIDCT
}PREPAIDCARD_NORMAL_CELLTYPE;

@class QSMarCouponDetailDataModel;
@interface QSPrepaidCardTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCellType:(PREPAIDCARD_NORMAL_CELLTYPE)cellType;

//刷新UI
- (void)updatePrepaidCardCellUI:(QSMarCouponDetailDataModel *)cellModel;

@end
