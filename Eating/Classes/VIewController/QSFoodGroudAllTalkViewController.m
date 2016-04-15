//
//  QSFoodGroudAllTalkViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/24.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodGroudAllTalkViewController.h"
#import "QSBlockActionButton.h"
#import "QSImageView.h"
#import "MJRefresh.h"
#import "QSYTalkInfoTableViewCell.h"
#import "QSAPIClientBase+FoodGroud.h"

#import <objc/runtime.h>

///关联
static char InputInfoKey;//!<输入框
static char InfoCountKey;//!<信息条数
static char InfoListKey;//!<信息列表关联

@interface QSFoodGroudAllTalkViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    NSString *_teamID;              //!<搭团的ID

    NSMutableArray *_messageList;   //!<聊天信息数组
    
    int _page;                      //!<页码
    BOOL _headerFlag;                      //!<头部请求的锁标清：YES-可进行头请求,NO-不可以进行头部请求
    int _pageNumbers;               //!<每页请求的数量：第一次请求时请求5个消息，后面再进行头部刷新时，只请求一个数据

}

@property (nonatomic,strong) NSTimer *updateMessageTimer;//!<获取新消息的定时器

@end

@implementation QSFoodGroudAllTalkViewController

/**
 *  @author         yangshengmeng, 14-12-26 14:12:17
 *
 *  @brief          按给定的搭食团ID进行初始化
 *
 *  @param teamID   搭食团ID
 *
 *  @return         返回当前对象
 *
 *  @since          2.0
 */
- (instancetype)initWithTeamID:(NSString *)teamID
{

    if (self = [super init]) {
        
        ///保存搭食团ID
        _teamID = [teamID copy];
        
        ///初始化信息数组
        _messageList = [[NSMutableArray alloc] init];
        
        ///初始化页码：1
        _page = 1;
        
        ///初始化时，可进行头部请求
        _headerFlag = YES;
        
        ///初始化每次的请求数量
        _pageNumbers = 5;
        
    }
    
    return self;

}

/**
 *  @author yangshengmeng, 14-12-25 10:12:49
 *
 *  @brief  UI搭建
 *
 *  @return
 *
 *  @since  2.0
 */
#pragma mark - UI搭建
- (void)createNavigationBar
{

    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"聊天室"];

}

///添加主展示信息
- (void)createMainShowView
{

    [super createMainShowView];
    
    ///输入框
    UITextView *inputField = [[UITextView alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, 94.0f, DEFAULT_MAX_WIDTH, 120.0f)];
    inputField.delegate = self;
    inputField.font = [UIFont systemFontOfSize:14.0f];
    inputField.layer.cornerRadius = 4.0f;
    [self.view addSubview:inputField];
    objc_setAssociatedObject(self, &InputInfoKey, inputField, OBJC_ASSOCIATION_ASSIGN);
    
    ///聊天条数
    UILabel *infoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT_RIGHT, inputField.frame.origin.y+inputField.frame.size.height+10.0f, 160.0f, 20.0f)];
    infoCountLabel.text = @"共有5条记录";
    infoCountLabel.font = [UIFont systemFontOfSize:14.0f];
    infoCountLabel.textColor = kBaseLightGrayColor;
    [self.view addSubview:infoCountLabel];
    objc_setAssociatedObject(self, &InfoCountKey, infoCountLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///发送按钮
    UIButton *sendButton = [UIButton createBlockActionButton:CGRectMake(DeviceWidth-MARGIN_LEFT_RIGHT-60.0f, infoCountLabel.frame.origin.y-5.0f, 60.0f, 30.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///发送信息
        if ([inputField.text length] > 0) {
            
            [self sendMessage:inputField.text];
            
            ///清空原输入信息
            inputField.text = @"";
            [inputField resignFirstResponder];
            
        }
        
    }];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.layer.cornerRadius = 4.0f;
    sendButton.backgroundColor = kBaseGreenColor;
    [self.view addSubview:sendButton];
    
    ///信息列表的头三角
    QSImageView *arrowImage = [[QSImageView alloc] initWithFrame:CGRectMake(infoCountLabel.frame.origin.x+20.0f, infoCountLabel.frame.origin.y+infoCountLabel.frame.size.height+5.0f, 15.0f, 15.0)];
    arrowImage.image = [UIImage imageNamed:@"foodgroud_team_talk_info_arrow"];
    [self.view addSubview:arrowImage];
    
    ///信息列表
    CGFloat yoint = arrowImage.frame.origin.y+arrowImage.frame.size.height-5.0f;
    UITableView *talkMessageList = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, yoint, DeviceWidth, DeviceHeight-yoint)];
    
    ///取消滚动条
    talkMessageList.showsHorizontalScrollIndicator = NO;
    talkMessageList.showsVerticalScrollIndicator = NO;
    
    ///设置代理
    talkMessageList.dataSource = self;
    talkMessageList.delegate = self;
    
    ///取消分隔线
    talkMessageList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///设置固定行高
    talkMessageList.rowHeight = 75.0f;
    
    ///添加刷新
    [talkMessageList addHeaderWithTarget:self action:@selector(requestMessageList)];
    [talkMessageList headerBeginRefreshing];
    
    [self.view addSubview:talkMessageList];
    objc_setAssociatedObject(self, &InfoListKey, talkMessageList, OBJC_ASSOCIATION_ASSIGN);
    
    ///开启定时器，不断获取最新的消息
    self.updateMessageTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(requestLastMessage) userInfo:nil repeats:YES];

}

