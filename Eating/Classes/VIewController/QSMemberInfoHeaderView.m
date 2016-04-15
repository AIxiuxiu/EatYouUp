//
//  QSMemberInfoHeaderView.m
//  Eating
//
//  Created by ysmeng on 14/12/25.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMemberInfoHeaderView.h"
#import "QSConfig.h"

#import <objc/runtime.h>

///关联
static char MembersCountKey;//!<成员数量

@implementation QSMemberInfoHeaderView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///创建UI
        [self createMembersHeaderUI];
        
    }
    
    return self;

}

///搭建UI
- (void)createMembersHeaderUI
{

    ///说明信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 80.0f, 30.0)];
    tipsLabel.font = [UIFont systemFontOfSize:16.0f];
    tipsLabel.textColor = kBaseGrayColor;
    tipsLabel.text = @"团员信息";
    tipsLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:tipsLabel];
    
    ///成员数量
    UILabel *membersCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_MAX_WIDTH-80.0f, 5.0f, 70.0f, 30.0)];
    membersCountLabel.font = [UIFont systemFontOfSize:14.0f];
    membersCountLabel.textColor = kBaseGrayColor;
    membersCountLabel.text = @"0份";
    membersCountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:membersCountLabel];
    objc_setAssociatedObject(self, &MembersCountKey, membersCountLabel, OBJC_ASSOCIATION_ASSIGN);

}

/**
 *  @author         yangshengmeng, 14-12-25 12:12:38
 *
 *  @brief          更新成员总数
 *
 *  @param count    成员总数
 *
 *  @since          2.0
 */
#pragma mark - 更新成员数量
- (void)updateMemberCounts:(NSString *)count
{

    UILabel *membersCountLabel = objc_getAssociatedObject(self, &MembersCountKey);
    if (membersCountLabel && count) {
        
        membersCountLabel.text = [NSString stringWithFormat:@"%@位",count];
        
    }

}

@end
