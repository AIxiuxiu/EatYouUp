//
//  QSSearchViewController.m
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSSearchViewController.h"
#import "QSBusinessSearchViewController.h"
#import "QSCategorySearchViewController.h"
#import "QSMetroSearchViewController.h"
#import "QSRankSearchViewController.h"
#import "QSMerchantViewController.h"
#import "QSBusinessSearchViewController.h"
#import "QSSearchBar.h"

@interface QSSearchViewController ()

@end

@implementation QSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加搜索栏
    
    __weak QSSearchViewController *weakSelf = self;
    QSSearchBar *searchBar = [[QSSearchBar alloc] initWithFrame:CGRectMake(50.0f, 0.0f, DeviceWidth-100.0f, 30.0f) andCallBack:^(SEARCHBAR_ACTION_TYPE actionType, NSString *result) {
        
        if (actionType == SEARCH_ACTION_SAT) {
            QSMerchantViewController *viewVC = [[QSMerchantViewController alloc] init];
            viewVC.searchWord = result;
            viewVC.showBackButton = YES;
            [weakSelf.navigationController pushViewController:viewVC animated:YES];
        }
        
    }];
    searchBar.center = CGPointMake(DeviceMidX, 45);
    [self.topView addSubview:searchBar];
    [self setupAreaView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)setupUI
{
    self.searchTextField.backgroundColor = HEXCOLOR(0xD83E2F);
    
    [self.searchTextField.layer setCornerRadius:15];
    
}

- (void)setupAreaView
{
    CGFloat xx = 0;
    CGFloat yy = 0;
    for (int i = 0 ; i < [UserManager sharedManager].countyArray.count ; i++) {
        NSString *tagname = [UserManager sharedManager].countyArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.backgroundColor = kBaseGreenColor;
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
        [self.areaView addSubview:button];

        xx = CGRectGetMaxX(button.frame)+(DeviceWidth-270)/4;

        
    }
}

- (IBAction)onCountyButtonAction:(id)sender
{
    UIButton *button = sender;
    QSBusinessSearchViewController *viewVC = [[QSBusinessSearchViewController alloc] init];
    viewVC.county = [UserManager sharedManager].countyCodeArray[button.tag];
    [self.navigationController pushViewController:viewVC animated:YES];
}

- (IBAction)onTypeSearchButtonAction:(id)sender
{
    UIButton *button = sender;
    if (button == self.typeSearchButton1) {
        QSBusinessSearchViewController *viewVC = [[QSBusinessSearchViewController alloc] init];
        [self.navigationController pushViewController:viewVC animated:YES];
    }
    else if (button == self.typeSearchButton2){
        QSCategorySearchViewController *viewVC = [[QSCategorySearchViewController alloc] init];
        [self.navigationController pushViewController:viewVC animated:YES];
    }
    else if (button == self.typeSearchButton3){
        QSMetroSearchViewController *viewVC = [[QSMetroSearchViewController alloc] init];
        [self.navigationController pushViewController:viewVC animated:YES];
    }
    else if (button == self.typeSearchButton4){
        QSRankSearchViewController *viewVC = [[QSRankSearchViewController alloc] init];
        [self.navigationController pushViewController:viewVC animated:YES];
    }
}

- (IBAction)onBackgroundButtonAction:(id)sender
{
    [self.searchTextField resignFirstResponder];
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
