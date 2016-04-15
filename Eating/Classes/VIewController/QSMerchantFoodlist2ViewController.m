//
//  QSMerchantFoodlist2ViewController.m
//  Eating
//
//  Created by System Administrator on 12/5/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMerchantFoodlist2ViewController.h"
#import "QSAPIModel+Food.h"
#import "QSAPIModel+Merchant.h"
#import "QSBookFillFormViewController.h"
#import "QSTakeoutListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UserManager.h"
#import "QSAPIClientBase+Food.h"
#import "QSAPIModel+User.h"
#import "QSAPIClientBase+User.h"
#import "QSFoodMenuViewController.h"
#import "SocaialManager.h"


@interface QSMerchantFoodlist2ViewController ()

@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, unsafe_unretained) CGFloat intervalx;
@property (nonatomic, unsafe_unretained) CGFloat foodbuttonwidth;
@property (nonatomic, unsafe_unretained) NSInteger foodIndex;
@end

@implementation QSMerchantFoodlist2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[[UserManager sharedManager] carFoodNum] isEqualToString:@"0"]) {
        
        self.cartLabel.hidden = YES;
        
    } else {
        
        self.cartLabel.hidden = NO;
        self.cartLabel.text = [[UserManager sharedManager] carFoodNum];
        [UIView animateWithDuration:0.3 animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    [self onShowListButtonAction:nil];
    
    [self onFoodButtonAction:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.footerView.frame;
    frame.origin.y = DeviceHeight - frame.size.height;
    frame.size.width = DeviceWidth;
    self.footerView.frame = frame;
    
    frame = self.popupView.frame;
    frame.origin.y = DeviceHeight - CGRectGetHeight(self.footerView.frame) - CGRectGetHeight(self.popupView.frame);
    frame.size.width = DeviceWidth;
    self.popupView.frame = frame;
    
    frame = self.infoView.frame;
    frame.origin.y = DeviceHeight - CGRectGetHeight(self.footerView.frame) - CGRectGetHeight(self.popupView.frame) - CGRectGetHeight(self.infoView.frame);
    frame.size.width = DeviceWidth;
    self.infoView.frame = frame;
}


- (void)setupUI
{
    
    self.listicon.tag = 0;
    self.listicon1.tag = 1;
    self.listicon2.tag = 2;
    self.listicon3.tag = 3;
    self.listicon4.tag = 4;
    
    self.popupView.backgroundColor = kBaseBackgroundColor;
    self.titleLabel.text = @"美食";
    self.cartLabel.backgroundColor = kBaseGreenColor;
    [self.cartLabel roundView];
    [self.bookButton customButton:kCustomButtonType_FoodBook];
    [self.takeoutButton customButton:kCustomButtonType_FoodTakeout];
    [self.callButton customButton:kCustomButtonType_CallTakout];
    BOOL takeout = NO;
    BOOL book = NO;
    if ([_merchantIndexReturnData.data.merchant_ser_new containsObject:@"5"]) {
        takeout = YES;
    }
    if ([_merchantIndexReturnData.data.merchant_ser_new containsObject:@"1"] || [_merchantIndexReturnData.data.merchant_ser_new containsObject:@"2"] || [_merchantIndexReturnData.data.merchant_ser_new containsObject:@"3"] || [_merchantIndexReturnData.data.merchant_ser_new containsObject:@"4"]) {
        book = YES;
    }
    
    self.bookButton.hidden = !book;
    self.takeoutButton.hidden = !takeout;
    self.callButton.hidden = book || takeout;
    CGPoint center;
    if (takeout && book) {
        
        center = self.bookButton.center;
        center.x = CGRectGetWidth(self.view.frame)/3;
        self.bookButton.center = center;
        
        center = self.takeoutButton.center;
        center.x = CGRectGetWidth(self.view.frame)/3*2;
        self.takeoutButton.center = center;
        
    }
    else if (takeout && !book){
        
        center = self.takeoutButton.center;
        center.x = CGRectGetWidth(self.view.frame)/2;
        self.takeoutButton.center = center;
        
    }
    else if (!takeout && book){
        center = self.bookButton.center;
        center.x = CGRectGetWidth(self.view.frame)/2;
        self.bookButton.center = center;
    }
    else{
        center = self.callButton.center;
        center.x = CGRectGetWidth(self.view.frame)/2;
        self.callButton.center = center;
    }
    
    _cartView.hidden = !takeout;
    _addCartButton.hidden = !takeout;

}

- (IBAction)onPhoneCallButtonAction:(id)sender
{
    
}

#pragma mark - 点周外卖点餐按钮
- (IBAction)onTakeoutButtonAction:(id)sender
{
    
    if ([[[UserManager sharedManager] carFoodNum] integerValue] <= 0 || ![self checkIsLogin]) {
        return;
    }
    
    QSTakeoutListViewController *viewVC = [[QSTakeoutListViewController alloc] init];
    viewVC.merchant_id = self.merchant_id;
    viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
    [self.navigationController pushViewController:viewVC animated:YES];
    
}

- (IBAction)onBookButtonAction:(id)sender
{
    if (![self checkIsLogin]) {
        return;
    }
    QSBookFillFormViewController *viewVC = [[QSBookFillFormViewController alloc] init];
    viewVC.merchant_id = self.merchant_id;
    viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
    [self.navigationController pushViewController:viewVC animated:YES];
}


- (IBAction)onAddCarButtonAction:(id)sender
{
    
    QSFoodDetailData *info = self.foodlistReturnData.data[self.foodIndex];
    [[UserManager sharedManager] addFoodToLocalCart:info];
    
    if ([[[UserManager sharedManager] carFoodNum] isEqualToString:@"0"]) {
        
        self.cartLabel.hidden = YES;
        
    } else {
        
        self.cartLabel.hidden = NO;
        self.cartLabel.text = [[UserManager sharedManager] carFoodNum];
        [UIView animateWithDuration:0.3 animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

- (IBAction)onFoodButtonAction:(id)sender
{
    UIButton *button = sender;
    self.foodIndex = button.tag;
    QSFoodDetailData *info = self.foodlistReturnData.data[self.foodIndex];
    [self.foodImageView setImageWithURL:[NSURL URLWithString:[info.goods_image imageUrl]] placeholderImage:nil];
    self.priceLabel.text = info.goods_pice;
    self.nameLabel.text = info.goods_name;
}

- (IBAction)onShowListButtonAction:(id)sender
{
    self.foodbuttonwidth = 50;
    self.intervalx = (DeviceWidth-self.foodbuttonwidth*4)/5;
    
    for (int i = 0 ; i < self.foodlistReturnData.data.count ; i++) {
        QSFoodDetailData *info = self.foodlistReturnData.data[i];
        
        if ([info.goods_name isEqualToString:@""] || !info.goods_name) {
            continue;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(i*self.foodbuttonwidth+(i+1)*self.intervalx+i/4*25, 10, self.foodbuttonwidth, self.foodbuttonwidth);
        [self.popupScrollView addSubview:button];
        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
        [button.layer setBorderWidth:1];
        [button roundButton];
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(onFoodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *temp = [[UIImageView alloc] init];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[info.goods_image imageUrl]]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        [temp setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [button setImage:image forState:UIControlStateNormal];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x-10, CGRectGetMaxY(button.frame), self.foodbuttonwidth+20, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kBaseGrayColor;
        label.font = [UIFont systemFontOfSize:9.0];
        label.text = info.goods_name;
        [self.popupScrollView addSubview:label];
    }
    self.popupScrollView.contentSize = CGSizeMake(self.view.frame.size.width * (self.foodlistReturnData.data.count/4 == 0 ? 1 : self.foodlistReturnData.data.count/4), self.popupScrollView.frame.size.height);
}

- (IBAction)onListIconButtonAction:(id)sender
{
    UIButton *button = sender;
    if (button.tag == 0){
        __block CGPoint center;
        if (button.selected) {
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 center = self.listicon1.center;
                                 center.y = self.listicon.center.y;
                                 self.listicon1.center = center;
                                 center = self.listicon2.center;
                                 center.y = self.listicon1.center.y;
                                 self.listicon2.center = center;
                                 center = self.listicon3.center;
                                 center.y = self.listicon2.center.y;
                                 self.listicon3.center = center;
                                 center = self.listicon4.center;
                                 center.y = self.listicon3.center.y;
                                 self.listicon4.center = center;
                             } completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.2
                                                  animations:^{
                                                      self.listicon.transform = CGAffineTransformMakeRotation(degreeTOradians(0)));
                                                  } completion:^(BOOL finished) {
                                                      self.listicon.selected = NO;
                                                  }];
                             }];
            
        }
        else{
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 center = self.listicon1.center;
                                 center.y = self.listicon.center.y+40;
                                 self.listicon1.center = center;
                                 center = self.listicon2.center;
                                 center.y = self.listicon1.center.y+40;
                                 self.listicon2.center = center;
                                 center = self.listicon3.center;
                                 center.y = self.listicon2.center.y+40;
                                 self.listicon3.center = center;
                                 center = self.listicon4.center;
                                 center.y = self.listicon3.center.y+40;
                                 self.listicon4.center = center;
                             } completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.2
                                                  animations:^{
                                                      self.listicon.transform = CGAffineTransformMakeRotation(degreeTOradians(180)));
                                                  } completion:^(BOOL finished) {
                                                      self.listicon.selected = YES;
                                                  }];
                             }];
        }
    }
    else if (button.tag == 1){
        [[SocaialManager sharedManager] showNewUIShareOnVC:self
                                                   Content:@"省心省力省钱省时间，“吃订你”轻轻一点立即省"
                                                  UserName:[UserManager sharedManager].userData.username
                                                  WorkName:nil
                                                    Images:self.foodImageView.image
                                                 ImagesUrl:nil];
    }
    else if (button.tag == 2){
        [self onAddFoodCollectButtonAction:self.listicon2];
    }
    else if (button.tag == 3){
        [self foodMenu:self.listicon3];
    }
    else if (button.tag == 4){
        [self translateAction:self.listicon4];
    }
}

