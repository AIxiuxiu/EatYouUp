//
//  QSYCustomHUD.m
//  Eating
//
//  Created by ysmeng on 14/12/14.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSYCustomHUD.h"

@interface QSYCustomHUD ()

CREATE_SINGLETON_HEADER(QSYCustomHUD)

@end

static QSYCustomHUD *coustomHUD = nil;//!<单例指针
@implementation QSYCustomHUD

CREATE_SINGLETON_WITHCLASSNAME(QSYCustomHUD)

/**
 *  @author yangshengmeng, 14-12-14 12:12:59
 *
 *  @brief  初始化接口
 *
 *  @since  2.0
 */
- (void)initParameter
{
    ///背景颜色
    self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    
    [self addSingleTapGesture];
    
    ///添加缓冲UI
    [self createHUDUI];
    
    ///添加透明度观察者事件
    [self addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

/**
 *  @author yangshengmeng, 14-12-20 16:12:25
 *
 *  @brief  创建HUD的UI
 *
 *  @since  2.0
 */
- (void)createHUDUI
{

    ///开启
    UIActivityIndicatorView *indict = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indict.tag = 343;
    indict.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:indict];
    
    ///添加约束
    [self addConstraint:[NSLayoutConstraint constraintWithItem:indict attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:indict attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];

}

/**
 *  @author yangshengmeng, 14-12-14 13:12:52
 *
 *  @brief  添加单击手势，用来屏蔽单击事件
 *
 *  @since  2.0
 */
- (void)addSingleTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customHUDSingleTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)customHUDSingleTapAction:(UITapGestureRecognizer *)tap
{
    
}

/**
 *  @author         yangshengmeng, 14-12-14 12:12:58
 *
 *  @brief          本身透明度属性的观察者回调
 *
 *  @param  keyPath  属性关键字
 *  @param  object   
 *  @param  change   被观察者的新旧值字典
 *  @param  context  回调此消息时带的参数
 *
 *  @since          2.0
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    ///判断是否是透明度的观察结果
    if ([keyPath isEqualToString:@"alpha"]) {
                
        ///如果是0.0-1.0
        if (([[change valueForKey:NSKeyValueChangeOldKey] intValue] == 0) && ([[change valueForKey:NSKeyValueChangeNewKey] intValue] == 1)) {
            
            ///如果是渐出，则显示加载指示
            [self startIndicator:YES];
            
        } else {
            
            ///如果是移除，停止指示器
            [self startIndicator:NO];
            
        }
        
        return;
        
    }
    
    ///如果是其他的观察者，则转发
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
}

/**
 *  @author     yangshengmeng, 14-12-14 13:12:56
 *
 *  @brief      开启指示器
 *
 *  @param flag YES-开启  NO-关闭
 *
 *  @since      2.0
 */
- (void)startIndicator:(BOOL)flag
{
    UIActivityIndicatorView *indict = (UIActivityIndicatorView *)[self viewWithTag:343];
    if (flag) {
        
        ///开启动画
        [indict startAnimating];
        
        return;
        
    }
    
    ///停止
    [indict stopAnimating];
    
}

/**
 *  @author yangshengmeng, 14-12-14 12:12:17
 *
 *  @brief  加盖HUD
 *
 *  @return 返回当前HUD的指针
 *
 *  @since  2.0
 */
+ (instancetype)showOperationHUD:(UIView *)targetView
{
    QSYCustomHUD *hud = [QSYCustomHUD sharedQSYCustomHUD];
    hud.frame = CGRectMake(0.0f, 0.0f, targetView.frame.size.width, targetView.frame.size.height);
    [targetView addSubview:hud];
    hud.alpha = 0.0f;
    [UIView animateWithDuration:0.3 animations:^{
        
        ///hud渐入
        hud.alpha = 1.0f;
        
    }];
    
    return hud;
}

/**
 *  @author yangshengmeng, 14-12-14 12:12:17
 *
 *  @brief  加盖HUD
 *
 *  @return 返回当前HUD的指针
 *
 *  @since  2.0
 */
+ (instancetype)hiddenOperationHUD
{
    QSYCustomHUD *hud = [QSYCustomHUD sharedQSYCustomHUD];
    [UIView animateWithDuration:0.3 animations:^{
        
        ///hud淡出
        hud.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [hud removeFromSuperview];
        }
        
    }];
    
    return hud;
}

@end
