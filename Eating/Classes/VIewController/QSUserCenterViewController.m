//
//  QSUserCenterViewController.m
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSUserCenterViewController.h"
#import "QSCenterOrderCell.h"
#import <UIImageView+AFNetworking.h>
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"
#import "NSString+Name.h"
#import "QSMyAccountViewController.h"
#import "QSMyDetectiveViewController.h"
#import "QSTakeoutOrderListViewController.h"
#import "QSMyLunchBoxViewController.h"
#import "QSMessageManageViewController.h"
#import "UIImage+Orientaion.h"
#import "UIImage+Thumbnail.h"
#import "QSTabbarViewController.h"
#import "QSCollectionViewController.h"
#import "QSStarViewController.h"
#import "QSMyTradeListViewController.h"
#import "QSFoodGroudViewController.h"
#import "QSFoodGroudViewController.h"
#import "QSFoodDetectiveViewController.h"
#import "AppDelegate.h"

@interface QSUserCenterViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *listNames;
@property (nonatomic, strong) NSArray *listIcons;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *fullImage;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic,strong) UIButton *systemMessageCountButton;//!<系统消息记录数量按钮

@end

@implementation QSUserCenterViewController

- (NSArray *)listNames
{
    if (!_listNames) {
        _listNames = @[
                       @"全部订单",
                       @"藏食阁",
                       @"我的探店",
                       @"我的搭食团",
                       @"我的餐盒",
                       @"我的交易"
                       ];
    }
    return _listNames;
}

- (NSArray *)listIcons
{
    if (!_listIcons) {
        _listIcons = @[
                       @"user_list_icon1.png",
                       @"user_list_icon2.png",
                       @"user_list_icon3.png",
                       @"user_list_icon4.png",
                       @"user_list_icon5.png",
                       @"user_list_icon6.png"
                       ];
    }
    return _listIcons;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.userScrollowView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.listTableView.frame)+10);
    
    ///系统消息记录
    self.systemMessageCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.systemMessageCountButton.frame = CGRectMake(self.messageButton.frame.origin.x+self.messageButton.frame.size.width - 10.0f, self.messageButton.frame.origin.y-5.0f, 20.0f, 20.0f);
    self.systemMessageCountButton.backgroundColor = [UIColor redColor];
    self.systemMessageCountButton.layer.cornerRadius = 10.0f;
    self.systemMessageCountButton.hidden = YES;
    [self.systemMessageCountButton setTitle:@"2" forState:UIControlStateNormal];
    self.systemMessageCountButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.systemMessageCountButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.systemMessageCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.messageButton.superview addSubview:self.systemMessageCountButton];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    QSUserData *userData = [UserManager sharedManager].userData;
    
    if (self.thumbImage) {
        self.portraitImageView.image = self.thumbImage;
        self.bgImageView.image = self.fullImage;
    }
    else{
        [self.portraitImageView setImageWithURL:[NSURL URLWithString:[userData.logo imageUrl]] placeholderImage:nil];
        [self.bgImageView setImageWithURL:[NSURL URLWithString:[userData.logo imageUrl]] placeholderImage:nil];
    }
    if (userData.user_id) {
        UIView *starView = [QSStarViewController cellStarView:5 showPointLabal:YES];
        starView.center = CGPointMake(self.starbgImageView.frame.size.width/2, self.starbgImageView.frame.size.height/2+3);
        [self.starbgImageView addSubview:starView];
        
    }
    else{
        self.starbgImageView.hidden = YES;
    }
    self.titleLabel.text = userData.username ? userData.username : @"未登录";
    
    ///更新推送消息的条数
    [self showMyMessageCount];
    
}

- (void)setupUI
{
    
    self.userScrollowView.contentSize = CGSizeMake(320, 530);
    [self.portraitImageView roundView];
    [self.portraitImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.portraitImageView.layer setBorderWidth:3];
}

- (IBAction)onOrderButtonAction:(id)sender
{
    
    BOOL isLogin = [self checkIsLogin];
    if (!isLogin) {
        return;
    }
    
    UIButton *button = sender;
    if (button == self.orderButton1) {
        
        QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
        viewVC.orderType = 1;
        viewVC.orderListType = kOrderListType_Book;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    }
    
    else if (button == self.orderButton2){
        
        QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
        viewVC.orderType = 2;
        viewVC.orderListType = kOrderListType_Book;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    }
    
    else if (button == self.orderButton3){
        
        ///待完成任务：美食侦探暂时弹出期待
        [self showTip:self.view tipStr:@"敬请期待"];
        
    }
    
    else if (button == self.orderButton4){
        
        ///进入我的搭食团
        QSFoodGroudViewController *myGoodGroudVC = [[QSFoodGroudViewController alloc] initWithType:PRIVATE_UNCOMMMITED_FLT];
        [self.navigationController pushViewController:myGoodGroudVC animated:YES];
        
    }

}

