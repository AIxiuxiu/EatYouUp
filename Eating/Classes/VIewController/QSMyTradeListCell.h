//
//  QSMyTradeListCell.h
//  Eating
//
//  Created by System Administrator on 12/19/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSTradeDetailData;
@interface QSMyTradeListCell : UITableViewCell

@property (nonatomic, strong) QSTradeDetailData *item;

@property (weak, nonatomic) IBOutlet UILabel *dotLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@end
