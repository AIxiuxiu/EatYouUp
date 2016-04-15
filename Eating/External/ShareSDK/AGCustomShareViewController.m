//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.mob.com
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//
#import "AGCustomShareViewController.h"
//#import "AGCustomAtPlatListViewController.h"
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIColor+Common.h>
#import <AGCommon/NSString+Common.h>
#import "AppDelegate.h"
#import "UIView+Common.h"
#import "SocaialManager.h"
#import "ShareSDK/ShareSDK.h"
#import "WXApi.h"
//#import <TencentOpenAPI/TencentApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
#import "CFAccountManager.h"
#import "UIAlertView+Blocks.h"
#import <CoreImage/CoreImage.h>
#import "MBProgressHUD.h"

#define IMAGE_WIDTH 80.0
#define IMAGE_HEIGHT 80.0
#define IMAGE_LANDSCAPE_WIDTH 50.0
#define IMAGE_LANDSCAPE_HEIGHT 50.0

#define TOOLBAR_HEIGHT 40

#define PADDING_LEFT 1.0
#define PADDING_TOP 1.0
#define PADDING_RIGHT 1.0
#define PADDING_BOTTOM 2.0
#define HORIZONTAL_GAP 2.0
#define VERTICAL_GAP 5.0

#define IMAGE_PADDING_TOP 19
#define IMAGE_PADDING_RIGHT 10

#define PIN_PADDING_TOP 4

#define AT_BUTTON_PADDING_LEFT 9
#define AT_BUTTON_PADDING_BOTTOM 6
#define AT_BUTTON_WIDTH 34
#define AT_BUTTON_HEIGHT 29
#define AT_BUTTON_HORIZONTAL_GAP 9.0

#define WORD_COUNT_LABEL_PADDING_RIGHT 10
#define WORD_COUNT_LABEL_PADDING_BOTTOM 19

@implementation AGCustomShareViewController

- (id)initWithImage:(UIImage *)image
            content:(NSString *)content
{
    self = [self init];
    if (self)
    {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _image = [image retain];
        _content = [content copy];
    }
    return self;
}

- (id)initWithContent:(NSString *)content
             UserName:(NSString *)uname
             WorkName:(NSString *)pname
               Images:(UIImage *)images
            ImagesUrl:(NSURL *)url

