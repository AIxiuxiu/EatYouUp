//
//  QSSystemMessageTableViewCell.m
//  Eating
//
//  Created by ysmeng on 15/1/14.
//  Copyright (c) 2015年 Quentin. All rights reserved.
//

#import "QSSystemMessageTableViewCell.h"
#import "QSConfig.h"

@interface QSSystemMessageTableViewCell ()

@property (nonatomic,strong) UIWebView *messageView;//!<信息显示view

@end

@implementation QSSystemMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.messageView = [[UIWebView alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, 5.0f, DEFAULT_MAX_WIDTH, 80.0f)];
        
        self.messageView.backgroundColor = [UIColor whiteColor];
        self.messageView.layer.cornerRadius = 6.0f;
        
        [self.contentView addSubview:self.messageView];
        
    }
    
    return self;

}

- (void)updateSystemMessage:(NSString *)msg
{

    if (msg) {
        
        [self.messageView loadHTMLString:msg baseURL:nil];
        
    }

}

@end
