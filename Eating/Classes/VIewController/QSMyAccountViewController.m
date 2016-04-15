//
//  QSMyAccountViewController.m
//  Eating
//
//  Created by System Administrator on 11/20/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMyAccountViewController.h"
#import "QSCenterOrderCell.h"
#import "QSChangeUsernameViewController.h"
#import "QSChangePasswordViewController.h"
#import "QSBindEMailViewController.h"
#import "QSBindMobileViewController.h"
#import "QSDeliveryListViewController.h"
#import "QSFoodTagEditViewController.h"

@interface QSMyAccountViewController ()

@property (nonatomic, strong) NSArray *listNames;
@property (nonatomic, strong) NSArray *listIcons;

@end

@implementation QSMyAccountViewController

- (NSArray *)listNames
{
    if (!_listNames) {
        _listNames = @[
                       @"修改名称",
                       @"账号密码",
                       @"绑定邮箱",
                       @"绑定手机",
                       @"美食标签",
//                       @"美食历史",
                       @"送餐地址"
                       ];
    }
    return _listNames;
}

- (NSArray *)listIcons
{
    if (!_listIcons) {
        _listIcons = @[
                       @"user_accountlist_icon1.png",
                       @"user_accountlist_icon2.png",
                       @"user_accountlist_icon3.png",
                       @"user_accountlist_icon4.png",
                       @"user_accountlist_icon5.png",
                       @"user_accountlist_icon6.png",
                       @"user_accountlist_icon7.png",
                       ];
    }
    return _listIcons;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.accountTableView.tableFooterView = self.footerView;
}

- (IBAction)onLogoutButtonAction:(id)sender
{
    [UserManager sharedManager].userData = nil;
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)setupUI
{
    self.titleLabel.text = @"我的账号";
    [self.logoutButton roundCornerRadius:CGRectGetHeight(self.logoutButton.frame)/2];
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
    BOOL isLogin = [self checkIsLogin];
    if (!isLogin) {
        return;
    }
    switch (indexPath.row) {
        case 0:
        {
            QSChangeUsernameViewController *viewVC = [[QSChangeUsernameViewController alloc] init];
            [self.navigationController pushViewController:viewVC animated:YES];
        }
            break;
        case 1:
        {
            QSChangePasswordViewController *viewVC = [[QSChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:viewVC animated:YES];
        }
            break;
        case 2:
        {
            QSBindEMailViewController *viewVC = [[QSBindEMailViewController alloc] init];
            [self.navigationController pushViewController:viewVC animated:YES];
        }
            break;
        case 3:
        {
            QSBindMobileViewController *viewVC = [[QSBindMobileViewController alloc] init];
            [self.navigationController pushViewController:viewVC animated:YES];
        }
            break;
        case 4:
        {
            QSFoodTagEditViewController *viewVC = [[QSFoodTagEditViewController alloc] init];
            [self.navigationController pushViewController:viewVC animated:YES];
        }
            break;
            
            ///
        case 5:
        {
            QSDeliveryListViewController *viewVC = [[QSDeliveryListViewController alloc] init];
            [self.navigationController pushViewController:viewVC animated:YES];
            break;
        }
            
        case 6:
        {
//            QSDeliveryListViewController *viewVC = [[QSDeliveryListViewController alloc] init];
//            [self.navigationController pushViewController:viewVC animated:YES];
        }
            break;
            
        default:
            break;
    }

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
