//
//  QSMyTradeListCell.m
//  Eating
//
//  Created by System Administrator on 12/19/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMyTradeListCell.h"
#import "QSAPIModel+Trade.h"
#import "QSConfig.h"
#import "UIView+UI.h"
#import "NSDate+QSDateFormatt.h"
#import "UserManager.h"

@implementation QSMyTradeListCell

- (void)setItem:(QSTradeDetailData *)item
{
    
//    0 默认
//    1 交易成功
//    2 等待付款
//    3
//    4 申请成功
//    5 交易关闭
//    6
//    7 退款中
    
    _item = item;
    self.dateLabel.text = [NSDate formatIntegerIntervalToDateAndTimeString:_item.time];
    self.nameLabel.text = _item.desc;
    [self.statusButton setTitle:[[UserManager sharedManager].tradeStatusArray objectAtIndex:[_item.status integerValue]] forState:UIControlStateNormal];
    
    ///储值卡本身的交易，隐藏价格
    if ([_item.indent_type isEqualToString:@"3"]) {
        
        self.costLabel.hidden = YES;
        
    } else {
    
        self.costLabel.hidden = NO;
    
    }
    
    [self setNeedsDisplay];
    
}

- (void)awakeFromNib {

    [self.dotLabel roundView];
    self.dotLabel.backgroundColor = kBaseLightGrayColor;
    self.lineLabel.backgroundColor = kBaseLightGrayColor;
    self.dateLabel.textColor = kBaseLightGrayColor;
    self.nameLabel.textColor = kBaseLightGrayColor;
    self.nameLabel.numberOfLines = 0;
    
}

- (void)drawRect:(CGRect)rect
{
    
    switch ([_item.status integerValue]) {
            ///
        case 0:
        {
            
        }
            break;
            
            ///
        case 1:
        {
            
            self.costLabel.text = [NSString stringWithFormat:@"-￥%@",_item.pay_num];
            [self.statusButton setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
            self.costLabel.textColor = kBaseOrangeColor;
            
        }
            break;
            
            ///
        case 2:
        {
            
            self.costLabel.text = [NSString stringWithFormat:@"-￥%@",_item.pay_num];
            [self.statusButton roundCornerRadius:CGRectGetHeight(self.statusButton.frame)/2];
            [self.statusButton setBackgroundColor:kBaseGreenColor];
            [self.statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.costLabel.textColor = kBaseOrangeColor;
            
        }
            break;
            
            ///
        case 3:
        {
            
        }
            break;
            
            ///
        case 4:
        {
            
            self.costLabel.text = [NSString stringWithFormat:@"+￥%@",_item.pay_num];
            [self.statusButton setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
            self.costLabel.textColor = kBaseGreenColor;
            
        }
            break;
            
            ///
        case 5:
        {
            
            self.costLabel.text = [NSString stringWithFormat:@"-￥%@",_item.pay_num];
            [self.statusButton setTitleColor:kBaseLightGrayColor forState:UIControlStateNormal];
            self.costLabel.textColor = kBaseLightGrayColor;

        }
            break;
            
            ///
        case 6:
        {
            
        }
            break;
            
            ///
        case 7:
        {
            
            self.costLabel.text = [NSString stringWithFormat:@"+￥%@",_item.pay_num];
            [self.statusButton setTitleColor:kBaseGreenColor forState:UIControlStateNormal];
            self.costLabel.textColor = kBaseGreenColor;
            
        }
            break;
            
        default:
            break;
    }
}

@end