{
    self = [super init];
    if (self) {
        UIButton *leftBtn = [[[UIButton alloc] init] autorelease];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"NavigationButtonBG.png"]
                           forState:UIControlStateNormal];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        leftBtn.frame = CGRectMake(0.0, 0.0, 53.0, 30.0);
        [leftBtn addTarget:self action:@selector(cancelButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftBtn] autorelease];
        
        UIButton *rightBtn = [[[UIButton alloc] init] autorelease];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"NavigationButtonBG.png"]
                            forState:UIControlStateNormal];
        [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        rightBtn.frame = CGRectMake(0.0, 0.0, 53.0, 30.0);
        [rightBtn addTarget:self action:@selector(publishButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightBtn] autorelease];
        
        if ([UIDevice currentDevice].isPad)
        {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.shadowColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:22];
            self.navigationItem.titleView = label;
            [label release];
        }
        
        self.title =  @"内容分享";
        
        _content = [content copy];
        _uname = [uname copy];
        _pname = [pname copy];
        _image = [images retain];
        _urlll = [url copy];

    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        UIButton *leftBtn = [[[UIButton alloc] init] autorelease];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"NavigationButtonBG.png"]
                           forState:UIControlStateNormal];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        leftBtn.frame = CGRectMake(0.0, 0.0, 53.0, 30.0);
        [leftBtn addTarget:self action:@selector(cancelButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftBtn] autorelease];
        
        UIButton *rightBtn = [[[UIButton alloc] init] autorelease];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"NavigationButtonBG.png"]
                           forState:UIControlStateNormal];
        [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        rightBtn.frame = CGRectMake(0.0, 0.0, 53.0, 30.0);
        [rightBtn addTarget:self action:@selector(publishButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];

        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightBtn] autorelease];
        
        if ([UIDevice currentDevice].isPad)
        {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.shadowColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:22];
            self.navigationItem.titleView = label;
            [label release];
        }
        
        self.title =  @"内容分享";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc
{
    _picImageView = nil;
    _textView = nil;
//    _toolbar = nil;
    
//    SAFE_RELEASE(_image);
//    SAFE_RELEASE(_content);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    ((UILabel *)self.navigationItem.titleView).text = title;
    [self.navigationItem.titleView sizeToFit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:SSRectEdgeBottom | SSRectEdgeLeft | SSRectEdgeRight];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowHandler:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _contentBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SharePanelBG.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:11]];
    _contentBG.frame = CGRectMake(PADDING_LEFT, PADDING_TOP, self.view.width - PADDING_LEFT - PADDING_RIGHT, self.view.height - TOOLBAR_HEIGHT - VERTICAL_GAP - PADDING_BOTTOM);
    _contentBG.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_contentBG];
    [_contentBG release];
    
    _toolbarBG = [[UIImageView alloc] initWithImage:nil];
    _toolbarBG.frame = CGRectMake(PADDING_LEFT + 1, _contentBG.bottom + VERTICAL_GAP, self.view.width - PADDING_LEFT - PADDING_RIGHT - 2, TOOLBAR_HEIGHT);
    _toolbarBG.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_toolbarBG];
    [_toolbarBG release];
	
        //图片
    _picBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShareImageBG.png"]];
    _picBG.frame = CGRectMake(self.view.width - IMAGE_PADDING_RIGHT - _picBG.width, IMAGE_PADDING_TOP, _picBG.width, _picBG.height);
    _picBG.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:_picBG];
    [_picBG release];
    
    _picImageView = [[CMImageView alloc] initWithFrame:CGRectMake(_picBG.left + 3, _picBG.top + 3, _picBG.width - 6, _picBG.height - 6)];
    _picImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _picImageView.image = _image;
    [self.view addSubview:_picImageView];
    [_picImageView release];
    
    _pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SharePin.png"]];
    _pinImageView.frame = CGRectMake(self.view.width - _pinImageView.width, PIN_PADDING_TOP, _pinImageView.width, _pinImageView.height);
    _pinImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:_pinImageView];
    [_pinImageView release];
    
        //文本框
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(PADDING_LEFT,
                                                             PADDING_TOP + 1,
                                                             _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1 +_toolbarBG.height)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:18.0];

    if (_content.length>50) {
        _content = [_content substringToIndex:50];
        _content = [_content stringByAppendingString:@"..."];
    }
    NSString *contentStr = [NSString stringWithFormat:@"分享 %@ 的作品《%@》%@", _uname, _pname, _content];
    _textView.text = contentStr;
    
    _textView.delegate = self;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_textView];
    [_textView release];
    
    if (!_image)
    {
        _picBG.hidden = YES;
        _picImageView.hidden = YES;
        _pinImageView.hidden = YES;
        _textView.frame = CGRectMake(PADDING_LEFT,
                                     PADDING_TOP + 1,
                                     _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                     _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
    }
    
        //工具栏
//        _toolbar = [[AGCustomShareViewToolbar alloc] initWithFrame:CGRectMake(_toolbarBG.left + 2, _toolbarBG.top, _toolbarBG.width - 4, _toolbarBG.height)];
//    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    [self.view addSubview:_toolbar];
//    [_toolbar release];
//
//    _atButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [_atButton setBackgroundImage:[UIImage imageNamed:@"atButton.png"] forState:UIControlStateNormal];
//    _atButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
//    [_atButton addTarget:self action:@selector(addbuttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_atButton];
//    
//    _atTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    _atTipsLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    _atTipsLabel.backgroundColor = [UIColor clearColor];
//    _atTipsLabel.textColor = [UIColor colorWithRGB:0xd2d2d2];
//    _atTipsLabel.text = NSLocalizedString(@"TEXT_REMINE_VIEW", @"提醒微博好友查看");
//    _atTipsLabel.font = [UIFont boldSystemFontOfSize:12];
//    [_atTipsLabel sizeToFit];
//    _atTipsLabel.frame = CGRectMake(_atButton.right + AT_BUTTON_HORIZONTAL_GAP,
//                                    _atButton.top + (_atButton.height - _atTipsLabel.height) / 2,
//                                    _atTipsLabel.width,
//                                    _atTipsLabel.height);
//    [self.view addSubview:_atTipsLabel];
//    [_atTipsLabel release];
//    
//        //字数
//        _wordCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    _wordCountLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    _wordCountLabel.backgroundColor = [UIColor clearColor];
//    _wordCountLabel.textColor = [UIColor colorWithRGB:0xd2d2d2];
//    _wordCountLabel.text = @"140";
//    _wordCountLabel.font = [UIFont boldSystemFontOfSize:16];
//    [_wordCountLabel sizeToFit];
//    _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
//                                       _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
//                                       _wordCountLabel.width,
//                                       _wordCountLabel.height);
//    [self.view addSubview:_wordCountLabel];
//    [_wordCountLabel release];
    
    [self updateWordCount];
    [_textView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self layoutView:self.interfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
        //iOS6下旋屏方法
        return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
        //iOS6下旋屏方法
        return SSInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutView:toInterfaceOrientation];
}

