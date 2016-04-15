//
//  QSImageView.m
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSImageView.h"

@implementation QSImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void (^)(SINGLETAP_IMAGEVIEW_ACTIONTYPE))callBack
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        //添加点击手势
        [self addSingleTapGesture];
        
        //保存回调
        if (callBack) {
            self.callBack = callBack;
        }
    }
    
    return self;
}

- (void)addSingleTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)singleTapGestureAction:(UITapGestureRecognizer *)tap
{
    if (self.callBack) {
        self.callBack(DEFAULT_SIA);
    }
}

@end
