//
//  QSMerchantChatCell1.h
//  Eating
//
//  Created by System Administrator on 12/17/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSMerchantChatDetailData;
@interface QSMerchantChatCell1 : UITableViewCell

@property (nonatomic, copy) NSString *merchantLogoUrl;
@property (nonatomic, strong) QSMerchantChatDetailData *item;

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end
