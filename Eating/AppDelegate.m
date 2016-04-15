//
//  AppDelegate.m
//  Eating
//
//  Created by System Administrator on 11/11/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "QSTabbarViewController.h"
#import "QSLoginViewController.h"
#import "APService.h"
#import "QSAPI.h"
#import "QSNotificationDataModel.h"
#import "QSAPIClientBase+User.h"

#import <AlipaySDK/AlipaySDK.h>

///控制是否弹出支付宝错误信息提示框宏
#define __SHOWALIXPAY_RESULT__

///应用自定义线程关键字
#define QUEUE_PROJECT_CUSTOM_QUEUE_KEY "ProjectCustomQueueKey"

@interface AppDelegate ()

@property (nonatomic,retain) NSMutableArray *jpushMessageArray;//!<极光推送接收到的消息
@property (nonatomic, strong) dispatch_queue_t messageOperationQueue;//!<推送消息的读取线程

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ///消除通知提醒条数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    ///获取token
    [self getServerToken];
    
    ///推送消息列表初始化
    self.jpushMessageArray = [[NSMutableArray alloc] init];
    ///初始化子线程
    self.messageOperationQueue = dispatch_queue_create(QUEUE_PROJECT_CUSTOM_QUEUE_KEY, DISPATCH_QUEUE_CONCURRENT);
    
    QSTabbarViewController *viewVC = [QSTabbarViewController sharedTabBarController];
    self.window.rootViewController = viewVC;
    
    ///确认最新版本
    [self checkAppVersion];
    
    [self.window makeKeyAndVisible];
    
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    ///Required
    [APService setupWithOption:launchOptions];
    
    ///注册极光推送的消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushMessageReceiveAction:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushMessageReceiveAction:) name:kJPFNetworkDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushMessageReceiveAction:) name:kJPFNetworkDidRegisterNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushMessageReceiveAction:) name:kJPFNetworkDidCloseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushMessageReceiveAction:) name:kJPFNetworkDidSetupNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushMessageReceiveAction:) name:kJPFServiceErrorNotification object:nil];
    
    ///判断是否是通过通知列表进入：弹出提示，同时保存通知
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        
        ///取得 APNs 标准信息内容
        NSDictionary *aps = [launchOptions valueForKey:@"aps"];
        NSString *content = [aps valueForKey:@"alert"];             //!<推送显示的内容
        
        ///弹出说明
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:content delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    return YES;
}

/**
 *  @author yangshengmeng, 15-01-07 20:01:08
 *
 *  @brief  检测版本
 *
 *  @since  2.0
 */
#pragma mark - 检测版本更新
- (void)checkAppVersion
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ///获取本地版本
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        
        ///获取appStore上的最新版本
        NSData *versionData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:QSGetAppStoreVersion]] returningResponse:nil error:nil];
        
        ///判断请求返回的数据
        if (nil == versionData || 0 >= [versionData length]) {
            
            return;
            
        }
        
        NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:versionData options:NSJSONReadingMutableLeaves error:nil];
        
        ///判断是否获取版本信息成功
        if (nil == originalDict || 0>= [originalDict count]) {
            
            return;
            
        }
        
        NSDictionary *versionInfoDcit = [originalDict valueForKey:@"results"][0];
        
        ///判断版本信息字典是否有效
        if (nil == versionInfoDcit || 0 >= [versionInfoDcit count]) {
            
            return;
            
        }
        
        NSString *appStoreVersion = [versionInfoDcit valueForKey:@"version"];
        
        ///判断版本是否有效
        if (nil == appStoreVersion || 2 >= [appStoreVersion length]) {
            
            return;
            
        }
        
        ///对比版本信息
        NSMutableString *localVersion = [appVersion mutableCopy];
        NSMutableString *lastVersion = [appStoreVersion mutableCopy];
        
        ///替换小数点
        [localVersion replaceOccurrencesOfString:@"." withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, localVersion.length)];
        [lastVersion replaceOccurrencesOfString:@"." withString:@"" options:1 range:NSMakeRange(0, lastVersion.length)];
        
        ///判断版本大小
        int intLocalVersion = [localVersion intValue];
        int intLastVersion = [lastVersion intValue];
        
        if (intLastVersion <= intLocalVersion) {
            
            return;
            
        }
        
        ///有新版本，则提示是否更新
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"发现新版本 %@",appStoreVersion] preferredStyle:UIAlertControllerStyleAlert];
            
            ///确认事件
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"立即去更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com"]];
                
            }];
            
            ///取消事件
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                ///移聊提示
                [alertVC dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            }];
            
            ///添加事件
            [alertVC addAction:confirmAction];
            [alertVC addAction:cancelAction];
            
            ///弹出说明框
            [self.window.rootViewController presentViewController:alertVC animated:YES completion:^{}];
            
        });
        
    });

}

