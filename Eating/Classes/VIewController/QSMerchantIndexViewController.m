//
//  QSMerchantIndexViewController.m
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMerchantIndexViewController.h"
#import "QSMerchantIntroductionViewController.h"
#import "QSMerchantEnviromentViewController.h"
#import "QSMerchantFoodlistViewController.h"
#import "QSFoodCommentViewController.h"
#import "QSMerchantIndexCell1.h"
#import "QSMerchantIndexCell2.h"
#import "QSMerchantIndexCell3.h"
#import "QSMerchantIndexCell4.h"
#import "QSAPIClientBase+Merchant.h"
#import "QSAPIModel+Merchant.h"
#import "NSString+Name.h"
#import "QSFoodDetailViewController.h"
#import "QSAPIModel+Food.h"
#import "QSAPIClientBase+User.h"
#import "QSTakeoutListViewController.h"
#import "QSBookFillFormViewController.h"
#import "QSMapNavViewController.h"
#import "SocaialManager.h"
#import "QSAPIModel+User.h"
#import "QSMerchantChatListViewController.h"
#import "QSYCouponDetailViewController.h"
#import "QSAPIModel+CouponList.h"
#import "QSPrepaidCardDetailViewController.h"
#import "QSFoodOfferDetailViewController.h"
#import "QSNormalRecommendViewController.h"
#import "QSYCustomHUD.h"
#import "QSFoodGroudViewController.h"

//代金券 1
//折扣券 2
//菜品兑换券 3
//限时优惠 4
//菜品优惠 5
//会员优惠 6




@interface QSMerchantIndexViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>
{
    
}
@property (nonatomic, strong) QSMerchantIndexReturnData *merchantIndexReturnData;
@property (nonatomic, unsafe_unretained) NSInteger rowCtn;
@property (nonatomic, unsafe_unretained) BOOL isCoup;
@property (nonatomic, unsafe_unretained) BOOL isPro;
@property (nonatomic, unsafe_unretained) BOOL isCard;

@end

@implementation QSMerchantIndexViewController

- (void)setMerchantIndexReturnData:(QSMerchantIndexReturnData *)merchantIndexReturnData
{
    _merchantIndexReturnData = merchantIndexReturnData;
    [self.merchantLogoImageView setImageWithURL:[NSURL URLWithString:[_merchantIndexReturnData.data.merchant_logo imageUrl]] placeholderImage:IMAGENAME(@"merchant_defaultlog")];
    [self.merchantLogoImageView roundView];
    [self.merchantLogoImageView.layer setBorderWidth:3];
    [self.merchantLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    self.diggButton.selected = [self.merchantIndexReturnData.data.isGood boolValue];
    self.titleLabel.text = _merchantIndexReturnData.data.merchant_name;
    
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

    [self.bookButton customButton:kCustomButtonType_FoodBook];
    [self.takeoutButton customButton:kCustomButtonType_FoodTakeout];
    [self.callButton customButton:kCustomButtonType_CallTakout];
    
    [self.mearchantIndexTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNotification];
    [self getMerchantIndex];
    self.mearchantIndexTableView.tableFooterView = self.footerView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    CGRect frame = self.mearchantIndexTableView.frame;
    frame.origin.x = 0;
    frame.origin.y = 88;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 88;
    self.mearchantIndexTableView.frame = frame;
    
    [self.view bringSubviewToFront:self.topView];
     self.diggButton.selected = [self.merchantIndexReturnData.data.isGood boolValue];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[[UserManager sharedManager] carFoodNum] integerValue] > 0) {
        self.cartLabel.hidden = NO;
        self.cartLabel.text = [[UserManager sharedManager] carFoodNum];
        self.cartLabel.backgroundColor = kBaseGreenColor;
        [self.cartLabel roundView];
        self.cartLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.cartLabel.hidden = YES;
    }
   
    
}

