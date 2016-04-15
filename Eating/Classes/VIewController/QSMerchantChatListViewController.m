//
//  QSMerchantChatListViewController.m
//  Eating
//
//  Created by System Administrator on 12/17/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMerchantChatListViewController.h"
#import "QSMerchantChatCell1.h"
#import "QSMerchantChatCell2.h"
#import "MJRefresh.h"
#import "QSAPIClientBase+Message.h"
#import "QSAPIModel+Message.h"
#import "QSAPIModel+Merchant.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"

@interface QSMerchantChatListViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, strong) NSArray *dataarray;
@property (nonatomic, strong) QSMerchantChatListReturnData *merchantChatListReturnData;

@end

@implementation QSMerchantChatListViewController

- (void)setMerchantChatListReturnData:(QSMerchantChatListReturnData *)merchantChatListReturnData
{
    _merchantChatListReturnData = merchantChatListReturnData;
    
    
    
    [self.dataSource addObjectsFromArray:_merchantChatListReturnData.data];
    
    NSArray *array = [[self.dataSource reverseObjectEnumerator] allObjects];
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:array];
    
    [self.chatTableView reloadData];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"商户消息";
    _dataSource = [[NSMutableArray alloc] init];
    [self getMerchantChatList];
    
    
}

- (void)setupUI
{
    self.footerView.backgroundColor = kBaseBackgroundColor;
    [self.sendButton.layer setBorderWidth:0.3];
    [self.sendButton roundCornerRadius:3];
    [self.sendButton.layer setBorderColor:kBaseLightGrayColor.CGColor];
    [self.sendButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    [self.view sendSubviewToBack:self.chatTableView];
    
    ///弹出键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - 弹出键盘
- (void)showKeyboardNotification:(NSNotification *)notification
{
    
    NSTimeInterval anTime;
    [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
    
    [UIView animateWithDuration:anTime animations:^{
        
        ///把输入框上移
        self.chatTableView.frame = CGRectMake(self.chatTableView.frame.origin.x, 89.0f - 255.0f, self.chatTableView.frame.size.width , self.chatTableView.frame.size.height);
        self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, DeviceHeight-50.0f-255.0f, self.footerView.frame.size.width , 50.0f);
        
    }];
    
}

#pragma mark -键盘回收
- (void)hideKeyboardNotification:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        ///把输入框下移
        self.chatTableView.frame = CGRectMake(self.chatTableView.frame.origin.x, 89.0f, self.chatTableView.frame.size.width , self.chatTableView.frame.size.height);
        self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, DeviceHeight-50.0f, self.footerView.frame.size.width , 50.0f);
        
    }];
    
}

- (void)getMerchantChatList
{
    __weak QSMerchantChatListViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] merchantChatList:self.merchantDetailData.merchant_id
                                                page:1
                                             success:^(QSMerchantChatListReturnData *response) {
                                                 weakSelf.merchantChatListReturnData = response;
                                             } fail:^(NSError *error) {
                                                 
                                             }];
}

- (IBAction)onSendButtonAction:(id)sender
{
    __weak QSMerchantChatListViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] merchantChatAdd:self.merchantDetailData.merchant_id
                                     from_user_name:[UserManager sharedManager].userData.username
                                            to_name:self.merchantDetailData.merchant_name
                                            content:self.inputTextView.text success:^(QSAPIModelString *response) {
                                                
                                                QSMerchantChatDetailData *info = [[QSMerchantChatDetailData alloc] init];
                                                info.from_user_id = [UserManager sharedManager].userData.user_id;
                                                info.from_user_nam = [UserManager sharedManager].userData.username;
                                                
                                                info.content = self.inputTextView.text;
                                                NSDate *today = [NSDate date];
                                                
                                                info.send_time = [NSString stringWithFormat:@"%lf",today.timeIntervalSince1970];
                                                
                                                [weakSelf.dataSource addObject:info];
                                                
                                                [weakSelf.chatTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                
                                                weakSelf.inputTextView.text = @"";
                                                
                                            } fail:^(NSError *error) {
                                                
                                            }];
    
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
    QSMerchantChatDetailData *info = self.dataSource[indexPath.row];
    CGSize size = [info.content sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(DeviceWidth-80, 300) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height+60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    
    
    
    QSMerchantChatDetailData *info = self.dataSource[indexPath.row];
    
    
    if ([info.parent_id integerValue] <= 0) {
        
        QSMerchantChatCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantChatCell2" owner:self options:nil];
            if ([nibs count] > 0) {
                cell = nibs[0];
            }
            cell.item = info;
            
        }
        return cell;
    } else {
        
        
        
        QSMerchantChatCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSMerchantChatCell1" owner:self options:nil];
            if ([nibs count] > 0) {
                cell = nibs[0];
            }
            cell.item = info;
            
        }
        return cell;
    }
    
    return nil;
}


#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.inputTextView resignFirstResponder];
    
}

#pragma mark --开启显示底部
- (void)viewDidAppear:(BOOL)animated
{
    
    NSUInteger sectionCount = [self.chatTableView numberOfSections];
    if (sectionCount) {
        
        NSUInteger rowCount = [self.chatTableView numberOfRowsInSection:0];
        if (rowCount) {
            
            NSUInteger ii[2] = {0, rowCount - 1};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [self.chatTableView scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }  
    }
    
}


@end
