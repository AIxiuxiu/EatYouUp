//
//  QSMerchantChatCell2.m
//  Eating
//
//  Created by System Administrator on 12/17/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMerchantChatCell2.h"
#import <UIImageView+AFNetworking.h>
#import "QSAPIModel+User.h"
#import "UserManager.h"
#import "UIView+UI.h"
#import "QSConfig.h"
#import "NSDate+QSDateFormatt.h"
#import "QSAPIModel+Message.h"
#import "NSString+Name.h"

@implementation QSMerchantChatCell2



- (void)setItem:(QSMerchantChatDetailData *)item
{
    _item = item;
    
    NSString *logoURL = [UserManager sharedManager].userData.logo;
    [self.portraitImageView setImageWithURL:[NSURL URLWithString:[logoURL imageUrl]] placeholderImage:nil];
    self.timeLabel.text = [NSDate formatIntegerIntervalToDateAMPMString:_item.send_time];
    self.contentLabel.text = [NSString stringWithFormat:@" %@",_item.content];

    [self setNeedsDisplay];
}

#if 1
- (void)awakeFromNib
{
    
    self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceWidth-70, 20, 50, 50)];
    [self.portraitImageView roundView];
    [self.contentView addSubview:self.portraitImageView];
    self.portraitImageView.backgroundColor = [UIColor orangeColor];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth-210.0f, 5, 130, 21)];
    self.timeLabel.textColor = kBaseGrayColor;
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth-110.0f, 30, 30, 150)];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.backgroundColor = kBaseGreenColor;
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:self.contentLabel];
    
}
#endif

#if 1
- (void)drawRect:(CGRect)rect
{
    CGSize size = [_item.content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(DeviceWidth-120.0f, 300.0f) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect frame = self.contentLabel.frame;
    CGFloat width = size.width > 30.0f ? (size.width + 20.0f) : 40.0f;
    frame.origin.x = DeviceWidth - width - 80.0f;
    frame.size.width = width;
    frame.size.height = size.height + 10.0f;
    self.contentLabel.frame = frame;
    
    [self.contentLabel roundCornerRadius:(self.contentLabel.frame.size.height)/2];
}
#endif

@end
