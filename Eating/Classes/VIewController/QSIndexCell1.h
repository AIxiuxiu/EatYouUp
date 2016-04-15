//
//  QSIndexCell1.h
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewCell.h"

@class QSIndexBannerReturnData;
@interface QSIndexCell1 : QSViewCell

@property (nonatomic, strong) QSIndexBannerReturnData *indexBannerReturnData;

@property (nonatomic,copy) void(^callBack)(BOOL flag,NSString *url);

- (CGFloat)cellHeight;

@end
