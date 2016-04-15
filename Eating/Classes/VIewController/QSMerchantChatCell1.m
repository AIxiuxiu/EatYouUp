//
//  QSMerchantChatCell1.m
//  Eating
//
//  Created by System Administrator on 12/17/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMerchantChatCell1.h"
#import <UIImageView+AFNetworking.h>
#import "QSAPIModel+User.h"
#import "UserManager.h"
#import "UIView+UI.h"
#import "QSConfig.h"
#import "NSDate+QSDateFormatt.h"
#import "QSAPIModel+Message.h"
#import "NSString+Name.h"

@implementation QSMerchantChatCell1

- (void)setItem:(QSMerchantChatDetailData *)item
{
    _item = item;
    [self.portraitImageView setImageWithURL:[NSURL URLWithString:[self.item.merchant_logo imageUrl]] placeholderImage:nil];
    self.timeLabel.text = [NSDate formatIntegerIntervalToDateAMPMString:_item.send_time];
    self.contentLabel.text = [NSString stringWithFormat:@"  %@",_item.content];
    
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    
    self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 20, 50, 50)];
    [self.portraitImageView roundView];
    [self.contentView addSubview:self.portraitImageView];
    self.portraitImageView.backgroundColor = [UIColor orangeColor];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 5, 130, 21)];
    self.timeLabel.textColor = kBaseGrayColor;
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.timeLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 25, DeviceWidth-120, 150)];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.backgroundColor = kBaseLightGrayColor;
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.contentLabel];
    
}

- (void)drawRect:(CGRect)rect
{
    
    CGSize size = [_item.content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(DeviceWidth-130, 300) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = self.contentLabel.frame;
    frame.size.width = size.width + 10.0f;
    frame.size.height = size.height + 10.0f;
    self.contentLabel.frame = frame;
    
    [self.contentLabel roundCornerRadius:(self.contentLabel.frame.size.height)/2];
}

@end
