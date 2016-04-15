//
//  QSMarAcNoticeTableViewCell.h
//  Eating
//
//  Created by ysmeng on 14/11/20.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//cell 类型
typedef enum
{
    DEFAULT_CT = 0,
    FOODDETECTIVE_HEADER_CT,
    FOODDETECTIVE_NORMAL_CT
}FOODDETECTIVE_CELL_TYPE;

//当前显示的图片下标回调
typedef void (^FOODDETECTIVE_RECOMMEND_HEADER_INDEX_BLOCK)(NSInteger index);

@interface QSMarAcNoticeTableViewCell : UITableViewCell

@property (nonatomic,copy) FOODDETECTIVE_RECOMMEND_HEADER_INDEX_BLOCK callBack;

//初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCellType:(FOODDETECTIVE_CELL_TYPE)cellType;

//刷新UI
- (void)updateUIWithModel:(id)model andType:(FOODDETECTIVE_CELL_TYPE)cellType;

@end
