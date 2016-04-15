//
//  QSRefundReasonView.m
//  Eating
//
//  Created by ysmeng on 14/12/8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSRefundReasonView.h"
#import "QSBlockActionButton.h"
#import "QSConfig.h"

@implementation QSRefundReasonView

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(NSString *reason,int index))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        //保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
        //创建UI
        [self createRefundReasonViewUI];
        
    }
    
    return self;
}

- (void)createRefundReasonViewUI
{
    NSArray *reasonTypeArray = @[@"买多了/买错了",@"计划有变/没时间消费",@"其他原因"];
    
    for (int i = 0; i < [reasonTypeArray count]; i++) {
        
        //复选框
        UIButton *checkBox = [UIButton createBlockActionButton:CGRectMake(10.0f, 5.0f + i * (10.0f + 20.0f), 20.0f, 20.0f) andStyle:nil andCallBack:^(UIButton *button) {
            
            if (button.selected) {
                return;
            }
            
            //回调
            if (self.callBack) {
                self.callBack(reasonTypeArray[i],i);
            }
            
        }];
        [checkBox setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_normal"] forState:UIControlStateNormal];
        [checkBox setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_selected"] forState:UIControlStateSelected];
        [checkBox addTarget:self action:@selector(checkBoxButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkBox];
        
        //第一个默认选择状态
        if (i == 0) {
            checkBox.selected = YES;
            if (self.callBack) {
                self.callBack(reasonTypeArray[i],i);
            }
        }
        
        //原因说明
        UILabel *resonInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkBox.frame.origin.x+checkBox.frame.size.width+20.0f, checkBox.frame.origin.y, 240.0f, 20.0f)];
        resonInfoLabel.text = reasonTypeArray[i];
        resonInfoLabel.font = [UIFont systemFontOfSize:14.0f];
        resonInfoLabel.textColor = kBaseGrayColor;
        [self addSubview:resonInfoLabel];
        
    }
}

- (void)checkBoxButtonAction:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    
    for (UIView *obj in [self subviews]) {
        if ([obj isKindOfClass:[UIButton class]]) {
            ((UIButton *)obj).selected = NO;
        }
    }
    
    button.selected = YES;
}

@end
