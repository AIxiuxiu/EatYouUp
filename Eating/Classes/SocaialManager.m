//
//  SocaialManager.m
//  Eating
//
//  Created by System Administrator on 12/15/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "SocaialManager.h"
#import "ShareSDK/ShareSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
//#import "UIAlertView+Blocks.h"
//#import "AGCustomShareViewController.h"
#import <CoreImage/CoreImage.h>
//#import "AGCustomShareViewController.h"
#import <AGCommon/UIImage+Common.h>


static NSString *const shareSDK_Key = @"783b9ac2495";

static NSString *const Sina_Key = @"3942388721";
static NSString *const Sina_Secret = @"7807795ec1fd5dd539dee0d1a5bd873d";
static NSString *const Sina_RedirectURL = @"http://www.77cdn.net";

static NSString *const QQ_ID = @"101112212"; // @"QQ41B3AFCE";
static NSString *const Wechat_Key = @"wxae1c683e3959d6cc";

static NSString *const TencentWeibo_Key = @"801512398";
static NSString *const TencentWeibo_Secret = @"1153a25e50ba3d1cc17adbd04788daad";
static NSString *const TencentWeibo_RedirectURL = @"http://www.77cdn.net";
@implementation SocaialManager

+ (SocaialManager *)sharedManager
{
    static SocaialManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;

}

- (id)init
{
    if (self = [super init]) {
        [self setupManager];
    }
    return self;
}

- (void)setupManager
{
    [ShareSDK registerApp:shareSDK_Key];
    
    // . sina
    [ShareSDK connectSinaWeiboWithAppKey:Sina_Key
                               appSecret:Sina_Secret
                             redirectUri:Sina_RedirectURL];
    
    //.  QQ
    [ShareSDK connectQQWithAppId:QQ_ID
                        qqApiCls:[QQApiInterface class]];
    
    //.  TencentWeibo
    [ShareSDK connectTencentWeiboWithAppKey:TencentWeibo_Key
                                  appSecret:TencentWeibo_Secret
                                redirectUri:TencentWeibo_RedirectURL];
    
    // . Wechat
    [ShareSDK connectWeChatWithAppId:Wechat_Key
                           wechatCls:[WXApi class]];
}


- (void)showNewUIShareOnVC:(id)sender
                   Content:(NSString *)content
                  UserName:(NSString*)uname
                  WorkName:(NSString *)work
                    Images:(UIImage *)images
                 ImagesUrl:(NSURL *)url
{
    UIViewController *vc = (UIViewController *)sender;
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:vc.view arrowDirect:UIPopoverArrowDirectionUp];
    //构造分享平台
    NSArray *shareList =  [ShareSDK getShareListWithType :
                           ShareTypeSinaWeibo,
                           ShareTypeQQSpace,
                           ShareTypeWeixiTimeline,
                           nil ];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"内容分享"
                                                           shareViewDelegate:nil];

    
    id<ISSShareActionSheetItem> it1 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^ (SSShareActionSheetItemClickHandler *click){
        //                                                                         CFAttachData *data = self.infoFeedData.attach[0];
        
        [self shareToWechatTimelineWithFeedID:nil
                                      Content:content
                                UserName:uname
                                     WorkName:work
                                       Images:images
                                      Success:^(BOOL success) {
                                          if (!success) {
                                        
                                          }
                                          else{
                                      
                                          }
                                      }];
    }];
    
    
    id<ISSShareActionSheetItem> it2 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        
        [self shareToWechatSessionWithFeedID:nil
                                      Content:content
                                     UserName:uname
                                     WorkName:work
                                       Images:images
                                      Success:^(BOOL success) {
                                          if (!success) {
                                              
                                          }
                                          else{
                                              
                                          }
                                      }];
    }];
    
    
    NSArray *itemlist = @[it1,it2];
    
    id<ISSShareActionSheet> actionsheet = [ShareSDK showShareActionSheet:nil shareList:shareList content:nil statusBarTips:YES authOptions:authOptions shareOptions:shareOptions result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
    }];
    
    [actionsheet showWithContainer:container
                             items:itemlist
                       onItemClick:^(ShareType shareType) {
                           
                       } onCancel:^{
                           
                       }];
}


