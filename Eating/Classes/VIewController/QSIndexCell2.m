//
//  QSIndexCell2.m
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSIndexCell2.h"
#import "QSConfig.h"

@implementation QSIndexCell2

- (void)awakeFromNib {

    self.backgroundColor = [UIColor clearColor];
    [self.containView.layer setCornerRadius:kButtonDefaultCornerRadius];
    
    self.icon1Label.textColor = kBaseGrayColor;
    self.icon2Label.textColor = kBaseGrayColor;
    
    self.icon1Button.tag = 0;
    self.icon2Button.tag = 1;
    
    [self.icon1Button addTarget:self action:@selector(onIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.icon2Button addTarget:self action:@selector(onIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)onIconButtonAction:(id)sender
{
    UIButton *button = sender;
    if (self.onIconButtonHandler) {
        self.onIconButtonHandler(button.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
