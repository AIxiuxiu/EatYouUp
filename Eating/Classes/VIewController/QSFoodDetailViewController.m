//
//  QSFoodDetailViewController.m
//  eating
//
//  Created by MJie on 14-11-9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodDetailViewController.h"
#import "QSAPIClientBase+Food.h"
#import "QSAPIModel+Food.h"
#import "NSString+Name.h"
#import "QSAPIModel+Merchant.h"
#import "QSTakeoutListViewController.h"
#import "QSBookFillFormViewController.h"
#import "QSAPIClientBase+User.h"
#import "QSFoodMenuViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SocaialManager.h"

@interface QSFoodDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) QSFoodDetailReturnData *foodDetailReturnData;
@property (nonatomic, unsafe_unretained) CGFloat intervalx;
@property (nonatomic, unsafe_unretained) CGFloat foodbuttonwidth;
@end

@implementation QSFoodDetailViewController

- (void)setFoodDetailReturnData:(QSFoodDetailReturnData *)foodDetailReturnData
{
    
    _foodDetailReturnData = foodDetailReturnData;
    self.titleLabel.text = _foodDetailReturnData.data.goods_name;
    self.priceView = [UIView priceViewWithPrice:_foodDetailReturnData.data.goods_pice Color:[UIColor whiteColor]];
    self.priceView.center = CGPointMake(DeviceMidX, 80);
    [self.topView addSubview:self.priceView];
    [self.picImageView setImageWithURL:[NSURL URLWithString:[_foodDetailReturnData.data.goods_image imageUrl]] placeholderImage:nil];
    
    self.foodbuttonwidth = 56;
    self.intervalx = (CGRectGetWidth(self.view.frame)-self.foodbuttonwidth*4)/5;
    
    for (int i = 0 ; i < self.foodDetailReturnData.data.connection_menu.count ; i++) {
        NSDictionary *info = self.foodDetailReturnData.data.connection_menu[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(i*self.foodbuttonwidth+(i+1)*self.intervalx+i/4*25, 10, self.foodbuttonwidth, self.foodbuttonwidth);
        [self.popupScrollView addSubview:button];
        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
        [button.layer setBorderWidth:1];
        [button roundButton];
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(onFoodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *pp = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.foodbuttonwidth, 15)];
        pp.textAlignment = NSTextAlignmentCenter;
        pp.text = [NSString stringWithFormat:@"￥%@",[info objectForKey:@"goods_pice"]];
        pp.textColor = [UIColor whiteColor];
        pp.backgroundColor = kBaseGreenColor;
        pp.font = [UIFont systemFontOfSize:9.0];
        [button addSubview:pp];
        
        UIImageView *temp = [[UIImageView alloc] init];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[info objectForKey:@"goods_image"] imageUrl]]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        [temp setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [button setImage:image forState:UIControlStateNormal];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x-10, CGRectGetMaxY(button.frame), self.foodbuttonwidth+20, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kBaseGrayColor;
        label.font = [UIFont systemFontOfSize:9.0];
        label.text = [info objectForKey:@"goods_name"];
        [self.popupScrollView addSubview:label];
    }
    
    self.foodScrollView.contentSize = CGSizeMake(self.view.frame.size.width * (self.foodDetailReturnData.data.connection_menu.count/4 == 0 ? 1 : self.foodDetailReturnData.data.connection_menu.count/4), self.foodScrollView.frame.size.height);
    
}