- (IBAction)onEditButtonAction:(id)sender
{
#if 1
    BOOL isLogin = [self checkIsLogin];
    if (!isLogin) {
        return;
    }
#endif
    QSMyAccountViewController *viewVC = [[QSMyAccountViewController alloc] init];
    [self.navigationController pushViewController:viewVC animated:YES];
}

- (IBAction)onMessageButtonAction:(id)sender
{
    
    QSMessageManageViewController *viewVC = [[QSMessageManageViewController alloc] init];
    [self.navigationController pushViewController:viewVC animated:YES];
    
}

- (IBAction)onCameraButtonAction:(id)sender
{
    
    BOOL isLogin = [self checkIsLogin];
    if (!isLogin) {
        return;
    }
    
    [self showCameraActionSheetWithCallBack:^(NSInteger index) {
        
        [self showCameraAndAblumn:index];
        
    }];
}



- (void)showCameraAndAblumn:(NSInteger)index
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
    }
    BOOL isCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!isCamera && index == 1){
        return;
    }
    switch (index) {
        case 1:
        {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.allowsEditing = YES;
            [self presentViewController:_imagePicker animated:YES completion:nil];
            
        }
            break;
        case 2:
        {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _imagePicker.allowsEditing = YES;
            [self presentViewController:_imagePicker animated:YES completion:nil];
            
           
        }
        default:
            break;
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    QSCenterOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSCenterOrderCell" owner:self options:nil];
        if ([nibs count] > 0) {
            cell = nibs[0];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.nameLabel.text = self.listNames[indexPath.row];
    cell.iconImageView.image = IMAGENAME(self.listIcons[indexPath.row]);
    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#if 1
    BOOL isLogin = [self checkIsLogin];
    if (!isLogin) {
        return;
    }
#endif
    switch (indexPath.row) {
        case 0:
        {
//            type
//            1 未完成
//            2 待评价
//            3 全部
            QSTakeoutOrderListViewController *viewVC = [[QSTakeoutOrderListViewController alloc] init];
            viewVC.orderType = 3;
            viewVC.orderListType = kOrderListType_Book;
            [self.navigationController pushViewController:viewVC animated:YES];
        }
            break;
        case 1:
        {
            QSCollectionViewController *viewVC = [[QSCollectionViewController alloc] init];
            [self.navigationController pushViewController:viewVC animated:YES];
        }
            break;
        case 2:
        {
            
            //QSMyDetectiveViewController *src = [[QSMyDetectiveViewController alloc] init];
            //[self.navigationController pushViewController:src animated:YES];
            
            QSFoodDetectiveViewController *foodDetective =
            [[QSFoodDetectiveViewController alloc] init];
            
            [self.navigationController pushViewController:foodDetective animated:YES];
            
        }
            break;
        case 3:
        {
            ///我的搭食团列表
            QSFoodGroudViewController *foodGroudVC = [[QSFoodGroudViewController alloc] initWithType:PRIVATE_FLT];
            [self.navigationController pushViewController:foodGroudVC animated:YES];
        }
            break;
        case 4:
        {
            ///我的餐盒列表
            QSMyLunchBoxViewController *myLaunch = [[QSMyLunchBoxViewController alloc] init];
            [self.navigationController pushViewController:myLaunch animated:YES];
        }
            break;
        case 5:
        {
            QSMyTradeListViewController *viewVC = [[QSMyTradeListViewController alloc] init];
            [self.navigationController pushViewController:viewVC animated:YES];
        }
            break;

        default:
            break;
        
    }

}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self.tabbarViewController showTabBar];
    __weak QSUserCenterViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        __block UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        newImage = [newImage fixOrientation:newImage];
        
        newImage =[newImage thumbnailWithSize:CGSizeMake(DeviceWidth, DeviceWidth * 0.5f)];
        
        ///刷新UI
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.fullImage = [UIImage imageWithCGImage:[newImage CGImage]];
            [weakSelf showLoadingHud];
            
            [[QSAPIClientBase sharedClient] uploadUserPortrait:self.fullImage success:^(QSAPIModelString *response) {
                
                [weakSelf hideLoadingHud];
                
                [self.portraitImageView setImageWithURL:[NSURL URLWithString:response.msg] placeholderImage:nil];
                [self.bgImageView setImageWithURL:[NSURL URLWithString:response.msg] placeholderImage:nil];
                
                [UserManager sharedManager].userData.logo = response.msg;
                
                [weakSelf showTip:self.view tipStr:@"修改头像成功"];
                
            } fail:^(NSError *error) {
                
                [weakSelf hideLoadingHud];
                [weakSelf showTip:self.view tipStr:@"修改头像失败"];
                
            }];
            
        });
        
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.tabbarViewController showTabBar];
    
}

#pragma mark - 获取本地通知消息，并提示消息条数
- (void)showMyMessageCount
{

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    int count = [appDelegate getJPushMessageCount];
    if (count > 0) {
        
        [self.systemMessageCountButton setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
        self.systemMessageCountButton.hidden = NO;
        
    } else {
    
        [self.systemMessageCountButton setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
        self.systemMessageCountButton.hidden = YES;
    
    }

}

@end