- (void)layoutPortrait
{
    UIButton *btn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    btn.frame = CGRectMake(btn.left, btn.top, 55.0, 32.0);
    [btn setBackgroundImage:[UIImage imageNamed:@"NavigationButtonBG.png"]
                   forState:UIControlStateNormal];
    
    if (![UIDevice currentDevice].isPad)
    {
        _toolbarBG.hidden = NO;
        _atTipsLabel.hidden = NO;
        _wordCountLabel.hidden = NO;
        
        _contentBG.frame = CGRectMake(PADDING_LEFT,
                                      PADDING_TOP,
                                      self.view.width - PADDING_LEFT - PADDING_RIGHT,
                                      self.view.height - TOOLBAR_HEIGHT - VERTICAL_GAP - PADDING_BOTTOM - _keyboardHeight);
        _toolbarBG.frame = CGRectMake(PADDING_LEFT + 1,
                                      _contentBG.bottom + VERTICAL_GAP,
                                      self.view.width - PADDING_LEFT - PADDING_RIGHT - 2,
                                      TOOLBAR_HEIGHT);
        
        _textView.frame = CGRectMake(PADDING_LEFT,
                                     PADDING_TOP + 1,
                                     _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                     _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1 + _toolbarBG.height);
        
//        _toolbar.frame = CGRectMake(_toolbarBG.left + 2, _toolbarBG.top, _toolbarBG.width - 4, _toolbarBG.height);
        
        _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
        _atTipsLabel.frame = CGRectMake(_atButton.right + AT_BUTTON_HORIZONTAL_GAP,
                                        _atButton.top + (_atButton.height - _atTipsLabel.height) / 2,
                                        _atTipsLabel.width,
                                        _atTipsLabel.height);
        _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
                                           _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
                                           _wordCountLabel.width,
                                           _wordCountLabel.height);
    }
}

- (void)layoutLandscape
{
    if (![UIDevice currentDevice].isPad)
    {
        //iPhone
        UIButton *btn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        btn.frame = CGRectMake(btn.left, btn.top, 48.0, 24.0);
        [btn setBackgroundImage:[UIImage imageNamed:@"NavigationButtonBG_Landscape.png"]
                       forState:UIControlStateNormal];
        
        if (_keyboardHeight > 0)
        {
            _toolbarBG.hidden = YES;
            _atTipsLabel.hidden = YES;
            _wordCountLabel.hidden = YES;
            
            _contentBG.frame = CGRectMake(PADDING_LEFT,
                                          PADDING_TOP,
                                          self.view.width - PADDING_LEFT - PADDING_RIGHT,
                                          self.view.height - PADDING_BOTTOM - _keyboardHeight);
            
            if (_image)
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1 + _toolbarBG.height);
            }
            else
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1 + _toolbarBG.height);
            }
            
            _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
//            _toolbar.frame = CGRectMake(_atButton.right + HORIZONTAL_GAP, _contentBG.bottom - TOOLBAR_HEIGHT,_picBG.left - _atButton.right - 2 *HORIZONTAL_GAP, TOOLBAR_HEIGHT);
        }
        else
        {
            _toolbarBG.hidden = NO;
            _atTipsLabel.hidden = NO;
            _wordCountLabel.hidden = NO;
            
            _contentBG.frame = CGRectMake(PADDING_LEFT,
                                          PADDING_TOP,
                                          self.view.width - PADDING_LEFT - PADDING_RIGHT,
                                          self.view.height - TOOLBAR_HEIGHT - VERTICAL_GAP - PADDING_BOTTOM - _keyboardHeight);
            _toolbarBG.frame = CGRectMake(PADDING_LEFT + 1,
                                          _contentBG.bottom + VERTICAL_GAP,
                                          self.view.width - PADDING_LEFT - PADDING_RIGHT - 2,
                                          TOOLBAR_HEIGHT);
            
            if (_image)
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1 + _toolbarBG.height);
            }
            else
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1 + _toolbarBG.height);
            }
            
