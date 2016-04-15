//
//  QSStarViewController.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSStarViewController : QSViewController

@property (nonatomic, strong) UIView *starView;
@property (nonatomic, unsafe_unretained) NSInteger point;

+ (UIView *)cellStarView:(NSInteger)point showPointLabal:(BOOL)isShow;



@end