#pragma mark - 支付宝支付回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    ///如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            ///回调当前控制器
            NSLog(@"===============AlixPay=====================");
            NSLog(@"sefepay result = %@ safepay result = %@",[resultDic valueForKey:@"resultStatus"],resultDic);
            NSLog(@"===========================================");
            
            ///回调到当前的VC
            if (self.currentControllerCallBack) {
                self.currentControllerCallBack([resultDic valueForKey:@"resultStatus"],[resultDic valueForKey:@"memo"]);
            }
            
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]){
        
        //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            ///回调当前控制器
            NSLog(@"===============AlixPay=====================");
            NSLog(@"sefepay result = %@ safepay result = %@",[resultDic valueForKey:@"resultStatus"],resultDic);
            NSLog(@"===========================================");
            
#ifdef __SHOWALIXPAY_RESULT__
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"测试支付宝使用" message:[NSString stringWithFormat:@"信息：%@    错误编码：%@",[resultDic valueForKey:@"memo"],[resultDic valueForKey:@"resultStatus"]] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
#endif
            
            ///回调到当前的VC
            if (self.currentControllerCallBack) {
                self.currentControllerCallBack([resultDic valueForKey:@"resultStatus"],[resultDic valueForKey:@"memo"]);
            }
            
        }];
    }
    
    return YES;
}

#pragma mark - 极光推送相关设置
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required：极光推送保存设备token
    [APService registerDeviceToken:deviceToken];
    
}

#pragma mark - 通知消息
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    ///消息模型
    QSNotificationDataModel *model = [[QSNotificationDataModel alloc] init];
    
    ///取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"];         //!<推送显示的内容
    NSString *sound = [aps valueForKey:@"sound"];           //!<播放的声音
    
    ///取得自定义字段内容
    NSString *typeString = [userInfo valueForKey:@"type"];  //!<类型
    NSString *idString = [userInfo valueForKey:@"id"];      //!<对应单据的ID
    NSString *titleString = [userInfo valueForKey:@"title"];//!<自定义参数：标题
    
    ///保存消息类型
    model.soundFile = sound;
    model.showMessage = content;
    model.messageType = typeString;
    model.targetID = idString;
    model.messageTitle = titleString;
    
    ///保存消息
    [self addJPushMessageInfo:model];
    
    ///弹出提示
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:content delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
    
    [APService handleRemoteNotification:userInfo];
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    ///消息模型
    QSNotificationDataModel *model = [[QSNotificationDataModel alloc] init];
    
    ///取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"];         //!<推送显示的内容
    NSString *sound = [aps valueForKey:@"sound"];           //!<播放的声音
    
    ///取得自定义字段内容
    NSString *typeString = [userInfo valueForKey:@"type"];  //!<类型
    NSString *idString = [userInfo valueForKey:@"id"];      //!<对应单据的ID
    NSString *titleString = [userInfo valueForKey:@"title"];//!<自定义参数：标题
    
    ///保存消息类型
    model.soundFile = sound;
    model.showMessage = content;
    model.messageType = typeString;
    model.targetID = idString;
    model.messageTitle = titleString;
    
    ///保存消息
    [self addJPushMessageInfo:model];
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    
}

#pragma mark - 接收到极光推送时保存消息
/**
 *  @author             yangshengmeng, 15-01-08 11:01:46
 *
 *  @brief              接收到极光推送消息时，将消息保存在本地
 *
 *  @param notification 极光收到消息时的能知
 *
 *  @since              2.0
 */
