//
//  QSArticleFoodDetectiveViewController.m
//  Eating
//
//  Created by ysmeng on 14/11/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSArticleFoodDetectiveViewController.h"
#import "QSImageView.h"
#import "UIView+UI.h"
#import "QSBlockActionButton.h"
#import "QSAPIClientBase+DetectiveArticle.h"

#import <objc/runtime.h>

//关联
static char ArticleAuthorIconKey;
static char ArticleAuthorNameKey;
static char ArticleReleaseTimeKey;
static char ArticleReadCountKey;
static char ArticleCollectCountKey;
static char CurrentUserInterestedStatuKey;
static char ArticleCommentKey;
@interface QSArticleFoodDetectiveViewController ()

@end

@implementation QSArticleFoodDetectiveViewController

//***************************
//             UI搭建
//***************************
#pragma mark - UI搭建
- (void)createNavigationBar
{
    [super createNavigationBar];
}

//创建主体UI
- (void)createMiddleMainShowView
{
    //取消scrollview自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //底部滚动scrollview
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 110.0f, DeviceWidth, DeviceHeight-120.0f)];
    [self.view addSubview:scrollView];
    
    //白色背景
    scrollView.backgroundColor = [UIColor whiteColor];
    
    //隐藏滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    //取消弹性
    scrollView.bounces = NO;
    
    //添加主控件
    [self createInfoSubView:scrollView];
}

//创建信息显示控件
- (void)createInfoSubView:(UIScrollView *)scrollView
{
    //作者头像
    QSImageView *userIcon = [[QSImageView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 33.0f, 33.0f)];
    //切圆
    [userIcon roundView];
    [scrollView addSubview:userIcon];
    objc_setAssociatedObject(self, &ArticleAuthorIconKey, userIcon, OBJC_ASSOCIATION_ASSIGN);
    
    //作者名姓
    UILabel *authorName = [[UILabel alloc] initWithFrame:CGRectMake(53.0f, 0.0f, 120.0f, 15.0f)];
    authorName.font = [UIFont boldSystemFontOfSize:12.0f];
    authorName.textColor = kBaseGrayColor;
    [scrollView addSubview:authorName];
//    authorName.text = @"没有尾巴的猪";
    objc_setAssociatedObject(self, &ArticleAuthorNameKey, authorName, OBJC_ASSOCIATION_ASSIGN);
    
    //发布时间
    UILabel *releaseTime = [[UILabel alloc] initWithFrame:CGRectMake(53.0f, 18.0f, 67.0f, 15.0f)];
    releaseTime.font = [UIFont systemFontOfSize:12.0f];
    releaseTime.textColor = kBaseGrayColor;
    [scrollView addSubview:releaseTime];
//    releaseTime.text = @"2014-12-01";
    objc_setAssociatedObject(self, &ArticleReleaseTimeKey, releaseTime, OBJC_ASSOCIATION_ASSIGN);
    
    //已读图标
    QSImageView *readCountImg = [[QSImageView alloc] initWithFrame:CGRectMake(140.0f,18.0f,20.0f,12.0f)];
    readCountImg.image = [UIImage imageNamed:@"fooddetective_read_img"];
    [scrollView addSubview:readCountImg];
    
    //已读次数
    UILabel *readCount = [[UILabel alloc] initWithFrame:CGRectMake(165.0f,18.0f,40.0f,15.0f)];
    [scrollView addSubview:readCount];
    objc_setAssociatedObject(self, &ArticleReadCountKey, readCount, OBJC_ASSOCIATION_ASSIGN);
//    readCount.text = @"2093";
    readCount.font = [UIFont systemFontOfSize:12.0f];
    readCount.textColor = kBaseGrayColor;
    
    //收藏图标
    QSImageView *collectCountImg = [[QSImageView alloc] initWithFrame:CGRectMake(215.0f,18.0f,15.0f,15.0f)];
    collectCountImg.image = [UIImage imageNamed:@"fooddetective_collect_img"];
    [scrollView addSubview:collectCountImg];
    
    //收藏次数
    UILabel *collectCount = [[UILabel alloc] initWithFrame:CGRectMake(235.0f,18.0f,40.0f,15.0f)];
    [scrollView addSubview:collectCount];
    objc_setAssociatedObject(self, &ArticleCollectCountKey, collectCount, OBJC_ASSOCIATION_ASSIGN);
//    collectCount.text = @"2093";
    collectCount.font = [UIFont systemFontOfSize:12.0f];
    collectCount.textColor = kBaseGrayColor;
    
    //喜欢按钮
    UIButton *interestedButton = [UIButton createBlockActionButton:CGRectMake(scrollView.frame.size.width-38.0f, 2.5f, 28.0f, 28.0f) andStyle:[QSButtonStyleModel createMarDetectiveArticleInterestedButtonStyle] andCallBack:^(UIButton *button) {
        //如果当前用户对此文章已标记有兴趣，则不执行任何操作
        if (button.selected) {
            return;
        }
        
        //当前用户标记对此文章有兴趣
    }];
    interestedButton.selected = NO;
    [scrollView addSubview:interestedButton];
    objc_setAssociatedObject(self, &CurrentUserInterestedStatuKey, interestedButton, OBJC_ASSOCIATION_ASSIGN);
    
    //comment web view
    UIWebView *comment = [[UIWebView alloc] initWithFrame:CGRectMake(10.0f, 43.0f, scrollView.frame.size.width - 20.0f, scrollView.frame.size.height-43.0f)];
    comment.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:comment];
    //关联
    objc_setAssociatedObject(self, &ArticleCommentKey, comment, OBJC_ASSOCIATION_ASSIGN);
    //去除滚动条
    for (UIView *obj in [comment subviews]) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)obj).showsHorizontalScrollIndicator = NO;
            ((UIScrollView *)obj).showsVerticalScrollIndicator = NO;
            ((UIScrollView *)obj).bounces = NO;
            ((UIScrollView *)obj).contentSize = CGSizeMake(((UIScrollView *)obj).frame.size.width, ((UIScrollView *)obj).frame.size.height);
        }
    }
}

