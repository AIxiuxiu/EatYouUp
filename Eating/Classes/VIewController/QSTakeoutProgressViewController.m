//
//  QSTakeoutProgressViewController.m
//  Eating
//
//  Created by System Administrator on 12/1/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSTakeoutProgressViewController.h"
#import "QSAPIModel+Takeout.h"
#import "QSAPIModel+User.h"
#import <UIImageView+AFNetworking.h>
@interface QSTakeoutProgressViewController ()

@end

@implementation QSTakeoutProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = self.line.frame;
    frame.origin.x = 15;
    frame.origin.y = 25;
    frame.size.width = 6;

    if (self.item.add_time && [self.item.add_time integerValue] > 0) {
        
        self.pointButton1.hidden = NO;
        self.portButton1.hidden = NO;
        self.statusNameLabel1.hidden = NO;
        self.statusTimeLabel1.hidden = NO;
        self.line.hidden = NO;

        self.statusTimeLabel1.text = [NSDate formatIntegerIntervalToDateString:self.item.add_time];
        QSUserData *userData = [UserManager sharedManager].userData;
        [self.portButton1 setImageWithURL:[NSURL URLWithString:[userData.logo imageUrl]] placeholderImage:nil];

        
        frame.size.height = self.portButton1.center.y - frame.origin.y;
    }
    if (self.item.take_time && [self.item.take_time integerValue] > 0) {
        
        self.pointButton2.hidden = NO;
        self.portButton2.hidden = NO;
        self.statusNameLabel2.hidden = NO;
        self.statusTimeLabel2.hidden = NO;
        self.line.hidden = NO;

        self.statusTimeLabel2.text = [NSDate formatIntegerIntervalToDateString:self.item.take_time];
        
        [self.portButton1 setImageWithURL:[NSURL URLWithString:[[self.item.merchant_msg objectForKey:@"merchant_logo"] imageUrl]] placeholderImage:nil];
        
        frame.size.height = self.portButton2.center.y - frame.origin.y;

    }
    if (self.item.out_time && [self.item.out_time integerValue] > 0) {
        
        self.pointButton3.hidden = NO;
        self.portButton3.hidden = NO;
        self.statusNameLabel3.hidden = NO;
        self.statusTimeLabel3.hidden = NO;
        self.line.hidden = NO;
        
        self.statusTimeLabel3.text = [NSDate formatIntegerIntervalToDateString:self.item.out_time];
        
        [self.portButton1 setImageWithURL:[NSURL URLWithString:[[self.item.merchant_msg objectForKey:@"merchant_logo"] imageUrl]] placeholderImage:nil];
        
        frame.size.height = self.portButton3.center.y - frame.origin.y;

    }
    if (self.item.get_time && [self.item.get_time integerValue] > 0) {
        
        self.pointButton4.hidden = NO;
        self.portButton4.hidden = NO;
        self.statusNameLabel4.hidden = NO;
        self.statusTimeLabel4.hidden = NO;
        self.line.hidden = NO;
        
        self.statusTimeLabel4.text = [NSDate formatIntegerIntervalToDateString:self.item.get_time];
        
        QSUserData *userData = [UserManager sharedManager].userData;
        [self.portButton1 setImageWithURL:[NSURL URLWithString:[userData.logo imageUrl]] placeholderImage:nil];
        
        frame.size.height = self.portButton4.center.y - frame.origin.y;

    }
    
    self.line.frame = frame;
}

- (void)setupUI
{
    [self.pointButton roundButton];
    [self.pointButton1 roundButton];
    [self.pointButton2 roundButton];
    [self.pointButton3 roundButton];
    [self.pointButton4 roundButton];
    
    [self.portButton1 roundView];
    [self.portButton2 roundView];
    [self.portButton3 roundView];
    [self.portButton4 roundView];
    
    self.line.backgroundColor = kBaseBackgroundColor;
    self.pointButton.backgroundColor = kBaseBackgroundColor;
    self.pointButton1.backgroundColor = kBaseBackgroundColor;
    self.pointButton2.backgroundColor = kBaseBackgroundColor;
    self.pointButton3.backgroundColor = kBaseBackgroundColor;
    self.pointButton4.backgroundColor = kBaseBackgroundColor;
    
    self.statusNameLabel1.text = @"客户添加订单";
    self.statusNameLabel2.text = @"商家确认订单";
    self.statusNameLabel3.text = @"商家安排送餐";
    self.statusNameLabel4.text = @"客户收到送餐";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