- (IBAction)onFoodButtonAction:(id)sender
{
    
    UIButton *button = sender;
    NSDictionary *info = _foodDetailReturnData.data.connection_menu[button.tag];
    QSFoodDetailViewController *viewVC = [[QSFoodDetailViewController alloc] init];
    viewVC.goods_id = [info objectForKey:@"id"];
    viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
    [self.navigationController pushViewController:viewVC animated:YES];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    BOOL takeout = NO;
    BOOL book = NO;
    
    if ([_merchantIndexReturnData.data.merchant_ser_new containsObject:@"5"]) {
        
        takeout = YES;
        
        self.takeoutButton.hidden = !takeout;
        
    } else if ([_merchantIndexReturnData.data.merchant_ser_new containsObject:@"1"] || [_merchantIndexReturnData.data.merchant_ser_new containsObject:@"2"] || [_merchantIndexReturnData.data.merchant_ser_new containsObject:@"3"] || [_merchantIndexReturnData.data.merchant_ser_new containsObject:@"4"]) {
        book = YES;
        
        self.bookButton.hidden = !book;
     
    }
    
    self.callButton.hidden=YES;
    self.callButton.selected=NO;
 
    CGPoint center;
    if (takeout) {
        
        center = self.takeoutButton.center;
        center.x = DeviceWidth / 3.0f * 2.0f - 5.0f;
        self.takeoutButton.center = center;
            
    } else if (takeout && !book){
        
        center = self.takeoutButton.center;
        center.x = DeviceWidth / 2.0f + 30.0f;
        self.takeoutButton.center = center;
        
    } else if (!takeout && book){
        
        center = self.bookButton.center;
        center.x = DeviceWidth/2.0f;
        self.bookButton.center = center;
        self.takeoutButton.hidden=YES;
        _cartView.hidden=YES;
        
    } else {
        
        center = self.callButton.center;
        center.x = DeviceWidth/2;
        self.callButton.center = center;
        
    }
    
    if (takeout) {
        
         _cartView.hidden = !takeout;
        
    }

    [self getGoodsDetail];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    CGRect frame = self.footerView.frame;
    frame.origin.x = 0;
    frame.origin.y = DeviceHeight - frame.size.height;
    frame.size.width = DeviceWidth;
    self.footerView.frame = frame;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    if ([[[UserManager sharedManager] carFoodNum] isEqualToString:@"0"]) {
        
        self.cartLabel.hidden = YES;
        
    } else {
        
        self.cartLabel.hidden = NO;
        self.cartLabel.text = [[UserManager sharedManager] carFoodNum];
        
    }
    
    self.cartLabel.backgroundColor = kBaseGreenColor;
    [self.cartLabel roundView];
    
}

- (void)getGoodsDetail
{
    
    __weak QSFoodDetailViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] foodDetailWithGoodsId:self.goods_id
                                                  success:^(QSFoodDetailReturnData *response) {
                                                      weakSelf.foodDetailReturnData = response;
                                                     
                                                  } fail:^(NSError *error) {
                                                      
                                                  }];
}


- (void)setupUI
{
    
    [self.listButton roundButton];
    [self.bookButton customButton:kCustomButtonType_FoodBook];
    [self.takeoutButton customButton:kCustomButtonType_FoodTakeout];
    self.addCartButton.hidden = !self.takeOutFlag;
    self.listButton.hidden = !self.takeOutFlag;
    
    self.listicon.tag = 0;
    self.listicon1.tag = 1;
    self.listicon2.tag = 2;
    self.listicon3.tag = 3;
    self.listicon4.tag = 4;
    
    CGRect frame = self.listiconsView.frame;
    frame.origin.x = 270;
    frame.origin.y = 30;
    self.listiconsView.frame = frame;
    [self.foodScrollView addSubview:self.listiconsView];
    
    frame = self.popupView.frame;
    frame.origin.x = 0;
    frame.origin.y = self.view.frame.size.height;
    self.popupView.frame = frame;
    [self.view insertSubview:self.popupView belowSubview:self.footerView];
    self.popupView.backgroundColor = kBaseBackgroundColor;
}

