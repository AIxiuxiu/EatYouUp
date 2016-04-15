//
//  QSCategorySearchViewController.m
//  Eating
//
//  Created by System Administrator on 12/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSCategorySearchViewController.h"
#import "QSMerchantViewController.h"

@interface QSCategorySearchViewController ()

@end

@implementation QSCategorySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupCateView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupUI
{
    self.titleLabel.text = @"按分类找";
}


- (void)setupCateView
{
    CGFloat xx = 0;
    CGFloat yy = 100;

    for (int i = 0 ; i < [UserManager sharedManager].searchCategoryArray.count ; i++) {
        NSString *tagname = [UserManager sharedManager].searchCategoryArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.backgroundColor = kBaseGreenColor;
        if (i == [UserManager sharedManager].searchCategoryArray.count-1) {
            button.backgroundColor = kBaseLightGrayColor;
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [button setTitle:tagname forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onCountyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i % 3 == 0) {
            xx = (DeviceWidth-270)/4;
            yy += 40;
        }
        button.frame = CGRectMake(xx, yy, 90, 30);
        [button roundCornerRadius:15];
        [self.view addSubview:button];
        
        xx = CGRectGetMaxX(button.frame)+(DeviceWidth-270)/4;
        
    }
}

- (IBAction)onCountyButtonAction:(id)sender
{
    UIButton *button = sender;
    QSMerchantViewController *viewVC = [[QSMerchantViewController alloc] init];
    viewVC.showBackButton = YES;
    viewVC.flavor = [UserManager sharedManager].searchCategoryCodeArray[button.tag];
    [self.navigationController pushViewController:viewVC animated:YES];
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
