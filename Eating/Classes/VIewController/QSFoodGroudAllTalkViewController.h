//
//  QSFoodGroudAllTalkViewController.h
//  Eating
//
//  Created by ysmeng on 14/12/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@interface QSFoodGroudAllTalkViewController : QSPrepaidChannelImageViewController

/**
 *  @author         yangshengmeng, 14-12-26 14:12:17
 *
 *  @brief          按给定的搭食团ID进行初始化
 *
 *  @param teamID   搭食团ID
 *
 *  @return         返回当前对象
 *
 *  @since          2.0
 */
- (instancetype)initWithTeamID:(NSString *)teamID;

@end
