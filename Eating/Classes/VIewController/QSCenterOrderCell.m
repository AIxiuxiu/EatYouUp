//
//  QSCenterOrderCell.m
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSCenterOrderCell.h"
#import "QSConfig.h"
@implementation QSCenterOrderCell

- (void)awakeFromNib {

    self.nameLabel.textColor = kBaseGrayColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
