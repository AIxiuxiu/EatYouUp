//
//  QSUserMessageCell.h
//  Eating
//
//  Created by System Administrator on 11/26/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSUserTalkListDetailData;
@interface QSUserMessageCell : UITableViewCell

@property (nonatomic, strong) QSUserTalkListDetailData *item;

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end