- (IBAction)onBackButtonAction:(id)sender
{
    [[UserManager sharedManager].player stop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddCartButtonAction:(id)sender
{
    [[UserManager sharedManager] addFoodToLocalCart:self.foodDetailReturnData.data];
    if ([[[UserManager sharedManager] carFoodNum] isEqualToString:@"0"]) {
        self.cartLabel.hidden = YES;
    }
    else{
        self.cartLabel.hidden = NO;
        self.cartLabel.text = [[UserManager sharedManager] carFoodNum];
    }
    self.cartLabel.backgroundColor = kBaseGreenColor;
    [self.cartLabel roundView];
}

- (IBAction)onShowListButtonAction:(id)sender
{
    UIButton *button = sender;
    if (button.selected) {
        [self hidePopup];
    }
    else{
        [self showPopup];
    }
    button.selected = !button.selected;
}

- (IBAction)onPhoneCallButtonAction:(id)sender
{
    [self makeCall:_merchantIndexReturnData.data.merchant_phone];
}

- (IBAction)onTakeoutButtonAction:(id)sender
{
    if ([[[UserManager sharedManager] carFoodNum] integerValue] <= 0 || ![self checkIsLogin]) {
        return;
    }
    
    QSTakeoutListViewController *viewVC = [[QSTakeoutListViewController alloc] init];
    viewVC.merchant_id = self.merchantIndexReturnData.data.merchant_id;
    viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
    [self.navigationController pushViewController:viewVC animated:YES];
}

- (IBAction)onBookButtonAction:(id)sender
{
    if (![self checkIsLogin]) {
        return;
    }
    QSBookFillFormViewController *viewVC = [[QSBookFillFormViewController alloc] init];
    viewVC.merchant_id = self.merchantIndexReturnData.data.merchant_id;
    viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
    [self.navigationController pushViewController:viewVC animated:YES];
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
                                                  UserName:nil
                                                  WorkName:nil
                                                    Images:self.picImageView.image
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

- (IBAction)onDiggButtonAction:(id)sender
{
    BOOL isLogin = [self checkIsLogin];
    if (!isLogin) {
        return;
    }
    
    __weak QSFoodDetailViewController *weakSelf = self;
    if (1) {
        [[QSAPIClientBase sharedClient] userAddGood:self.goods_id
                                               type:kUserGoodType_Food
                                            success:^(QSAPIModelDict *response) {
                                            } fail:^(NSError *error) {
                                                
                                            }];
    }
    else{
        [[QSAPIClientBase sharedClient] userDelGood:self.goods_id
                                               type:kUserGoodType_Food
                                            success:^(QSAPIModelDict *response) {
                                            } fail:^(NSError *error) {
                                                
                                            }];
    }
}

- (IBAction)onAddFoodCollectButtonAction:(id)sender
{
    BOOL isLogin = [self checkIsLogin];
    if (!isLogin) {
        return;
    }
    [[QSAPIClientBase sharedClient] userFoodAddCollect:self.foodDetailReturnData.data.goods_id
                                               success:^(QSAPIModelDict *response) {
                                                   [self showTip:self.view tipStr:@"收藏菜品成功"];
                                               } fail:^(NSError *error) {
                                                   
                                               }];
    
}

- (void)foodMenu:(id)sender
{
    
    QSFoodMenuViewController *viewVC = [[QSFoodMenuViewController alloc] init];
    viewVC.foodName = self.foodDetailReturnData.data.goods_name;
    [self.navigationController pushViewController:viewVC animated:YES];
}

- (void)translateAction:(id)sender
{
    [UserManager Speaking:self.foodDetailReturnData.data.goods_name
                 tranType:self.foodDetailReturnData.data.translate_type
                  success:^(NSData *response) {
                      
                      NSLog(@"%ld",response.length);
                      [UserManager sharedManager].player = [[AVAudioPlayer alloc] initWithData:response error:nil];
                      [[UserManager sharedManager].player prepareToPlay];
                      [[UserManager sharedManager].player setVolume:1];
                      [[UserManager sharedManager].player play];

                  } fail:^(NSError *error) {
                      
                  }];
}

- (void)hidePopup
{
    [UIView animateWithDuration:0.5f animations:^(void) {
        CGPoint center;
        center.x = DeviceMidX;
        center.y = [[UIScreen mainScreen]bounds].size.height + self.popupView.frame.size.height;
        if (!iOS7) {
            center.y += 20;
        }
        self.popupView.center = center;
    }];
}

- (void)showPopup
{
    [UIView animateWithDuration:0.5f animations:^(void) {
        CGPoint center;
        center.x = DeviceMidX;
        center.y = [[UIScreen mainScreen]bounds].size.height - self.popupView.frame.size.height/2 - self.footerView.frame.size.height;
        if (!iOS7) {
            center.y -= 20;
        }
        self.popupView.center = center;
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
