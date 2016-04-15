//
//  QSUserMessageCell.m
//  Eating
//
//  Created by System Administrator on 11/26/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSUserMessageCell.h"
#import "QSAPIModel+Message.h"
#import "NSDate+QSDateFormatt.h"
#import "QSConfig.h"
#import <UIImageView+AFNetworking.h>
#import "UIView+UI.h"

@implementation QSUserMessageCell

- (void)setItem:(QSUserTalkListDetailData *)item
{
    
    _item = item;
    self.nameLabel.text = _item.to_name;
    self.contentLabel.text = _item.content;
    self.dateLabel.text = [NSDate formatIntegerIntervalToDateString:_item.send_time];
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_item.merchant_logo] placeholderImage:nil];
    
}

- (void)awakeFromNib {

    [self.containView roundCornerRadius:5];
    self.nameLabel.textColor = kBaseGrayColor;
    self.contentLabel.textColor = kBaseLightGrayColor;
    self.dateLabel.textColor = kBaseLightGrayColor;
    [self.logoImageView roundView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
