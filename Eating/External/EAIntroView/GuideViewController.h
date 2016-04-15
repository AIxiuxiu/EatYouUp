//
//  GuideViewController.h
//  DateApp
//
//  Created by likunding on 14-7-25.
//  Copyright (c) 2014年 likunding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"

@interface GuideViewController : UIViewController<EAIntroDelegate>

@property (nonatomic, unsafe_unretained) id delegate;

@end
