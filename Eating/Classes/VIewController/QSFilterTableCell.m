//
//  QSFilterTableCell.m
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSFilterTableCell.h"
#import "QSConfig.h"

@implementation QSFilterTableCell

- (void)awakeFromNib {

    self.textLabel.textColor = kBaseGrayColor;
    self.swi.onTintColor = kBaseGreenColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
