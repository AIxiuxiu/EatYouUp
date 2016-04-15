//
//  QSFoodCommentListCell.h
//  Eating
//
//  Created by MJie on 14-11-11.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSCommentDetailData;
@interface QSFoodCommentListCell : UITableViewCell

@property (nonatomic, strong) QSCommentDetailData *item;

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

+ (CGFloat)cellHeight:(QSCommentDetailData *)item;

@end