- (IBAction)onBackButtonAction:(id)sender
{
    if ([[[UserManager sharedManager] carFoodNum] integerValue] > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
    message:@"退出并清空购物车?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 111;
        [alertView show];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)getMerchantIndex
{
    __weak QSMerchantIndexViewController *weakSelf = self;
    [QSYCustomHUD showOperationHUD:self.view];
    [[QSAPIClientBase sharedClient] merchantIndexWithMerchantid:self.merchant_id
                                                        success:^(QSMerchantIndexReturnData *response) {
                                                                                                                       [QSYCustomHUD hiddenOperationHUD];
                                                            
                                                            weakSelf.merchantIndexReturnData = response;
                                                        } fail:^(NSError *error) {
                                                                                                                       [QSYCustomHUD hiddenOperationHUD];
                                                            
                                                        }];
}

- (void)setupUI
{
    self.titleLabel.text = @"";
    

    
}

- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:kUserDidLoginNotification
                                               object:nil];
}

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kUserDidLoginNotification]) {
        [self getMerchantIndex];
    }

}


- (IBAction)onShareButtonAction:(id)sender
{
    [[SocaialManager sharedManager] showNewUIShareOnVC:self
                                               Content:@"省心省力省钱省时间，“吃订你”轻轻一点立即省"
                                              UserName:[UserManager sharedManager].userData.username
                                              WorkName:nil
                                                Images:self.merchantLogoImageView.image
                                             ImagesUrl:nil];
}

- (IBAction)onPhoneCallButtonAction:(id)sender
{
    [self makeCall:_merchantIndexReturnData.data.merchant_phone];
}

- (IBAction)onChatButtonAction:(id)sender
{
    if (![self checkIsLogin]) {
        return;
    }
    QSMerchantChatListViewController *viewVC = [[QSMerchantChatListViewController alloc] init];
    viewVC.merchantDetailData = self.merchantIndexReturnData.data;
    [self.navigationController pushViewController:viewVC animated:YES];
}

