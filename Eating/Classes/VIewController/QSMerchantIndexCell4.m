//
//  QSMerchantIndexCell4.m
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMerchantIndexCell4.h"
#import "QSAPIModel+Merchant.h"
#import "UIView+UI.h"
@implementation QSMerchantIndexCell4

- (void)setItem:(QSMerchantDetailData *)item
{
    _item = item;
}

- (void)awakeFromNib {

    self.button1.tag = 1;
    self.button2.tag = 2;
    self.button3.tag = 3;
    self.button4.tag = 4;
    
    self.button5.tag = 5;
    self.button6.tag = 6;
    self.button7.tag = 7;
    self.button8.tag = 8;
    [self.bgImageView roundCornerRadius:5];
    [self.button1 addTarget:self
                     action:@selector(onButtonAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self
                     action:@selector(onButtonAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.button3 addTarget:self
                     action:@selector(onButtonAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.button4 addTarget:self
                     action:@selector(onButtonAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.button5 addTarget:self
                     action:@selector(onButtonAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.button6 addTarget:self
                     action:@selector(onButtonAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.button7 addTarget:self
                     action:@selector(onButtonAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.button8 addTarget:self
                     action:@selector(onButtonAction:)
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)onButtonAction:(id)sender
{
    UIButton *button = sender;
    if (self.onButtonHandler) {
        self.onButtonHandler(button.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