//            _toolbar.frame = CGRectMake(_toolbarBG.left + 2, _toolbarBG.top, _toolbarBG.width - 4, _toolbarBG.height);
            
            _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
            _atTipsLabel.frame = CGRectMake(_atButton.right + AT_BUTTON_HORIZONTAL_GAP,
                                            _atButton.top + (_atButton.height - _atTipsLabel.height) / 2,
                                            _atTipsLabel.width,
                                            _atTipsLabel.height);
            _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
                                               _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
                                               _wordCountLabel.width,
                                               _wordCountLabel.height);
        }
    }
    else
    {
        UIButton *btn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        btn.frame = CGRectMake(btn.left, btn.top, 55.0, 32.0);
        [btn setBackgroundImage:[UIImage imageNamed:@"NavigationButtonBG.png"
                                         bundleName:@""]
                       forState:UIControlStateNormal];
    }
}

- (void)layoutView:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        [self layoutLandscape];
    }
    else
    {
        [self layoutPortrait];
    }
}

#pragma mark - Private

- (void)updateWordCount
{
    NSInteger count = 140 - [_textView.text length];
    _wordCountLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    
    if (count < 0)
    {
        _wordCountLabel.textColor = [UIColor redColor];
    }
    else
    {
        _wordCountLabel.textColor = [UIColor colorWithRGB:0xd2d2d2];
    }
    
    [_wordCountLabel sizeToFit];
    _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
                                       _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
                                       _wordCountLabel.width,
                                       _wordCountLabel.height);
}

//- (void)addbuttonClickHandler:(id)sender
//{
//    AGCustomAtPlatListViewController *vc = [[[AGCustomAtPlatListViewController alloc] initWithChangeHandler:^(NSArray *users, ShareType shareType) {
//        NSMutableString *usersString = [NSMutableString string];
//        for (int i = 0; i < [users count]; i++)
//        {
//            NSDictionary *userInfo = [users objectAtIndex:i];
//            switch (shareType)
//            {
//                case ShareTypeTwitter:
//                {
//                    [usersString appendFormat:@" @%@ ", [userInfo objectForKey:@"screen_name"]];
//                    break;
//                }
//                case ShareTypeTencentWeibo:
//                {
//                    [usersString appendFormat:@" @%@ ", [userInfo objectForKey:@"name"]];
//                    break;
//                }
//                default:
//                {
//                    [usersString appendFormat:@" @%@ ", [userInfo objectForKey:@"screen_name"]];
//                    break;
//                }
//            }
//        }
//        
//        _textView.text = [_textView.text stringByAppendingString:usersString];
//        [self updateWordCount];
//        
//        [_textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
//    } cancelHandler:^{
//        
//        [_textView becomeFirstResponder];
//        
//    }] autorelease];
//    UINavigationController *navVC = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
//    
//    if ([UIDevice currentDevice].isPad)
//    {
//        navVC.modalPresentationStyle = UIModalPresentationFormSheet;
//    }
//    
//    [self presentModalViewController:navVC animated:YES];
//}

- (void)publishButtonClickHandler:(id)sender
{
    [self showShareSheetOnView:nil
                   WithContent:nil
                      UserName:nil
                      WorkName:nil
                        Images:nil
                     ImagesUrl:nil];
    
    [self cancelButtonClickHandler:nil];
}

- (void)cancelButtonClickHandler:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)showShareSheetOnView:(id)sender
                 WithContent:(NSString *)content
                    UserName:(NSString *)uname
                    WorkName:(NSString *)pname
                      Images:(UIImage *)images
                   ImagesUrl:(NSURL *)url

