//
//  QSMerchantIntroductionViewController.m
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMerchantIntroductionViewController.h"
#import "QSAPIModel+Merchant.h"
#import "UIImageView+AFNetworking.h"
#import "QSMapNavViewController.h"
#import "QSMerchantChatListViewController.h"

@interface QSMerchantIntroductionViewController ()

@end

@implementation QSMerchantIntroductionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.merchantLogoImageView setImageWithURL:[NSURL URLWithString:[_item.merchant_logo imageUrl]] placeholderImage:IMAGENAME(@"merchant_defaultlog")];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",_item.merchant_start_time,_item.merchant_end_time];
    self.trifficLabel.text = _item.merchant_traffic;
    self.introLabel.text = [NSString stringWithFormat:@"餐厅介绍:\n%@",_item.merchant_desc];
    CGSize size = [self.introLabel.text sizeWithFont:self.introLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.introLabel.frame), 200) lineBreakMode:NSLineBreakByWordWrapping];
    self.introLabel.numberOfLines = 0;
    CGRect frame = self.introLabel.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.introLabel.frame = frame;
    
    [_item.merchant_tag enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       [self.merchantTypeButton setTitle:obj forState:UIControlStateNormal];
        *stop = YES;
    }];
    
    frame = self.timeContainView.frame;
    frame.size.height = CGRectGetHeight(self.timeLabel.frame)+24;
    self.timeContainView.frame = frame;
    
    frame = self.trifficContainView.frame;
    frame.size.height = CGRectGetHeight(self.trifficLabel.frame)+24;
    self.trifficContainView.frame = frame;
    
    frame = self.introContainView.frame;
    frame.size.height = CGRectGetHeight(self.introLabel.frame)+24;
    self.introContainView.frame = frame;
    
    self.introScrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(self.introContainView.frame)+20);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.introScrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 64;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 64;
    self.introScrollView.frame = frame;
}

- (void)setupUI
{
    self.titleLabel.text = _item.merchant_name;
    [self.addressButton setTitle:_item.address forState:UIControlStateNormal];
    [self.addressButton customButton:kCustomButtonType_Address];
    [self.merchantLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.merchantLogoImageView.layer setBorderWidth:3];
    [self.merchantLogoImageView roundView];
    self.merchantLogoImageView.clipsToBounds = YES;
    
    [self.chatButton customButton:kCustomButtonType_ChatToMerchant];
    [self.callButton customButton:kCustomButtonType_CallToMerchant];
    
    [self.addressButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    
    [self.merchantTypeButton roundCornerRadius:12];
    
    [self.timeContainView roundCornerRadius:5];
    [self.trifficContainView roundCornerRadius:5];
    [self.introContainView roundCornerRadius:5];
    

}

- (IBAction)onChatToMerchantButtonAction:(id)sender
{
    if (![self checkIsLogin]) {
        return;
    }
    QSMerchantChatListViewController *viewVC = [[QSMerchantChatListViewController alloc] init];
    viewVC.merchantDetailData = self.item;
    [self.navigationController pushViewController:viewVC animated:YES];
}


- (IBAction)onPhoneCallButtonAction:(id)sender
{
    [self makeCall:_item.merchant_phone];
}

- (IBAction)onAddressButtonAction:(id)sender
{
    QSMapNavViewController *viewVC = [[QSMapNavViewController alloc] init];
    QSMerchantListReturnData *info = [[QSMerchantListReturnData alloc] init];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:self.item];
    info.msg = data;
    viewVC.merchantListReturnData = info;
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
