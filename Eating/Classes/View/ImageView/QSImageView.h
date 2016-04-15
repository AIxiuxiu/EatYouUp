//
//  QSImageView.h
//  Eating
//
//  Created by ysmeng on 14/11/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//回调类型
typedef enum
{
    DEFAULT_SIA = 0,
    
}SINGLETAP_IMAGEVIEW_ACTIONTYPE;

@interface QSImageView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(SINGLETAP_IMAGEVIEW_ACTIONTYPE actionType))callBack;

@property (nonatomic,copy) void(^callBack)(SINGLETAP_IMAGEVIEW_ACTIONTYPE actionType);

@end
