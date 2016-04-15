//
//  QSSearchBar.h
//  Eating
//
//  Created by ysmeng on 14/11/28.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//回调事件类型
typedef enum
{
    DEFAULT_SAT = 0,
    SEARCH_ACTION_SAT,
    DIDBEGINEDIT_SAT,
    TEXTCHANGED_SAT,
    DIDENDEDITING_SAT,
    CLEARINPUT_SAT
}SEARCHBAR_ACTION_TYPE;

@interface QSSearchBar : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  andCallBack:(void(^)(SEARCHBAR_ACTION_TYPE actionType,NSString *result))callBack;

@property (nonatomic,copy) void(^callBack)(SEARCHBAR_ACTION_TYPE actionType,NSString *result);

@end