- (IBAction)onTakeoutButtonAction:(id)sender
{
    
    if (![self checkIsLogin]) {
        
        return;
        
    }
    
    if ([[[UserManager sharedManager] carFoodNum] integerValue] == 0){
        
        QSMerchantFoodlistViewController *viewVC = [[QSMerchantFoodlistViewController alloc] init];
        viewVC.merchant_id = self.merchant_id;
        viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    } else {
        
        QSTakeoutListViewController *viewVC = [[QSTakeoutListViewController alloc] init];
        viewVC.merchant_id = self.merchant_id;
        viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    }

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

- (IBAction)onDiggButtonAction:(id)sender
{
    BOOL isLogin = [self checkIsLogin];
    if (!isLogin) {
        return;
    }
    
    __weak QSMerchantIndexViewController *weakSelf = self;
    [self showLoadingHud];
    if ([self.merchantIndexReturnData.data.isGood boolValue] == 0) {
        [[QSAPIClientBase sharedClient] userAddGood:self.merchant_id
                                               type:kUserGoodType_Merchant
                                            success:^(QSAPIModelDict *response) {
                                                [weakSelf hideLoadingHud];
                                                weakSelf.merchantIndexReturnData.data.isGood = @"true";
                                                weakSelf.diggButton.selected = YES;
                                            } fail:^(NSError *error) {                                                     [weakSelf hideLoadingHud];
                                            }];
    }
    else{
        [[QSAPIClientBase sharedClient] userDelGood:self.merchant_id
                                               type:kUserGoodType_Merchant
                                            success:^(QSAPIModelDict *response) {
                                                [weakSelf hideLoadingHud];
                                                weakSelf.merchantIndexReturnData.data.isGood = @"false";
                                                weakSelf.diggButton.selected = NO;
                                            } fail:^(NSError *error) {                                                   [weakSelf hideLoadingHud];
                                            }];
    }
    
}

- (IBAction)onCollectButtonAction:(id)sender
{
    BOOL isLogin = [self checkIsLogin];
    if (!isLogin) {
        return;
    }
    
    __weak QSMerchantIndexViewController *weakSelf = self;
    [self showLoadingHud];
    if ([self.merchantIndexReturnData.data.isStore boolValue] == 0) {
        
           [[QSAPIClientBase sharedClient] userMerchantAddCollect:self.merchant_id
                                                          success:^(QSAPIModelDict *response) {

                                                                                                                         [weakSelf hideLoadingHud];weakSelf.merchantIndexReturnData.data.isStore = @"true";
                                                              [weakSelf.mearchantIndexTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                          } fail:^(NSError *error) {
                                                                                                                         [weakSelf hideLoadingHud];
                                                          }];
    }
    else{
        [[QSAPIClientBase sharedClient] userMerchantDelCollect:self.merchant_id
                                                       success:^(QSAPIModelDict *response) {
                                                                                                                      [weakSelf hideLoadingHud];
                                                           weakSelf.merchantIndexReturnData.data.isStore = @"false";
                                                           [weakSelf.mearchantIndexTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                       } fail:^(NSError *error) {
                                                                                                                      [weakSelf hideLoadingHud];
                                                       }];
        
    }
    
}

- (void)onCell4ButtonAction:(NSInteger)tag
{
    if (tag == 1) {
        
        QSMerchantIntroductionViewController *viewVC = [[QSMerchantIntroductionViewController alloc] init];
        viewVC.item = self.merchantIndexReturnData.data;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    } else if (tag == 2){
        
        QSMerchantEnviromentViewController *viewVC = [[QSMerchantEnviromentViewController alloc] init];
        viewVC.item = self.merchantIndexReturnData.data;
        viewVC.merchant_id = self.merchant_id;
        viewVC.merchant_image = self.merchantLogoImageView.image;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    } else if (tag == 3){
        
        QSMerchantFoodlistViewController *viewVC = [[QSMerchantFoodlistViewController alloc] init];
        viewVC.merchant_id = self.merchant_id;
        viewVC.merchantIndexReturnData = self.merchantIndexReturnData;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    } else if (tag == 4){
        
        ///进入优惠券列表
        QSNormalRecommendViewController *couponListVC = [[QSNormalRecommendViewController alloc] initWithMerchantID:self.merchant_id];
        [self.navigationController pushViewController:couponListVC animated:YES];
        
    }
    else if (tag == 5){
        
        ///商户评价列表
        QSFoodCommentViewController *viewVC = [[QSFoodCommentViewController alloc] init];
        viewVC.merchant_id = self.merchant_id;
        viewVC.merchantDetailData = self.merchantIndexReturnData.data;
        viewVC.merchantLogo = self.merchantLogoImageView.image;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    } else if (tag == 6){
        
        ///商户定位
        QSMapNavViewController *viewVC = [[QSMapNavViewController alloc] init];
        QSMerchantListReturnData *info = [[QSMerchantListReturnData alloc] init];
        NSMutableArray *data = [[NSMutableArray alloc] init];
        [data addObject:self.merchantIndexReturnData.data];
        info.msg = data;
        viewVC.merchantListReturnData = info;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    } else if (tag == 7){
        
        ///进入对应商户的搭食团列表
        QSFoodGroudViewController *foodGroudListVC = [[QSFoodGroudViewController alloc] initWithType:MERCHANT_ALL_FLT andMerchantID:self.merchant_id];
        [self.navigationController pushViewController:foodGroudListVC animated:YES];
        
    }
    else if (tag == 8){
        [self merchantAddError];
    }
}

- (void)merchantAddError
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"商户已关",@"商户位置错误",@"商户信息错误",@"商户重复", nil];
    [actionSheet showInView:self.view];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.rowCtn = 3;
    if (self.merchantIndexReturnData.data.pro.count) {
        self.rowCtn++;
        self.isPro = YES;
    }
    if (self.merchantIndexReturnData.data.coup.count) {
        self.rowCtn++;
        self.isCoup = YES;
    }
    return self.rowCtn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        return 200;
        
    } else if (self.isCoup && indexPath.row == 1) {
        
        return 200;
        
    } else if (indexPath.row == 1) {
        
        return 90;
        
    } else if (self.isPro && self.isCoup&&indexPath.row==1){
        
        ///
        return 200.0f;
        
        
    } else if (indexPath.row == 1) {
        
        return 200;
        
    } else if (self.isPro && self.isCoup){
        
        if (indexPath.row == 2 || indexPath.row == 3) {
            
            return 50;
            
        } else {
            
            return 190;
            
        }
        
    } else if (self.isPro && !self.isCoup){
        
        if (indexPath.row == 2) {
            
            return 50;
            
        } else {
            
            return 190;
            
        }
        
    } else if (!self.isPro && self.isCoup){
        
        if (indexPath.row == 2) {
            
            return 50;
            
        } else {
            
            return 190;
            
        }
        
    } else if (!self.isPro && !self.isCoup){
        
        return 190;
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSMerchantIndexViewController *weakSelf = self;
    if (indexPath.row == 0) {
        static NSString *identifier = @"Cell";
        QSMerchantIndexCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantIndexCell1" owner:self options:nil];
            if ([nibs count] > 0) {
                cell = nibs[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.item = self.merchantIndexReturnData.data;
        cell.onCollectHandler = ^(BOOL isCollected){
            [weakSelf onCollectButtonAction:nil];
        };
        return cell;
        
    } else if (indexPath.row == 1){
        
        static NSString *identifier = @"Cell";
        QSMerchantIndexCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantIndexCell2" owner:self options:nil];
            if ([nibs count] > 0) {
                
                cell = nibs[0];
                
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }

        cell.item = self.merchantIndexReturnData.data;
        
        cell.onCallButtonHandler = ^{
            
            [weakSelf onPhoneCallButtonAction:nil];
            
        };
        cell.onChatButtonHandler = ^{
            
            [weakSelf onChatButtonAction:nil];
            
        };
        
        cell.onAllButtonHandler = ^{};
        
        ///点击菜品
        cell.onFoodButtonHandler = ^(NSString *goods_id){
            
            QSFoodDetailViewController *viewVC = [[QSFoodDetailViewController alloc] init];
            viewVC.goods_id = goods_id;
            [weakSelf.navigationController pushViewController:viewVC animated:YES];
            
            
        };

        if (!self.isCoup) {
             [cell.couponView removeFromSuperview];
        }
        
        return cell;
        
    } else if (self.isPro && self.isCoup){
        
        if (indexPath.row == 2) {
            
            static NSString *identifier = @"Cell";
            QSMerchantIndexCell3 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantIndexCell3" owner:self options:nil];
                if ([nibs count] > 0) {
                    cell = nibs[0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.protype = kProType_Promotion;
            cell.item = self.merchantIndexReturnData.data.pro[0];
            
            return cell;
            
        } else if (indexPath.row == 3){
            
            static NSString *identifier = @"Cell";
            QSMerchantIndexCell3 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantIndexCell3" owner:self options:nil];
                if ([nibs count] > 0) {
                    cell = nibs[0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.protype = kProType_Coupon;
            cell.item = self.merchantIndexReturnData.data.coup[0];
            
            return cell;
            
        } else {
            
            static NSString *identifier = @"Cell";
            QSMerchantIndexCell4 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantIndexCell4" owner:self options:nil];
                if ([nibs count] > 0) {
                    cell = nibs[0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            cell.item = self.merchantIndexReturnData.data;
            cell.onButtonHandler = ^(NSInteger tag){
                
                [weakSelf onCell4ButtonAction:tag];
                
            };
            
            return cell;
        }
        
    } else if (self.isPro && !self.isCoup){
        
        if (indexPath.row == 2) {
            
            static NSString *identifier = @"Cell";
            QSMerchantIndexCell3 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantIndexCell3" owner:self options:nil];
                if ([nibs count] > 0) {
                    
                    cell = nibs[0];
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.protype = kProType_Promotion;
            cell.item = self.merchantIndexReturnData.data.pro[0];
            
            return cell;
            
        } else {
            
            static NSString *identifier = @"Cell";
            QSMerchantIndexCell4 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantIndexCell4" owner:self options:nil];
                if ([nibs count] > 0) {
                    cell = nibs[0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.item = self.merchantIndexReturnData.data;
            cell.onButtonHandler = ^(NSInteger tag){
                [weakSelf onCell4ButtonAction:tag];
            };
            
            return cell;
        }
    }
    else if (!self.isPro && self.isCoup){
        if (indexPath.row == 2) {
            static NSString *identifier = @"Cell";
            QSMerchantIndexCell3 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantIndexCell3" owner:self options:nil];
                if ([nibs count] > 0) {
                    cell = nibs[0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.protype = kProType_Coupon;
            cell.item = self.merchantIndexReturnData.data.coup[0];
            
            return cell;
        }
        else{
            static NSString *identifier = @"Cell";
            QSMerchantIndexCell4 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantIndexCell4" owner:self options:nil];
                if ([nibs count] > 0) {
                    cell = nibs[0];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.item = self.merchantIndexReturnData.data;
            cell.onButtonHandler = ^(NSInteger tag){
                [weakSelf onCell4ButtonAction:tag];
            };
            
            return cell;
        }
    }
    else if (!self.isPro && !self.isCoup){
        static NSString *identifier = @"Cell";
        QSMerchantIndexCell4 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantIndexCell4" owner:self options:nil];
            if ([nibs count] > 0) {
                cell = nibs[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.item = self.merchantIndexReturnData.data;
        cell.onButtonHandler = ^(NSInteger tag){
            [weakSelf onCell4ButtonAction:tag];
        };
        
        return cell;
    }
    
    return nil;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[QSMerchantIndexCell3 class]]) {
        NSDictionary *info;
        if (((QSMerchantIndexCell3 *)cell).protype == kProType_Promotion) {
            info  = self.merchantIndexReturnData.data.pro[0];
        }
        else if (((QSMerchantIndexCell3 *)cell).protype == kProType_Coupon){
            info  = self.merchantIndexReturnData.data.coup[0];
        }
        QSMarCouponDetailDataModel *de = [[QSMarCouponDetailDataModel alloc] init];
        de.couponType = info[@"goods_type"];
        de.couponSubType = info[@"goods_v_type"];
        
        MYLUNCHBOX_COUPON_TYPE couponType = [de formatCouponTypeWithType];
        
        NSString *merchant_name = self.merchantIndexReturnData.data.merchant_name;
        NSString *merchant_id = self.merchantIndexReturnData.data.merchant_id;
        NSString *coupon_id = info[@"id"];
        
        ///判断是否储值卡
        if (couponType == PREPAIDCARD_MCT) {
            
            ///进入储值卡独立详情页面
            QSPrepaidCardDetailViewController *src = [[QSPrepaidCardDetailViewController alloc] initWithMarchantName:merchant_name andMarID:merchant_id andPrepaidCardID:coupon_id];
            [self.navigationController pushViewController:src animated:YES];
            
            return;
        }
        
        ///判断是否是菜品:进入菜品优惠页面
        if (couponType == FOODOFF_MCT) {
            
            QSFoodOfferDetailViewController *foodOfferDetail = [[QSFoodOfferDetailViewController alloc] initWithCouponID:coupon_id andCouponType:couponType andCouponStatus:DEFAULT_MCS];
            [self.navigationController pushViewController:foodOfferDetail animated:YES];
            
            return;
        }
        
        ///推进优惠券详情页面
        QSYCouponDetailViewController *detailVC = [[QSYCouponDetailViewController alloc] initWithMarName:merchant_name andMarchantID:merchant_id andCouponID:coupon_id andCouponType:couponType];
        [self.navigationController pushViewController:detailVC animated:YES];
        

    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111) {
        if (buttonIndex == 1) {
            [[UserManager sharedManager].carlist removeAllObjects];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *str = nil;
    switch (buttonIndex)
    {
        case 0:
            str = @"商户已关";
            break;
        case 1:
            str = @"商户位置错误";
            break;
        case 2:
            str = @"商户信息错误";
            break;
        case 3:
            str = @"商户重复";
            break;
    }
    if (!str) {
        return;
    }
    __weak QSMerchantIndexViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] merchantAddError:self.merchant_id
                                                desc:str
                                             success:^(QSAPIModelString *response) {
                                                 [weakSelf hideLoadingHud];
                                                 [weakSelf showTip:self.view tipStr:@"提交成功"];
                                             } fail:^(NSError *error) {
                                                 [weakSelf hideLoadingHud];                                                 
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
