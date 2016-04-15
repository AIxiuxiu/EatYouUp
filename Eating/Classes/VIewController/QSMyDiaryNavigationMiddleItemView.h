//
//  QSMyDiaryNavigationMiddleItemView.h
//  Eating
//
//  Created by ysmeng on 14/11/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//回调类型
typedef enum{
    DEFAULT_ACTIONTYPE = 0,
    MYTASK_ACTIONTYPE,
    MYDIARY_ACTIONTYPE
}MYDETECTIVE_TOPIC_CALLBACK_TYPE;

//回调block
typedef void (^MYDETICTIVE_NAVIGATION_MIDDLEITEM_CALLBACK)(MYDETECTIVE_TOPIC_CALLBACK_TYPE actionType);

@interface QSMyDiaryNavigationMiddleItemView : UIView

/**
 *  在目标视图加载显示支付失败的询问页
 *
 *  @param frame        frame设置
 *  @param leftTitle    左侧按钮标题
 *  @param rightTitle   右侧按钮标题
 *  @param callBack     回调block
 *  @return             返回当前对象
 */
- (instancetype)initWithFrame:(CGRect)frame andLeftTitle:(NSString *)leftTitle andRightTitle:(NSString *)rightTitle andCallBack:(MYDETICTIVE_NAVIGATION_MIDDLEITEM_CALLBACK)callBack;

@property (nonatomic,copy) MYDETICTIVE_NAVIGATION_MIDDLEITEM_CALLBACK callBack;

- (void)resetTopicButtonSelectedStyle;

@end