#pragma mark - 分享
- (void)shareToWechatTimelineWithFeedID:(NSString *)feedID
                                Content:(NSString *)content
                               UserName:(NSString *)uname
                               WorkName:(NSString *)work
                                 Images:(UIImage *)images
                                Success:(void (^)(BOOL))success
{
    images = [self zipShareImage:images];
    
    id<ISSCAttachment> imageAttachment = [self shareAttachmentWithImage:images
                                                                  orUrl:nil];
    
    NSString *contentStr = content;
    id<ISSContent> publishContent = [ShareSDK content:contentStr
                                       defaultContent:content
                                                image:imageAttachment
                                                title:contentStr
                                                  url:@"http://cdn.77tng.com"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //构造授权选项
    id<ISSAuthOptions> authOptions = [self shareAuthOption];
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiTimeline
               authOptions:authOptions
              shareOptions:nil
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            if (success) {
                                success(YES);
                            }
                            NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            if (success) {
                                success(NO);
                            }
                            NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                        }
                    }];
}


- (void)shareToWechatSessionWithFeedID:(NSString *)feedID
                                Content:(NSString *)content
                               UserName:(NSString *)uname
                               WorkName:(NSString *)work
                                 Images:(UIImage *)images
                                Success:(void (^)(BOOL))success
{
    images = [self zipShareImage:images];
    
    id<ISSCAttachment> imageAttachment = [self shareAttachmentWithImage:images
                                                                  orUrl:nil];
    
    NSString *contentStr = content;
    id<ISSContent> publishContent = [ShareSDK content:contentStr
                                       defaultContent:content
                                                image:imageAttachment
                                                title:contentStr
                                                  url:@"http://cdn.77tng.com"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //构造授权选项
    id<ISSAuthOptions> authOptions = [self shareAuthOption];
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiSession
               authOptions:authOptions
              shareOptions:nil
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            if (success) {
                                success(YES);
                            }
                            NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            if (success) {
                                success(NO);
                            }
                            NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                        }
                    }];
}




