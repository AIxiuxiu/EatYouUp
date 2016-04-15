//
//  QSStarRemark.h
//  Eating
//
//  Created by ysmeng on 14/11/26.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSStarRemark : UIView

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(CGFloat starLevel))callBack;

//回调block
@property (nonatomic,copy) void(^callBack)(CGFloat starLevel);

@end
