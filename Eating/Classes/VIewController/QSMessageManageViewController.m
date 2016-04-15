//
//  QSMessageManageViewController.m
//  Eating
//
//  Created by System Administrator on 12/5/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMessageManageViewController.h"
#import "QSMerchantChatListViewController.h"
#import "QSAPIClientBase+Message.h"
#import "QSAPIModel+Message.h"
#import "MJRefresh.h"
#import "QSUserMessageCell.h"
#import "QSMerchantChatListViewController.h"
#import "QSAPIModel+Merchant.h"
#import "AppDelegate.h"
#import "QSSystemMessageTableViewCell.h"
#import "QSNotificationDataModel.h"
#import "QSMerchantIndexViewController.h"

typedef enum
{
    kRefreshType_No,
    kRefreshType_Header,
    kRefreshType_Footer
}kRefreshType;

@interface QSMessageManageViewController ()

@property (nonatomic, strong) QSUserTalkListReturnData *userTalkListReturnData;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *merchantDataSource;
@property (nonatomic, strong) NSMutableArray *systemDataSource;

@property (nonatomic, unsafe_unretained) NSInteger merchantPage;
@property (nonatomic, unsafe_unretained) NSInteger systemPage;

@property (nonatomic, unsafe_unretained) kRefreshType refreshType;
@end

@implementation QSMessageManageViewController

- (void)setUserTalkListReturnData:(QSUserTalkListReturnData *)userTalkListReturnData
{
    _userTalkListReturnData = userTalkListReturnData;
    
    if (self.refreshType == kRefreshType_Header) {
        
        self.merchantDataSource = [NSMutableArray arrayWithArray:_userTalkListReturnData.data];
        
    } else if (self.refreshType == kRefreshType_Footer){
        
        [self.merchantDataSource addObjectsFromArray:_userTalkListReturnData.data];
        
    }
    
    self.dataSource = [NSMutableArray arrayWithArray:self.merchantDataSource];
    [self.messageTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    
    ///判断是否已登录
    BOOL isLogin = [self checkIsLoginWithoutLoginAction];
    
    if (isLogin) {
        
        [self onSegmentButtonAction:self.segmentButton1];
        
    } else {
    
        [self onSegmentButtonAction:self.segmentButton2];
    
    }
    
}

- (void)setupUI
{
    
    [self.segmentButton1 roundCornerRadius:13];
    self.segmentButton1.tag = 460;
    [self.segmentButton2 roundCornerRadius:13];
    self.segmentButton2.tag = 461;
    
}

- (void)setupTableView
{
    [self.messageTableView addHeaderWithCallback:^{
       
        self.refreshType = kRefreshType_Header;
        [self showLoadingHud];
        
        if (self.segmentButton1.selected) {
            
            self.merchantPage = 1;
            [self getUserTalkList];
            
        }
        else{
            
            self.merchantPage = 1;
            [self getSystemMessage];
            
        }
        
    }];
    
    [self.messageTableView addFooterWithCallback:^{

        [self showLoadingHud];
        if (self.segmentButton1.selected) {
            
            self.refreshType = kRefreshType_Footer;
            self.merchantPage++;
            [self getUserTalkList];
            
        } else {
            
            [self hideLoadingHud];
            [self.messageTableView headerEndRefreshing];
            [self.messageTableView footerEndRefreshing];
            
        }
    }];
}

- (IBAction)onSegmentButtonAction:(id)sender
{
    
    UIButton *button = sender;
    if (button.tag == 460) {
        
        ///检测登录
        if (![self checkIsLogin]) {
            
            return;
            
        }
        
        [self.segmentButton1 setTitleColor:kBaseOrangeColor forState:UIControlStateNormal];
        [self.segmentButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.segmentButton1 setBackgroundColor:[UIColor whiteColor]];
        [self.segmentButton2 setBackgroundColor:[UIColor clearColor]];
        self.segmentButton1.userInteractionEnabled = NO;
        self.segmentButton2.userInteractionEnabled = YES;
        self.segmentButton1.selected = YES;
        self.segmentButton2.selected = NO;
        
        if (self.merchantDataSource.count) {
            
            self.dataSource = [NSMutableArray arrayWithArray:self.merchantDataSource];
            [self.messageTableView reloadData];
            
        } else {
            
            [self.messageTableView headerBeginRefreshing];
            
        }
        
    } else if(button.tag == 461) {
        
        [self.segmentButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.segmentButton2 setTitleColor:kBaseOrangeColor forState:UIControlStateNormal];
        [self.segmentButton1 setBackgroundColor:[UIColor clearColor]];
        [self.segmentButton2 setBackgroundColor:[UIColor whiteColor]];
        self.segmentButton1.userInteractionEnabled = YES;
        self.segmentButton2.userInteractionEnabled = NO;
        self.segmentButton1.selected = NO;
        self.segmentButton2.selected = YES;
        
        if (self.systemDataSource.count) {
            
            self.dataSource = [NSMutableArray arrayWithArray:self.systemDataSource];
            [self.messageTableView reloadData];
            
        } else {
            
            [self.messageTableView headerBeginRefreshing];
            
        }
        
    }
}

#pragma mark - 请求用户的聊天记录
- (void)getUserTalkList
{
    
    __weak QSMessageManageViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] userChatList:self.merchantPage
                                         success:^(QSUserTalkListReturnData *response) {
                                             
                                             if ([response.data count] > 0) {
                                                 
                                                 ///移聊暂无记录
                                                 [self showNoRecordUI:NO];
                                                 
                                                 ///请求成功
                                                 [weakSelf hideLoadingHud];
                                                 [weakSelf.messageTableView headerEndRefreshing];
                                                 [weakSelf.messageTableView headerEndRefreshing];
                                                 weakSelf.userTalkListReturnData = response;
                                                 
                                             } else {
                                                 
                                                 if (self.merchantPage == 1) {
                                                     
                                                     [self showNoRecordUI:YES];
                                                     
                                                 }
                                             
                                                 [weakSelf hideLoadingHud];
                                                 [weakSelf.messageTableView headerEndRefreshing];
                                                 [weakSelf.messageTableView headerEndRefreshing];
                                                 weakSelf.userTalkListReturnData = response;
                                             
                                             }
                                             
                                             [weakSelf hideLoadingHud];
                                             [weakSelf.messageTableView headerEndRefreshing];
                                             [weakSelf.messageTableView headerEndRefreshing];
                                             weakSelf.userTalkListReturnData = response;
                                             
                                         } fail:^(NSError *error) {
                                             
                                             if (self.merchantPage == 1) {
                                                 
                                                 [self showNoRecordUI:YES];
                                                 
                                             }
                                             
                                             [weakSelf hideLoadingHud];
                                             [weakSelf.messageTableView headerEndRefreshing];
                                             [weakSelf.messageTableView headerEndRefreshing];
                                             if (weakSelf.merchantPage > 1) {
                                                 
                                                 weakSelf.merchantPage--;
                                                 
                                             };
                                             
                                         }];
}