- (IBAction)onAddFoodCollectButtonAction:(id)sender
{
    BOOL isLogin = [self checkIsLogin];
    if (!isLogin) {
        return;
    }
    UIButton *button = sender;
    QSFoodDetailData *info = self.foodlistReturnData.data[self.foodIndex];
    [[QSAPIClientBase sharedClient] userFoodAddCollect:info.goods_id
                                               success:^(QSAPIModelDict *response) {
                                                   [self showTip:self.view tipStr:@"收藏菜品成功"];
                                               } fail:^(NSError *error) {
                                                   
                                               }];
    
}

- (void)foodMenu:(id)sender
{
    UIButton *button = sender;
    QSFoodDetailData *info = self.foodlistReturnData.data[self.foodIndex];
    QSFoodMenuViewController *viewVC = [[QSFoodMenuViewController alloc] init];
    viewVC.foodName = info.goods_name;
    [self.navigationController pushViewController:viewVC animated:YES];
}


- (void)translateAction:(id)sender
{
    UIButton *button = sender;
    QSFoodDetailData *info = self.foodlistReturnData.data[self.foodIndex];
    [self.foodImageView setImageWithURL:[NSURL URLWithString:[info.goods_image imageUrl]] placeholderImage:nil];
    self.priceLabel.text = info.goods_pice;
    self.nameLabel.text = info.goods_name;
    [UserManager Speaking:info.goods_name
                 tranType:info.translate_type
                  success:^(NSData *response) {
                      
                      NSLog(@"%ld",response.length);
                      [UserManager sharedManager].player = [[AVAudioPlayer alloc] initWithData:response error:nil];
                      [[UserManager sharedManager].player prepareToPlay];
                      [[UserManager sharedManager].player setVolume:1];
                      [[UserManager sharedManager].player play];
                      
                  } fail:^(NSError *error) {
                      
                  }];
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