{
//    NSArray *arr = @[_image];
    [_textView resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    
    content = _textView.text;
    if (content.length>100) {
        content = [content substringToIndex:100];
        content = [NSString stringWithFormat:@"%@...", content];
    }
    content = [content stringByAppendingString:@"（我在@半半APP 等你，下载请戳→ http://www.imacg.cn）"];
    
    id<ISSCAttachment> imageAttachment = [self shareAttachmentWithImage:_image
                                                                  orUrl:_urlll.absoluteString];
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"（￣ε￣＠）半半"
                                                image:imageAttachment
                                                title:content
                                                  url:@"http://www.imacg.cn"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [self shareAuthOption];
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                        }
                        else if (state == SSPublishContentStateFail)
                        {
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

- (id<ISSContent>)shareContentWithUserName:(NSString *)uname
                            andPictureName:(NSString *)pname
                               andFirstPic:(id<ISSCAttachment>)shareAttachment
                                andContent:(NSString *)content
{
    if (content.length>50) {
        content = [content substringToIndex:50];
        content = [NSString stringWithFormat:@"%@...", content];
    }
    NSString *contentStr = [NSString stringWithFormat:@"分享 %@ 的作品《%@》%@（我在@半半APP 等你，下载请戳→ http://www.imacg.cn）", uname, pname, content];
    id<ISSContent> shareContent = [ShareSDK content:contentStr
                                     defaultContent:@"（￣ε￣＠）半半"
                                              image:shareAttachment
                                              title:contentStr
                                                url:@"http://www.imacg.cn"
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

- (void)keyboardWillShowHandler:(NSNotification *)notif
{
    CGRect keyboardFrame;
    NSValue *value =[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    [value getValue:&keyboardFrame];
    
    CGFloat fixedHeight = 0;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        _keyboardHeight = keyboardFrame.size.width;
        
        fixedHeight = (self.view.height + self.navigationController.navigationBar.height) - ([UIScreen mainScreen].bounds.size.width - _keyboardHeight - 20);
    }
    else
    {
        _keyboardHeight = keyboardFrame.size.height;
        
        fixedHeight = _keyboardHeight - ([UIScreen mainScreen].bounds.size.height - self.view.height - self.navigationController.navigationBar.height - 20) / 2;
    }
    
    [UIView beginAnimations:@"change" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.15];
    
    if ([UIDevice currentDevice].isPad)
    {
        _toolbarBG.hidden = NO;
        _atTipsLabel.hidden = NO;
        _wordCountLabel.hidden = NO;
        _keyboardHeight = keyboardFrame.size.height;
        
        _contentBG.frame = CGRectMake(PADDING_LEFT,
                                      PADDING_TOP,
                                      self.view.width - PADDING_LEFT - PADDING_RIGHT,
                                      self.view.height - TOOLBAR_HEIGHT - VERTICAL_GAP - PADDING_BOTTOM - fixedHeight);
        _toolbarBG.frame = CGRectMake(PADDING_LEFT + 1,
                                      _contentBG.bottom + VERTICAL_GAP,
                                      self.view.width - PADDING_LEFT - PADDING_RIGHT - 2,
                                      TOOLBAR_HEIGHT);
        
        if (_image)
        {
            _textView.frame = CGRectMake(PADDING_LEFT,
                                         PADDING_TOP + 1,
                                         _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                         _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
        }
        else
        {
            _textView.frame = CGRectMake(PADDING_LEFT,
                                         PADDING_TOP + 1,
                                         _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                         _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
        }
        
        
//        _toolbar.frame = CGRectMake(_toolbarBG.left + 2, _toolbarBG.top, _toolbarBG.width - 4, _toolbarBG.height);
        
        _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
        _atTipsLabel.frame = CGRectMake(_atButton.right + AT_BUTTON_HORIZONTAL_GAP,
                                        _atButton.top + (_atButton.height - _atTipsLabel.height) / 2,
                                        _atTipsLabel.width,
                                        _atTipsLabel.height);
        _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
                                           _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
                                           _wordCountLabel.width,
                                           _wordCountLabel.height);
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            _toolbarBG.hidden = YES;
            _atTipsLabel.hidden = YES;
            _wordCountLabel.hidden = YES;
            _keyboardHeight = keyboardFrame.size.width;
            
            _contentBG.frame = CGRectMake(PADDING_LEFT,
                                          PADDING_TOP,
                                          self.view.width - PADDING_LEFT - PADDING_RIGHT,
                                          self.view.height - PADDING_BOTTOM - _keyboardHeight);
            
            if (_image)
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
            }
            else
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
            }
            
            _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
//            _toolbar.frame = CGRectMake(_atButton.right + HORIZONTAL_GAP, _contentBG.bottom - TOOLBAR_HEIGHT,_picBG.left - _atButton.right - 2 *HORIZONTAL_GAP, TOOLBAR_HEIGHT);
        }
        else
        {
            _toolbarBG.hidden = NO;
            _atTipsLabel.hidden = NO;
            _wordCountLabel.hidden = NO;
            _keyboardHeight = keyboardFrame.size.height;
            
            _contentBG.frame = CGRectMake(PADDING_LEFT,
                                          PADDING_TOP,
                                          self.view.width - PADDING_LEFT - PADDING_RIGHT,
                                          self.view.height - TOOLBAR_HEIGHT - VERTICAL_GAP - PADDING_BOTTOM - _keyboardHeight);
            _toolbarBG.frame = CGRectMake(PADDING_LEFT + 1,
                                          _contentBG.bottom + VERTICAL_GAP,
                                          self.view.width - PADDING_LEFT - PADDING_RIGHT - 2,
                                          TOOLBAR_HEIGHT);
            
            if (_image)
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
            }
            else
            {
                _textView.frame = CGRectMake(PADDING_LEFT,
                                             PADDING_TOP + 1,
                                             _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                             _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
            }
            
//            _toolbar.frame = CGRectMake(_toolbarBG.left + 2, _toolbarBG.top, _toolbarBG.width - 4, _toolbarBG.height);

            _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
            _atTipsLabel.frame = CGRectMake(_atButton.right + AT_BUTTON_HORIZONTAL_GAP,
                                            _atButton.top + (_atButton.height - _atTipsLabel.height) / 2,
                                            _atTipsLabel.width,
                                            _atTipsLabel.height);
            _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
                                               _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
                                               _wordCountLabel.width,
                                               _wordCountLabel.height);
        }
    }
    [UIView commitAnimations];
}

- (void)keyboardWillHideHandler:(NSNotification *)notif
{
    _keyboardHeight = 0;
    
    [UIView beginAnimations:@"change" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.15];
    
    _toolbarBG.hidden = NO;
    _atTipsLabel.hidden = NO;
    
    _contentBG.frame = CGRectMake(PADDING_LEFT,
                                  PADDING_TOP,
                                  self.view.width - PADDING_LEFT - PADDING_RIGHT,
                                  self.view.height - TOOLBAR_HEIGHT - VERTICAL_GAP - PADDING_BOTTOM - _keyboardHeight);
    _toolbarBG.frame = CGRectMake(PADDING_LEFT + 1,
                                  _contentBG.bottom + VERTICAL_GAP,
                                  self.view.width - PADDING_LEFT - PADDING_RIGHT - 2,
                                  TOOLBAR_HEIGHT);
    
    if (_image)
    {
        _textView.frame = CGRectMake(PADDING_LEFT,
                                     PADDING_TOP + 1,
                                     _picBG.left - HORIZONTAL_GAP - PADDING_LEFT,
                                     _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
    }
    else
    {
        _textView.frame = CGRectMake(PADDING_LEFT,
                                     PADDING_TOP + 1,
                                     _contentBG.right - PADDING_RIGHT - PADDING_LEFT,
                                     _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT - VERTICAL_GAP - 1);
    }
    
//    _toolbar.frame = CGRectMake(_toolbarBG.left + 2, _toolbarBG.top, _toolbarBG.width - 4, _toolbarBG.height);
    
    _atButton.frame = CGRectMake(_contentBG.left + AT_BUTTON_PADDING_LEFT, _contentBG.bottom - AT_BUTTON_PADDING_BOTTOM - AT_BUTTON_HEIGHT, AT_BUTTON_WIDTH, AT_BUTTON_HEIGHT);
    _atTipsLabel.frame = CGRectMake(_atButton.right + AT_BUTTON_HORIZONTAL_GAP,
                                    _atButton.top + (_atButton.height - _atTipsLabel.height) / 2,
                                    _atTipsLabel.width,
                                    _atTipsLabel.height);
    _wordCountLabel.frame = CGRectMake(_contentBG.right - WORD_COUNT_LABEL_PADDING_RIGHT - _wordCountLabel.width,
                                       _contentBG.bottom - WORD_COUNT_LABEL_PADDING_BOTTOM - _wordCountLabel.height,
                                       _wordCountLabel.width,
                                       _wordCountLabel.height);
    
    [UIView commitAnimations];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateWordCount];
}

@end
