//
//  QSFoodMenuViewController.m
//  Eating
//
//  Created by System Administrator on 12/13/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSFoodMenuViewController.h"
#import "QSAPIClientBase+Food.h"
#import "QSAPIModel+Food.h"

@interface QSFoodMenuViewController ()

@end

@implementation QSFoodMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getFoodMenu];

}

- (void)setupUI
{
    self.titleLabel.text = self.foodName;
}

- (void)getFoodMenu
{
    __weak QSFoodMenuViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] foodMenuWithGoodsName:self.foodName
                                                  success:^(QSAPIModelString *response) {
                                                      weakSelf.menuUrl = response.msg;
                                                      [weakSelf loadMenuUrl];
                                                  } fail:^(NSError *error) {
                                                      
                                                  }];
}

- (void)loadMenuUrl
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.menuUrl foodMenuUrl]]];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:request];
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
