//
//  QSTakeoutCouponListCell.h
//  Eating
//
//  Created by System Administrator on 12/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSCouponDetailData;
@interface QSTakeoutCouponListCell : UITableViewCell


@property (nonatomic, strong) QSCouponDetailData *item;
@property (nonatomic, unsafe_unretained) NSInteger bgType; //0  顶  1  中间  2  底

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) UIView *priceView;

@end