/**
 *  @author yangshengmeng, 14-12-26 10:12:30
 *
 *  @brief  返回聊天信息列表
 *
 *  @return 返回聊天信息列表
 *
 *  @since  2.0
 */
#pragma mark - 返回聊天列表的UITableView
- (UITableView *)getFoodGroudTeamInfoList
{

    return objc_getAssociatedObject(self, &InfoListKey);

}

/**
 *  @author             yangshengmeng, 14-12-26 10:12:36
 *
 *  @brief              返回每一个信息的cell
 *
 *  @param tableView    每个信息所在的父列表
 *  @param indexPath    当前第几行
 *
 *  @return             返回信息的cell
 *
 *  @since              2.0
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellName = @"normalCell";
    QSYTalkInfoTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    ///判断：如果不能复用，则创建
    if (nil == myCell) {
        
        myCell = [[QSYTalkInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
    }
    
    ///取消选择状态
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///更新数据
    [myCell updateTalkInfoCellUIWithModel:_messageList[indexPath.row]];
    
    return myCell;

}

///返回信息行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_messageList count];

}

/**
 *  @author yangshengmeng, 14-12-26 12:12:43
 *
 *  @brief  主动发起头部刷新
 *
 *  @since  2.0
 */
#pragma mark - 主动发起头部刷新
- (void)beginHeaderRefresh
{
    
    [[self getFoodGroudTeamInfoList] headerBeginRefreshing];
    
}

/**
 *  @author yangshengmeng, 14-12-26 12:12:43
 *
 *  @brief  请求聊天信息列表
 *
 *  @since  2.0
 */
#pragma mark - 请求聊天信息
- (void)requestLastMessage
{

    ///判断是否可以进行头部请求
    if (!_headerFlag) {
        return;
    }
    
    [self requestMessageList];

}

- (void)requestMessageList
{

    [self requestMessageListWithNumber:@"10" andPage:@"1" andCallBack:^(BOOL flag,NSArray *resultArray) {
        
        ///查看是否请求成功
        if (flag) {
            
            ///判断是否成功
            _page = 1;
            
            ///清空消息
            [_messageList removeAllObjects];
            
            ///将获取的消息插到最前面
            [_messageList addObjectsFromArray:resultArray];
            
            ///刷新数据列表
            [self reloadMessageList];
            
            ///更新消息数量
            [self updateMessageCount:[_messageList count]];
            
            ///请求一次后移除头部刷新
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                
                [[self getFoodGroudTeamInfoList] removeHeader];
                
            });
            
        }
        
    }];

}