- (void)jpushMessageReceiveAction:(NSNotification *)notification
{
    
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
    if ([notification.name isEqualToString:kJPFNetworkDidReceiveMessageNotification]) {
        
        ///消息模型
        QSNotificationDataModel *model = [[QSNotificationDataModel alloc] init];
        model.readFlag = NO;
        
        ///取得 APNs 标准信息内容
        NSDictionary *aps = notification.userInfo;
        NSString *content = [aps valueForKey:@"content"];         //!<推送显示的内容
        NSString *sound = [aps valueForKey:@"sound"];             //!<播放的声音
        
        ///取得自定义字段内容
        NSDictionary *etxtrasDict = [aps valueForKey:@"extras"];
        NSString *typeString = [etxtrasDict valueForKey:@"type"];  //!<类型
        NSString *idString = [etxtrasDict valueForKey:@"id"];      //!<对应单据的ID
        NSString *titleString = [etxtrasDict valueForKey:@"title"];//!<自定义参数：标题
        
        ///保存消息类型
        model.soundFile = sound;
        model.showMessage = content;
        model.messageType = typeString;
        model.targetID = idString;
        model.messageTitle = titleString;
        
        ///保存消息
        [self addJPushMessageInfo:model];
        
    }
    
}

#pragma mark - 新增加一条消息
- (void)addJPushMessageInfo:(QSNotificationDataModel *)msgModel
{
    
    if (nil == msgModel) {
        
        return;
        
    }

    dispatch_barrier_async(self.messageOperationQueue, ^{
        
        ///查询原来是否已存在消息
        int i = 0;
        for (i = 0; i < self.jpushMessageArray.count; i++) {
            
            QSNotificationDataModel *tempModel = _jpushMessageArray[i];
            
            ///如果原来已有对应的消息，则不再添加
            if ([msgModel.targetID isEqualToString:tempModel.targetID] && [msgModel.messageType isEqualToString:tempModel.messageType]) {
                
                return;
                
            }
            
        }
        
        ///没有重复的，则添加
        if (i == self.jpushMessageArray.count) {
            
            [_jpushMessageArray addObject:msgModel];
            
        }
        
    });

}

#pragma mark - 返回当前的推送消息
/**
 *  @author yangshengmeng, 15-01-14 11:01:46
 *
 *  @brief  返回抢着的消息
 *
 *  @return 返回消息数组
 *
 *  @since  2.0
 */
- (NSArray *)getJPushMessageArray
{

    __block NSArray *tempArray;
    
    dispatch_sync(self.messageOperationQueue, ^{
        
        tempArray = [NSArray arrayWithArray:self.jpushMessageArray];
        
    });
    
    return tempArray;

}

/**
 *  @author yangshengmeng, 15-01-14 11:01:30
 *
 *  @brief  返回推送消息的条数
 *
 *  @return 返回推送消息的条数
 *
 *  @since  2.0
 */
- (int)getJPushMessageCount
{

    int count = 0;
    NSArray *tempArray = [self getJPushMessageArray];
    for (int i = 0; i < tempArray.count; i++) {
        
        QSNotificationDataModel *tempModel = tempArray[i];
        if (!tempModel.readFlag) {
            
            count++;
            
        }
        
    }
    return count;

}

/**
 *  @author yangshengmeng, 15-01-14 11:01:13
 *
 *  @brief  更新阅读状态
 *
 *  @since  2.0
 */
- (void)updateReadFlag
{

    dispatch_barrier_async(self.messageOperationQueue, ^{
        
        for (int i = 0; i < self.jpushMessageArray.count; i++) {
            
            QSNotificationDataModel *model = self.jpushMessageArray[i];
            model.readFlag = YES;
            
        }
        
    });

}

#pragma mark - 获取最新token
- (void)getServerToken
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///请求token
        [[QSAPIClientBase sharedClient] getToken:^(BOOL flag, NSString *token) {
            
            ///判断是否成功
            if (flag) {
                
                ///保存token
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"app_token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
        }];
        
    });

}

#pragma mark - 禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