//设置中间标题
- (void)setMiddleTitle:(NSString *)title
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super setMiddleTitle:title];
    });
}

//*******************************
//             保存文章ID/请求数据
//*******************************
#pragma mark - 保存文章ID/请求数据
- (void)loadArticleWithID:(NSString *)articleID
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //请求数据
        [[QSAPIClientBase sharedClient] detectiveArticleDataWithID:articleID andSuccessCallBack:^(QSDetectiveArticleDataModel *resultModel) {
            [self updateDetectiveArticleUI:resultModel];
        } andFailCallBack:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"探店文章下载失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"%s  %s  %d error:%@",__FILE__,__FUNCTION__,__LINE__,error);
        }];
    });
}

//*******************************
//             刷新UI
//*******************************
#pragma mark - 刷新UI
- (void)updateDetectiveArticleUI:(QSDetectiveArticleDataModel *)resultModel
{
    //更新用户名
    [self updateAuthorName:resultModel.authorName];
    
    //更新发布时间
    [self updateReleaseTime:
     [self formatDateWithWString:
      [self modifyReleaseDateAndModifyDate:resultModel.releaseTime
                             andModifyTime:resultModel.modifyTime]]];
    
    //更新阅读次数
    [self updateReadCount:resultModel.readCount];
    
    //更新兴趣数
    [self updateCollectCount:resultModel.interestedCount];
    
    //更新当前用户是否对此文章有兴趣状态
    [self updateCurrentUserInterestedStatu:resultModel.currentUserInterestedStatu];
    
    //更新头像
    [self updateAuthorIcon:resultModel.authorIconModel];
    
    //更新文章
    [self updateComment:resultModel.comment];
}

//更新用户名
- (void)updateAuthorName:(NSString *)authorName
{
    if (authorName) {
        UILabel *name = objc_getAssociatedObject(self, &ArticleAuthorNameKey);
        name.text = authorName;
    }
}

//更新发布时间
- (void)updateReleaseTime:(NSString *)releaseTime
{
    if (releaseTime) {
        UILabel *timeLabel = objc_getAssociatedObject(self, &ArticleReleaseTimeKey);
        timeLabel.text = releaseTime;
    }
}

//将整数转换为日期
- (NSString *)formatDateWithWString:(NSString *)timeString
{
    if (nil == timeString) {
        return nil;
    }
    
    //转换为有效日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timeString intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

//通过对比发布日期和更新日期，返回最新日期
- (NSString *)modifyReleaseDateAndModifyDate:(NSString *)releaseString andModifyTime:(NSString *)modifyString
{
    if ((nil == releaseString) && (nil == modifyString)) {
        return nil;
    }
    
    if ([modifyString length] > 5) {
        return modifyString;
    }
    return releaseString;
}

//更新阅读次数
- (void)updateReadCount:(NSString *)readCount
{
    if (readCount) {
        UILabel *countLabel = objc_getAssociatedObject(self, &ArticleReadCountKey);
        countLabel.text = readCount;
    }
}

//更新兴趣次数
- (void)updateCollectCount:(NSString *)readCount
{
    if (readCount) {
        UILabel *countLabel = objc_getAssociatedObject(self, &ArticleCollectCountKey);
        countLabel.text = readCount;
    }
}

//更新当前用户是否感兴趣当前文章
- (void)updateCurrentUserInterestedStatu:(BOOL)statuInt
{
    if (statuInt) {
        UIButton *button = objc_getAssociatedObject(self, &CurrentUserInterestedStatuKey);
        button.selected = YES;
    }
}

//更新文章内容
- (void)updateComment:(NSString *)comment
{
    if (comment) {
        UIWebView *webView = objc_getAssociatedObject(self, &ArticleCommentKey);
        [webView loadHTMLString:comment baseURL:nil];
    }
}

//更新作者头像
- (void)updateAuthorIcon:(NSDictionary *)imageName
{
    if (imageName) {
        UIImageView *iconView = objc_getAssociatedObject(self, &ArticleAuthorIconKey);
        iconView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"default_file_super_url"],[imageName valueForKey:@"image_link"]]]]];
    }
}

@end
