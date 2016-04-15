//
//  QSTakeoutOrderListCell.m
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSTakeoutOrderListCell.h"
#import "QSAPIModel+Takeout.h"
#import "QSAPIModel+Book.h"
#import "QSConfig.h"
#import "UIView+UI.h"

@implementation QSTakeoutOrderListCell

- (void)setTakeoutStatus:(kTakeoutOrderStatus)takeoutStatus
{
    
    _takeoutStatus = takeoutStatus;
    
    switch (_takeoutStatus) {
            
            ///已删除
        case kTakeoutOrderStatus_Delect:
            
            self.statusView.backgroundColor = kBaseLightGrayColor;
            self.statusIcon.image = IMAGENAME(@"takeout_orderstatus_icon3.png");
            self.statusLabel.text = @"已取消";
            
            break;
            
            ///已付款
        case kTakeoutOrderStatus_Pay:
            
            ///未送餐
        case kTakeoutOrderStatus_UnDelivered:
            
            ///已送餐
        case kTakeoutOrderStatus_Delivered:
            
            self.statusView.backgroundColor = kBaseOrangeColor;
            self.statusIcon.image = IMAGENAME(@"takeout_orderstatus_icon2.png");
            self.statusLabel.text = @"送餐中";
            
            break;
            
            ///已确认
        case kTakeoutOrderStatus_Confirm:
            
            self.statusView.backgroundColor = kBaseLightGrayColor;
            self.statusIcon.image = IMAGENAME(@"takeout_orderstatus_icon3.png");
            self.statusLabel.text = @"已签收";
            
            break;
            
            ///已取消
        case kTakeoutOrderStatus_Cancelled:
            
            self.statusView.backgroundColor = kBaseLightGrayColor;
            self.statusIcon.image = IMAGENAME(@"takeout_orderstatus_icon4.png");
            self.statusLabel.text = @"已取消";
            
            break;
            
            ///未付款
        case kTakeoutOrderStatus_Unpay:
            
            self.statusView.backgroundColor = kBaseGreenColor;
            self.statusIcon.image = IMAGENAME(@"takeout_orderstatus_icon1.png");
            self.statusLabel.text = @"待付款";
            
            break;
    
    }
    
    [self.statusView roundView];
}

- (void)setBookStatus:(kBookOrderStatus)bookStatus
{
    _bookStatus = bookStatus;
    if (_bookStatus == kBookOrderStatus_UnConfirm) {
        self.statusView.backgroundColor = kBaseGreenColor;
        self.statusIcon.image = IMAGENAME(@"takeout_orderstatus_icon2.png");
        self.statusLabel.text = @"待确认";
    }
    else if (_bookStatus == kBookOrderStatus_Booking){
        self.statusView.backgroundColor = kBaseGreenColor;
        self.statusIcon.image = IMAGENAME(@"takeout_orderstatus_icon3.png");
        self.statusLabel.text = @"预约中";
    }
    else if (_bookStatus == kBookOrderStatus_Inqueue){
        self.statusView.backgroundColor = kBaseOrangeColor;
        self.statusIcon.image = IMAGENAME(@"takeout_orderstatus_icon2.png");
        self.statusLabel.text = @"排队中";
    }
    else if (_bookStatus == kBookOrderStatus_Confirmed){
        self.statusView.backgroundColor = kBaseOrangeColor;
        self.statusIcon.image = IMAGENAME(@"takeout_orderstatus_icon3.png");
        self.statusLabel.text = @"已到号";
    }
    else if (_bookStatus == kBookOrderStatus_Inshop){
        self.statusView.backgroundColor = kBaseLightGrayColor;
        self.statusIcon.image = IMAGENAME(@"takeout_orderstatus_icon3.png");
        self.statusLabel.text = @"已到店";
    }
    else if (_bookStatus == kBookOrderStatus_RestCanceled || _bookStatus == kBookOrderStatus_ClientCanceled){
        self.statusView.backgroundColor = kBaseLightGrayColor;
        self.statusIcon.image = IMAGENAME(@"takeout_orderstatus_icon4.png");
        self.statusLabel.text = @"已取消";
    }
    [self.statusView roundView];
}

- (void)setItem:(id)item
{
    _item = item;
    
    if ([_item isKindOfClass:[QSTakeoutDetailData class]]) {
        
        QSTakeoutDetailData *info = _item;
        self.nameLabel.text = info.merchant_name;
        self.memoLabel.text = [NSString stringWithFormat:@"需要%@送餐",info.take_out_time];
        self.nameLabel.textColor = kBaseGrayColor;
        self.memoLabel.textColor = kBaseGrayColor;
        self.countLabel.textColor = kBaseGrayColor;
        self.takeoutStatus = [info.status intValue];
        self.countView = [UIView takeoutCountWithNum:info.take_num_count Color:kBaseGrayColor];
        [self.contentView addSubview:self.countView];
        
    } else if ([_item isKindOfClass:[QSBookDetailData class]]){
        
        QSBookDetailData *info = _item;
        self.nameLabel.text = info.merchant_name;
        self.memoLabel.text = [NSString stringWithFormat:@"%@  %@",info.book_date,info.book_time];
        self.nameLabel.textColor = kBaseGrayColor;
        self.memoLabel.textColor = kBaseGrayColor;
        self.countLabel.textColor = kBaseGrayColor;
        self.bookStatus = [info.status intValue];
        self.countView = [UIView bookCountWithNum:info.book_num Color:kBaseGrayColor];
        [self.contentView addSubview:self.countView];
        
    }
    
    
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect
{
    self.countView.center = CGPointMake(DeviceWidth-50, CGRectGetHeight(self.frame)/2);
}

- (void)awakeFromNib {

    [self.infoView roundCornerRadius:6];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