#pragma mark - 请求系统推送信息
- (void)getSystemMessage
{
    
    AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
    if (appDelegate) {
        
        ///获取系统推送消息
        NSArray *tempArray = [appDelegate getJPushMessageArray];
        if ([tempArray count] > 0) {
            
            ///移除无记录
            [self showNoRecordUI:NO];
            
            ///有系统消息
            self.dataSource = [tempArray mutableCopy];
            
            ///修改阅读状态
            [appDelegate updateReadFlag];
            
            [self hideLoadingHud];
            [self.messageTableView reloadData];
            [self.messageTableView headerEndRefreshing];
            [self.messageTableView footerEndRefreshing];
            
        } else {
        
            ///无系统消息
            [self showNoRecordUI:YES];
            [self hideLoadingHud];
            [self.dataSource removeAllObjects];
            [self.messageTableView reloadData];
            [self.messageTableView headerEndRefreshing];
            [self.messageTableView footerEndRefreshing];
        
        }
        
    }

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segmentButton1.selected) {
        
        return 85.0f;
        
    }
    
    return 90.0f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segmentButton1.selected) {
        
        static NSString *identifier = @"merchantMessageCell";
        QSUserMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSUserMessageCell" owner:self options:nil];
            if ([nibs count] > 0) {
                cell = nibs[0];
            }
            
            cell.item = self.dataSource[indexPath.row];
            
        }
        
        return cell;
        
    }
    
    static NSString *sysIdentifier = @"systemMessageCell";
    QSSystemMessageTableViewCell *sysCell = [tableView dequeueReusableCellWithIdentifier:sysIdentifier];
    if (nil == sysCell) {
        
        sysCell = [[QSSystemMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sysIdentifier];
        
    }
    
    ///获取消息模型
    QSNotificationDataModel *model = self.dataSource[indexPath.row];
    
    ///刷新数据
    [sysCell updateSystemMessage:model.showMessage];
    
    return sysCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segmentButton1.selected) {
        
        QSMerchantChatDetailData *chatData = self.dataSource[indexPath.row];
        QSMerchantChatListViewController *viewVC = [[QSMerchantChatListViewController alloc] init];
        QSMerchantDetailData *info = [[QSMerchantDetailData alloc] init];
        info.merchant_logo = chatData.merchant_logo;
        info.merchant_name = chatData.merchant_name;
        info.merchant_id = chatData.to_merchant_id;
        viewVC.merchantDetailData = info;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    } else {
        
        /**
         *  type :
         *  1000 => 纯属推送，没任何事件
         *  1001 => 商家的推送
         *  1002 => 优惠卷的
         *  1003 => 订座的
         *  1004 => 外卖的
         *  1005 => 系统通知的
         *  1006 => 搭食团
         *  1007 => 促销优惠的
         *  1008 => 活动
         *  id : 具体对应的id值
         */
    
        ///系统消息点击
        QSNotificationDataModel *model = self.dataSource[indexPath.row];
        if ([model.messageType isEqualToString:@"1001"]) {
            
            [self gotoMerchantDetailMessage:model.targetID];
            
        }
    
    }
    
}

#pragma mark - 商户推荐：进入商户
- (void)gotoMerchantDetailMessage:(NSString *)merchantID
{

    if (merchantID) {
        
        QSMerchantIndexViewController *marDetail = [[QSMerchantIndexViewController alloc] init];
        marDetail.merchant_id = merchantID;
        [self.navigationController pushViewController:marDetail animated:YES];
        
    }

}

@end