#pragma mark - 辅助
- (UIImage *)zipShareImage:(UIImage *)originalImage
{
    UIImage *image = originalImage;
    
    if (originalImage.size.width>1000 || originalImage.size.height>1000)
    {
        CGSize imageSize = originalImage.size;
        CGFloat scale = 0;
        if (imageSize.width>imageSize.height) {
            scale = 1000/imageSize.width;
        }else {
            scale = 1000/imageSize.height;
        }
        UIGraphicsBeginImageContext(CGSizeMake(imageSize.width * scale, imageSize.height * scale));
        [originalImage drawInRect:CGRectMake(0, 0, imageSize.width * scale, imageSize.height * scale)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

- (id<ISSCAttachment>)shareAttachmentWithImage:(UIImage *)image orUrl:(NSString *)urlStr
{
    id<ISSCAttachment> imageAttachment = nil;
    if (image == nil) {
        imageAttachment = [ShareSDK imageWithUrl:urlStr];
    }else {
        imageAttachment = [ShareSDK pngImageWithImage:image];
    }
    return imageAttachment;
}

- (id<ISSContent>)shareContentWithFeedID:(NSString *)feedID
                                UserName:(NSString *)uname
                          andPictureName:(NSString *)pname
                             andFirstPic:(id<ISSCAttachment>)shareAttachment
                              andContent:(NSString *)content
{
    if ([pname isEqual:[NSNull null]]) {
        pname = @"";
    }
    
    NSString *urlStr = @"";
    
    NSString *contentStr = [NSString stringWithFormat:@"分享 %@ 的作品《%@》%@（我在@半半APP 等你，下载请戳→ http://www.imacg.cn）", uname, pname, content];
    id<ISSContent> shareContent = [ShareSDK content:contentStr
                                     defaultContent:@"（￣ε￣＠）半半"
                                              image:shareAttachment
                                              title:contentStr
                                                url:urlStr
                                        description:nil
                                          mediaType:SSPublishContentMediaTypeNews];
    return shareContent;
}

- (id<ISSAuthOptions>)shareAuthOption
{
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    return authOptions;
}


//- (void)socialShareAllWithContent:(NSString *)content
//                            image:(NSString *)image
//                         delegate:(id)delegate
//{
////    NSString *imagePath = [[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
//
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:content
//                                       defaultContent:@""
//                                                image:nil
//                                                title:@"ShareSDK"
//                                                  url:@"http://www.mob.com"
//                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
//                                            mediaType:SSPublishContentMediaTypeNews];
//
//    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
//
//    //定制微信好友信息
//    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
//                                         content:INHERIT_VALUE
//                                           title:NSLocalizedString(@"TEXT_HELLO_WECHAT_SESSION", @"Hello 微信好友!")
//                                             url:INHERIT_VALUE
//                                      thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
//                                           image:INHERIT_VALUE
//                                    musicFileUrl:nil
//                                         extInfo:nil
//                                        fileData:nil
//                                    emoticonData:nil];
//
//    //定制微信朋友圈信息
//    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
//                                          content:INHERIT_VALUE
//                                            title:NSLocalizedString(@"TEXT_HELLO_WECHAT_TIMELINE", @"Hello 微信朋友圈!")
//                                              url:@"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4BDA0E4B88DE698AFE79C9FE6ADA3E79A84E5BFABE4B990222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696332342E74632E71712E636F6D2F586B303051563558484A645574315070536F4B7458796931667443755A68646C2F316F5A4465637734356375386355672B474B304964794E6A3770633447524A574C48795333383D2F3634363232332E6D34613F7569643D32333230303738313038266469723D423226663D312663743D3026636869643D222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31382E71716D757369632E71712E636F6D2F33303634363232332E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E5889BE980A0EFBC9AE5B08FE5B7A8E89B8B444E414C495645EFBC81E6BC94E594B1E4BC9AE5889BE7BAAAE5BD95E99FB3222C22736F6E675F4944223A3634363232332C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E4BA94E69C88E5A4A9222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D31354C5569396961495674593739786D436534456B5275696879366A702F674B65356E4D6E684178494C73484D6C6A307849634A454B394568572F4E3978464B316368316F37636848323568413D3D2F33303634363232332E6D70333F7569643D32333230303738313038266469723D423226663D302663743D3026636869643D2673747265616D5F706F733D38227D"
//                                       thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
//                                            image:INHERIT_VALUE
//                                     musicFileUrl:@"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3"
//                                          extInfo:nil
//                                         fileData:nil
//                                     emoticonData:nil];
//
//    //定制微信收藏信息
//    [publishContent addWeixinFavUnitWithType:INHERIT_VALUE
//                                     content:INHERIT_VALUE
//                                       title:NSLocalizedString(@"TEXT_HELLO_WECHAT_FAV", @"Hello 微信收藏!")
//                                         url:INHERIT_VALUE
//                                  thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
//                                       image:INHERIT_VALUE
//                                musicFileUrl:nil
//                                     extInfo:nil
//                                    fileData:nil
//                                emoticonData:nil];
//
//    //定制QQ分享信息
//    [publishContent addQQUnitWithType:INHERIT_VALUE
//                              content:INHERIT_VALUE
//                                title:@"Hello QQ!"
//                                  url:INHERIT_VALUE
//                                image:INHERIT_VALUE];
//
//
//
//    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
//    {
//        //7.0以上只允许发文字，定义Line信息
//        [publishContent addLineUnitWithContent:INHERIT_VALUE
//                                         image:nil];
//    }
//
//    //结束定制信息
//
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//
//
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:NO
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:nil];
//
//    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
//
//    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
//                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                               qqButtonHidden:NO
//                                                        wxSessionButtonHidden:NO
//                                                       wxTimelineButtonHidden:NO
//                                                         showKeyboardOnAppear:NO
//                                                            shareViewDelegate:nil
//                                                          friendsViewDelegate:nil
//                                                        picViewerViewDelegate:nil];
//
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:authOptions
//                      shareOptions:shareOptions
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                }
//                            }];
//
//}



@end
