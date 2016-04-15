//
//  QSDeliveryListCell.m
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSDeliveryListCell.h"
#import "QSAPIModel+Delivery.h"
#import "QSConfig.h"
#import "UIView+UI.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"

@implementation QSDeliveryListCell

- (void)setItem:(QSDeliveryDetailData *)item
{
    _item = item;
    NSArray *temp = [UserManager sharedManager].countyArray;
    NSArray *temp1 = [UserManager sharedManager].countyCodeArray;
    self.nameLabel.text = [NSString stringWithFormat:@"姓名:  %@",_item.name];
    self.mobileLabel.text = [NSString stringWithFormat:@"手机:  %@",_item.phone];
    NSInteger index = [temp1 indexOfObject:_item.area];
    if (index <= temp.count-1) {
        self.areaLabel.text = [NSString stringWithFormat:@"省市:  %@ %@ %@",@"广东省",@"广州市",temp[index]];
    }
    self.addressLabel.text = [NSString stringWithFormat:@"地址:  %@",_item.address];
    self.nikeLabel.hidden = ![_item.status isEqualToString:@"1"];

    [self setNeedsDisplay];
}

- (void)awakeFromNib {

    self.backgroundColor = kBaseBackgroundColor;
    self.nikeLabel.textColor = kBaseOrangeColor;
    self.nameLabel.textColor = kBaseGrayColor;
    self.mobileLabel.textColor = kBaseGrayColor;
    self.areaLabel.textColor = kBaseGrayColor;
    self.addressLabel.textColor = kBaseGrayColor;

    
    self.infoView.backgroundColor = [UIColor whiteColor];
    [self.infoView roundCornerRadius:4];
    
    self.menuView.backgroundColor = kBaseOrangeColor;
    [self.menuView roundCornerRadius:4];
    
    [self.tapButton addTarget:self
                       action:@selector(onTapButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self
                       action:@selector(onDeleteButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
    

    
}

- (void)drawRect:(CGRect)rect
{
    CGRect frame = self.infoView.frame;
    frame.size.width = DeviceWidth - 20;
    self.infoView.frame = frame;
    
    frame = self.menuView.frame;
    frame.origin.x = DeviceWidth;
    self.menuView.frame = frame;
    
    self.containScrollowView.contentSize = CGSizeMake(DeviceWidth + 190, 118);
}

- (IBAction)onTapButtonAction:(id)sender
{
    if (self.onTapButtonHandler) {
        self.onTapButtonHandler();
    }
}

- (IBAction)onDeleteButtonAction:(id)sender
{
    if (self.onDeleteButtonHandler) {
        self.onDeleteButtonHandler();
    }
}

@end
