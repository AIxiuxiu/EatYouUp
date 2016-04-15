//
//  QSPrepaidChannelImageViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/27.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSPrepaidChannelImageViewController.h"

@interface QSPrepaidChannelImageViewController ()

@end

@implementation QSPrepaidChannelImageViewController

- (void)createMainShowView
{
    [super createMainShowView];
    
    //添加channel栏
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1.0f, 64.0f, DeviceWidth+1, 15.0f)];
    imageView.image = [UIImage imageNamed:@"prepaidcard_normal_channel"];
    [self.view addSubview:imageView];
}

@end
