//
//  QSYMemberIconlistView.h
//  Eating
//
//  Created by ysmeng on 14/12/18.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSYMemberIconlistView : UIView

/**
 *  @author         yangshengmeng, 14-12-18 10:12:34
 *
 *  @brief          根据给定的成员数组，更新团员信息头像
 *
 *  @param array    成员数据数组
 *
 *  @since          2.0
 */
- (void)updateMembersIconListWithArray:(NSArray *)array;

@end
