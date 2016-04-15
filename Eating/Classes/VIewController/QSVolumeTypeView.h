//
//  QSVolumeTypeView.h
//  Eating
//
//  Created by ysmeng on 14/11/29.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSVolumeTypeView : UIView

- (instancetype)initWithFrame:(CGRect)frame andSelectedArray:(NSArray *)tempArray andCallBack:(void(^)(NSDictionary *filterData))callBack;

@property (nonatomic,copy) void(^callBack)(NSDictionary *filterData);

//显示类型选择
+ (void)showVolumeTypeView:(UIView *)targetView andSelectedArray:(NSArray *)tempArray andCallBack:(void(^)(NSDictionary *filterDict))callBack;

@end