///请求更多的聊天信息
- (void)requestMoreMessage
{

    [self requestMessageListWithNumber:@"5" andPage:[NSString stringWithFormat:@"%d",_page+1] andCallBack:^(BOOL flag,NSArray *resultArray) {
        
        ///判断是否成功
        if (flag) {
            
            ///更新页码
            _page += 1;
            
            ///将获取的消息插到最前面
            [_messageList addObjectsFromArray:resultArray];
            
            ///刷新数据列表
            [self reloadMessageList];
            
            return;
            
        }
        
    }];

}

/**
 *  @author         yangshengmeng, 14-12-26 14:12:01
 *
 *  @brief          请求聊天信息，只请求给定的条数
 *
 *  @param pageNum  请求的条数
 *
 *  @since          2.0
 */
- (void)requestMessageListWithNumber:(NSString *)pageNum andPage:(NSString *)pageIndex andCallBack:(void(^)(BOOL flag,NSArray *resultArray))callBack
{
    
    ///封装参数
    NSDictionary *params = @{@"startPage":pageIndex,
                             @"pageNum":pageNum,
                             @"team_id":_teamID};

    [[QSAPIClientBase sharedClient] getTalkMessageList:params andCallBack:^(BOOL flag, NSArray *msgList, NSString *errorInfo, NSString *errorCode) {
        
        ///获取聊天信息成功
        if (flag) {
            
            ///判断是否有新数据
            if ([msgList count] > 0) {
                
                callBack(YES,msgList);
                
            } else {
            
                callBack(NO,nil);
            
            }
            
            ///结束头部刷新
            [[self getFoodGroudTeamInfoList] headerEndRefreshing];
            [[self getFoodGroudTeamInfoList] footerEndRefreshing];
            
            return;
        }
        
        ///获取列表失败
        [self showTip:self.view tipStr:errorInfo ? errorInfo : @"获取聊天记录失败,请稍后再试"];
        callBack(NO,nil);
        
        ///结束头部刷新
        [[self getFoodGroudTeamInfoList] headerEndRefreshing];
        [[self getFoodGroudTeamInfoList] footerEndRefreshing];
        
    }];

}

#pragma mark - 更新消息数量
- (void)updateMessageCount:(NSInteger)count
{

    ///
    UILabel *label = objc_getAssociatedObject(self, &InfoCountKey);
    if (label) {
        label.text = [NSString stringWithFormat:@"共有%d条记录",count];
    }

}

/**
 *  @author yangshengmeng, 14-12-26 12:12:54
 *
 *  @brief  发送信息
 *
 *  @since  2.0
 */
#pragma mark - 发送当前输入的信息
- (void)sendMessage:(NSString *)msg
{
    ///封装参数
    NSDictionary *params = @{@"context":msg,
                             @"team_id":_teamID};
    
    [[QSAPIClientBase sharedClient] sendFoodGroudTalkMessage:params andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
        
        ///发送成功
        if (flag) {
            
            ///刷新消息列表
            [self requestMessageList];
            return;
        }
        
        ///发送失败
        [self showTip:self.view tipStr:@"发送失败，请稍后再发送"];
        
    }];

}

/**
 *  @author yangshengmeng, 14-12-26 12:12:18
 *
 *  @brief  刷新聊天信息框
 *
 *  @since  2.0
 */
#pragma mark - 刷画列表数据
- (void)reloadMessageList
{

    [[self getFoodGroudTeamInfoList] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

}

///回收键盘
#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    UITextView *inputView = objc_getAssociatedObject(self, &InputInfoKey);
    if (inputView) {
        [inputView resignFirstResponder];
    }

}

#pragma mark - 当聊天记录往下滚动查看历史消息时，停止头部刷新
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if (scrollView.contentOffset.x > 150.0f) {
        
        ///停止头部刷新
        [self.updateMessageTimer invalidate];
        
    }
    
    if (scrollView.contentOffset.x) {
        
        ///开启头部刷新
        [self.updateMessageTimer fire];
        
    }

}

#pragma mark - 当退出本页面时，停止刷新
- (void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];
    [self.updateMessageTimer invalidate];

}

@end
