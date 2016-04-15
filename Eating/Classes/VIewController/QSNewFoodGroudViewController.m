//
//  QSNewFoodGroudViewController.m
//  Eating
//
//  Created by ysmeng on 14/12/19.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSNewFoodGroudViewController.h"
#import "QSNewFoodGroudModel.h"
#import "QSBlockActionButton.h"
#import "QSNewFoodGroudModel.h"
#import "QSYFoodGroudLimitedView.h"
#import "QSResetImageFrameButton.h"
#import "QSFoodGroudPayStyleView.h"
#import "QSMerchantSelectedViewController.h"
#import "QSImageView.h"
#import "QSDatePickerViewController.h"
#import "ASDepthModalViewController.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"
#import "QSAPIClientBase+AddFoodGroud.h"
#import "QSYCustomHUD.h"

#import <objc/runtime.h>

///关联
static char ChoicedTagKey;  //!<已选择的兴趣标签底view
static char UnChoicedTagKey;//!<未选择的兴趣标签底view
static char GroudCommentKey;//!<搭食团的说明信息

@interface QSNewFoodGroudViewController ()<UITextFieldDelegate>{
    
    BOOL _isEdit;                               //!<是否可以编辑标记，默认是可以编辑
    
    QSDatePickerViewController *_pickerView;    //!<时间数量选择器
    
    NSMutableArray *_choicedTagList;            //!<已选择的兴趣标签
    NSMutableArray *_unChoicedTagList;          //!<待选择的兴趣标签

}

@property (nonatomic,retain) QSNewFoodGroudModel *inputInfoModel;

@end

@implementation QSNewFoodGroudViewController

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        ///初始化输入信息暂存模型
        _inputInfoModel = [[QSNewFoodGroudModel alloc] init];
        _inputInfoModel.payStyle = @"0";
        _inputInfoModel.addLimited = @"0";
        _inputInfoModel.canTakeFamilies = @"1";
        _inputInfoModel.membersSumCount = @"1";
        
        ///是否可以编辑
        _isEdit = YES;
        
        ///初始化兴趣标签数据
        _choicedTagList = [[NSMutableArray alloc] init];
        _unChoicedTagList = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

/**
 *  @author         yangshengmeng, 14-12-21 18:12:29
 *
 *  @brief          创建一个静态的搭食团详情页面
 *
 *  @param model    详情的数据模型
 *
 *  @return         返回当前创建的详情页
 *
 *  @since          2.0
 */
- (instancetype)initStaticDetailWithModel:(QSNewFoodGroudModel *)model
{

    if (self = [super init]) {
        
        //保存模型
        self.inputInfoModel = model;
        
        _isEdit = NO;
        
        ///初始化兴趣标签数据
        _choicedTagList = [[NSMutableArray alloc] init];
        _unChoicedTagList = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///创建UI
- (void)createNavigationBar
{

    [super createNavigationBar];
    [self setNavigationBarMiddleTitle:@"发起搭食团"];
    
    ///保存按钮
    UIButton *saveButton = [UIButton createBlockActionButton:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///判断是否是查看页面
        if (!_isEdit) {
            return;
        }
        
        ///检测是否已登录
        if (![self checkIsLogin]) {
            
            return;
        }
        
        ///点击保存
        _inputInfoModel.tagList = [self getTagParamsArray];
        
        ///保存说明信息
        UILabel *commentLabel = objc_getAssociatedObject(self, &GroudCommentKey);
        _inputInfoModel.activityComment = commentLabel.text;
        
        ///向服务器添加搭食团
        [self addFoodGroudWithParams:[_inputInfoModel packageNewFoodGroudParams]];
        
        
    }];
    [saveButton setImage:[UIImage imageNamed:@"newfoodgroud_save_normal"] forState:UIControlStateNormal];
    [saveButton setImage:[UIImage imageNamed:@"newfoodgroud_save_highlighted"] forState:UIControlStateHighlighted];
    [self setNavigationBarRightView:saveButton];

}

///创建主展示信息的UI
- (void)createMainShowView
{

    [super createMainShowView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ///所有信息放在一个scrollView上，方便纵向逢适应
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, DeviceWidth, DeviceHeight-64)];
    
    ///取消滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    [self.view sendSubviewToBack:scrollView];
    
    ///添加输入控件
    [self createMainShowView:scrollView];

}

/**
 *  @author             yangshengmeng, 14-12-19 10:12:53
 *
 *  @brief              添加输入field
 *
 *  @param scrollView   所有的输入框放在一个scrollview上，方便滚动适应
 *
 *  @since              2.0
 */
- (void)createMainShowView:(UIScrollView *)rootView
{
    
    ///适配数值计算
    CGFloat gap_left_right = DeviceWidth >= 375.0f ? 15.0f : 10.0f;
    CGFloat width = DeviceWidth >= 375.0f ? (DeviceWidth >= 414.0f ? 180.0f : 140.0f) : 95.0f;

    ///团员人数输入框
    UITextField *membersCountField = [[UITextField alloc] initWithFrame:CGRectMake(gap_left_right, 30.0f, width, 44.0f)];
    [self setNormalTextFieldStyle:membersCountField];
    membersCountField.placeholder = _isEdit ? @"团队人数" : _inputInfoModel.membersSumCount;
    membersCountField.tag = 400;
    membersCountField.userInteractionEnabled = _isEdit;
    [rootView addSubview:membersCountField];
    
    QSYFoodGroudLimitedView *limitedView = [[QSYFoodGroudLimitedView alloc] initWithFrame:CGRectMake(membersCountField.frame.origin.x+membersCountField.frame.size.width+5.0f, membersCountField.frame.origin.y, DeviceWidth-width-2.0f*gap_left_right-5.0f, 44.0f) andCurrentSelectedIndex:[_inputInfoModel.addLimited intValue] andCallBack:^(int index) {
        
        ///保存当前的限制条件
        _inputInfoModel.addLimited = [NSString stringWithFormat:@"%d",index];
        
    }];
    limitedView.layer.cornerRadius = 6.0f;
    limitedView.backgroundColor = [UIColor whiteColor];
    limitedView.userInteractionEnabled = _isEdit;
    [rootView addSubview:limitedView];
    
    ///是否可以带家属或闺蜜
    UIButton *canTakeFamiliesButton = [UIButton createImageAndTitleButton:CGRectMake(limitedView.frame.origin.x+10.0f, limitedView.frame.origin.y+limitedView.frame.size.height+5.0f, 160.0f, 20.0f) andCallBack:^(UIButton *button) {
        
        ///修改按钮状态
        if (button.selected) {
            
            _inputInfoModel.canTakeFamilies = @"0";
            button.selected = NO;
            
        } else {
        
            _inputInfoModel.canTakeFamilies = @"1";
            button.selected = YES;
            
        }
        
    }];
    [canTakeFamiliesButton setTitle:@"对方可携带家眷/闺蜜" forState:UIControlStateNormal];
    [canTakeFamiliesButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_normal"] forState:UIControlStateNormal];
    [canTakeFamiliesButton setImage:[UIImage imageNamed:@"mylunchbox_refund_checkbox_selected"] forState:UIControlStateSelected];
    [canTakeFamiliesButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    canTakeFamiliesButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    canTakeFamiliesButton.selected = ([_inputInfoModel.canTakeFamilies intValue] > 0) ? YES : NO;
    canTakeFamiliesButton.userInteractionEnabled = _isEdit;
    [rootView addSubview:canTakeFamiliesButton];
    
    ///支付方式选择窗口
    QSFoodGroudPayStyleView *payStyleView = [[QSFoodGroudPayStyleView alloc] initWithFrame:CGRectMake(gap_left_right, canTakeFamiliesButton.frame.origin.y+canTakeFamiliesButton.frame.size.height+5.0f, DeviceWidth-2.0f*gap_left_right, 44.0f) andCurrentIndex:[_inputInfoModel.payStyle intValue] andCallBack:^(int index) {
        
        ///支付方式回调
        _inputInfoModel.payStyle = [NSString stringWithFormat:@"%d",index];
        
    }];
    payStyleView.backgroundColor = [UIColor whiteColor];
    payStyleView.layer.cornerRadius = 6.0f;
    payStyleView.userInteractionEnabled = _isEdit;
    [rootView addSubview:payStyleView];
    
    ///选择商户
    UITextField *merchantSelected = [[UITextField alloc] initWithFrame:CGRectMake(gap_left_right, payStyleView.frame.origin.y+payStyleView.frame.size.height+8.0f, DeviceWidth-2.0f*gap_left_right, 44.0f)];
    [self setNormalTextFieldStyle:merchantSelected];
    merchantSelected.placeholder = [_inputInfoModel.merchantName length] > 2 ? _inputInfoModel.merchantName  : @"选择餐厅";
    merchantSelected.tag = 401;
    merchantSelected.userInteractionEnabled = _isEdit;
    [rootView addSubview:merchantSelected];
    
    QSImageView *arrowOfMerchantSelected = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    arrowOfMerchantSelected.image = [UIImage imageNamed:@"prepaidcard_order_coupon"];
    merchantSelected.rightViewMode = UITextFieldViewModeAlways;
    merchantSelected.rightView = arrowOfMerchantSelected;
    
    ///时间选择
    UITextField *timeSelected = [[UITextField alloc] initWithFrame:CGRectMake(gap_left_right, merchantSelected.frame.origin.y+merchantSelected.frame.size.height+8.0f, DeviceWidth-2.0f*gap_left_right, 44.0f)];
    [self setNormalTextFieldStyle:timeSelected];
    timeSelected.placeholder = _inputInfoModel.activityTime ? [NSDate formatIntegerIntervalToDateAMPMString:[NSDate formatDateToInterval:_inputInfoModel.activityTime]] : @"聚餐时间";
    timeSelected.tag = 402;
    timeSelected.userInteractionEnabled = _isEdit;
    [rootView addSubview:timeSelected];
    
    QSImageView *arrowOftimeSelected = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    arrowOftimeSelected.image = [UIImage imageNamed:@"prepaidcard_order_coupon"];
    timeSelected.rightViewMode = UITextFieldViewModeAlways;
    timeSelected.rightView = arrowOftimeSelected;
    
    ///备注
    UITextField *commentField = [[UITextField alloc] initWithFrame:CGRectMake(gap_left_right, timeSelected.frame.origin.y+timeSelected.frame.size.height+8.0f, DeviceWidth-2.0f*gap_left_right, 44.0f)];
    [self setNormalTextFieldStyle:commentField];
    commentField.placeholder = [_inputInfoModel.activityComment length] > 2 ? _inputInfoModel.activityComment : @"备注";
    commentField.tag = 403;
    commentField.userInteractionEnabled = _isEdit;
    [rootView addSubview:commentField];
    objc_setAssociatedObject(self, &GroudCommentKey, commentField, OBJC_ASSOCIATION_ASSIGN);
    
    ///兴趣标签
    CGFloat tagYPoint = commentField.frame.origin.y+commentField.frame.size.height+8.0f;
    CGFloat tagWidth = DeviceWidth - 2.0f * gap_left_right;
    UIView *insterestTagRootView = [[UIView alloc] initWithFrame:CGRectMake(gap_left_right, tagYPoint, tagWidth, 44.0f)];
    insterestTagRootView.layer.cornerRadius = 6.0f;
    insterestTagRootView.backgroundColor = [UIColor whiteColor];
    [self createCHoicedTagUI:insterestTagRootView];
    [rootView addSubview:insterestTagRootView];
    
    ///判断是否是可编辑状态
    if (!_isEdit) {
        
        return;
    }
    
    ///换一批
    UIView *changeTagListRootView = [[UIView alloc] initWithFrame:CGRectMake(gap_left_right, insterestTagRootView.frame.origin.y+insterestTagRootView.frame.size.height+8.0f, tagWidth, 75.0f)];
    changeTagListRootView.backgroundColor = [UIColor clearColor];
    [self createUnChoicedTagUI:changeTagListRootView];
    [rootView addSubview:changeTagListRootView];
    objc_setAssociatedObject(self, &UnChoicedTagKey, changeTagListRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///判断是否需要纵向滚动
    CGFloat maxXWidth = changeTagListRootView.frame.origin.y + changeTagListRootView.frame.size.height + 10.0f;
    if (maxXWidth > rootView.frame.size.height) {
        
        rootView.contentSize = CGSizeMake(rootView.frame.size.width, maxXWidth+10.0f);
        
    }
    
}

///创建已选择的标签UI
- (void)createCHoicedTagUI:(UIView *)view
{

    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, view.frame.size.height/2.0f-15.0f, 60.0f, 30.0f)];
    tipsLabel.text = @"兴趣标签";
    tipsLabel.font = [UIFont systemFontOfSize:14.0f];
    tipsLabel.textColor = kBaseGrayColor;
    [view addSubview:tipsLabel];
    
    ///标签滚动view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(tipsLabel.frame.origin.x+tipsLabel.frame.size.width+5.0f, tipsLabel.frame.origin.y, view.frame.size.width-tipsLabel.frame.size.width-15.0f, 30.0f)];
    [view addSubview:scrollView];
    objc_setAssociatedObject(self, &ChoicedTagKey, scrollView, OBJC_ASSOCIATION_ASSIGN);
    
    ///如果原数组已有标签，则添加
    if ((!_isEdit) && ([_inputInfoModel.tagList count] > 0)) {
        
        ///清空
        for (UIView *obj in [scrollView subviews]) {
            
            [obj removeFromSuperview];
            
        }
        
        ///循环创建标签
        CGFloat width = 80.0f;
        CGFloat gap = 10.0f;
        CGFloat height = 30.0f;
        CGFloat xpoint = 0.0f;
        for (int i = 0; i < [_inputInfoModel.tagList count]; i++) {
            
            UIButton *button = [UIButton createBlockActionButton:CGRectMake(xpoint,0.0f, width, height) andStyle:nil andCallBack:^(UIButton *button) {
                
                ///
                
            }];
            button.backgroundColor = kBaseGreenColor;
            [button setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = height/2.0f;
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [button setTitle:_inputInfoModel.tagList[i] forState:UIControlStateNormal];
            
            [scrollView addSubview:button];
            
            ///重置x坐标
            xpoint += (width + gap);
            
        }
        
        ///当添加的标签超出范围时，让底view可以滚动
        if (xpoint > scrollView.frame.size.width) {
            
            scrollView.contentSize = CGSizeMake(xpoint-width, view.frame.size.height);
            
        }
        
    }

}

/**
 *  @author     yangshengmeng, 14-12-21 13:12:15
 *
 *  @brief      在可选择的标签view上创建标签按钮
 *
 *  @param view 标签底view
 *
 *  @since      2.0
 */
- (void)createUnChoicedTagUI:(UIView *)view
{

    CGFloat width = 80.0f;
    CGFloat heihgt = 30.0f;
    CGFloat gap = (DEFAULT_MAX_WIDTH  - 3.0f * width) / 4.0f;
    
    for (int i = 0; i < 5; i++) {
        
        UIButton *button = [UIButton createBlockActionButton:CGRectMake(gap + ((i % 3) * (width + gap)), 5.0f + ((i / 3) * (heihgt + 5.0f)), width, heihgt) andStyle:nil andCallBack:^(UIButton *button) {
            
            ///添加一个标签到已选择中
            [self pickedNNewTag:_unChoicedTagList[i]];
            
            
        }];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:kBaseLightGrayColor forState:UIControlStateHighlighted];
        [button setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        button.layer.cornerRadius = heihgt/2.0f;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [view addSubview:button];
        
    }
    
    ///换一批按钮
    UIButton *changeTagButton = [UIButton createBlockActionButton:CGRectMake(width * 2.0f + gap * 3.0f, 10.0f + heihgt, width, heihgt) andStyle:nil andCallBack:^(UIButton *button) {
        
        ///重新请求标签
        [self getNewsTag];
        
    }];
    changeTagButton.backgroundColor = kBaseGrayColor;
    [changeTagButton setTitle:@"换一批" forState:UIControlStateNormal];
    [changeTagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeTagButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    changeTagButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    changeTagButton.layer.cornerRadius = heihgt/2.0f;
    [view addSubview:changeTagButton];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.22 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///开始时请求标签
        [self getNewsTag];
        
    });

}

/**
 *  @author             yangshengmeng, 14-12-19 12:12:41
 *
 *  @brief              设置普通的输入框风格
 *
 *  @param textField    需要设置风格的输入框
 *
 *  @since              2.0
 */
- (void)setNormalTextFieldStyle:(UITextField *)textField
{

    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:14.0f];
    textField.delegate = self;

}

/**
 *  @author             yangshengmeng, 14-12-21 11:12:04
 *
 *  @brief              回收键盘：当点击键盘的return键，或者点击非输入框区域时，回收键盘
 *
 *  @param textField    当前处于编辑状态的输入框
 *
 *  @return             返回确认结果
 *
 *  @since              2.0
 */
#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;

}

/**
 *  @author             yangshengmeng, 14-12-20 12:12:03
 *
 *  @brief              当输入框开始输入时，根据不同的输入框，将任务分发
 *
 *  @param textField    将要进行编辑的输入框
 *
 *  @return             返回是否可以编辑
 *
 *  @since              2.0
 */
#pragma mark - 当输入框开始输入时，根据不同的输入框，将任务分发
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    ///数量选择
    if (textField.tag == 400) {
        
        [self foodGroudMembersSumCountSelected:textField];
        
        return NO;
    }
    
    ///商户选择
    if (textField.tag == 401) {
        
        [self selectMerchantAction:textField];
        
        return NO;
    }
    
    ///时间选择
    if (textField.tag == 402) {
        
        [self pickActivityTime:textField];
        return NO;
        
    }

    return YES;

}

/**
 *  @author             yangshengmeng, 14-12-21 11:12:00
 *
 *  @brief              当输入框输入结束时，判断是否是人数输入框，是则保存人数
 *
 *  @param textField    当前输入框
 *
 *  @since              2.0
 */
#pragma mark - 判断输入框内容，并保存对应信息
- (void)textFieldDidEndEditing:(UITextField *)textField
{

    ///如果是团成员总人数
    if (400 == textField.tag) {
        
        ///判断是否大于0
        NSString *inputString = textField.text;
        if ([inputString intValue] > 1) {
            
            _inputInfoModel.membersSumCount = [NSString stringWithFormat:@"%d",[inputString intValue]];
            
        }
       
        return;
        
    }
    
    ///备注
    if (403 == textField.tag) {
        
        NSString *comment = textField.text;
        if (comment.length > 0) {
            
            _inputInfoModel.activityComment = comment;
            
        }
        
    }

}

/**
 *  @author             yangshengmeng, 14-12-21 11:12:00
 *
 *  @brief              商户选择时触发的事件，进入商户选择窗口
 *
 *  @param textField    点击商户选择的输入框
 *
 *  @since              2.0
 */
#pragma mark - 点击选择商户时的事件
- (void)selectMerchantAction:(UITextField *)textField
{

    QSMerchantSelectedViewController *merchantSelectedVC = [[QSMerchantSelectedViewController alloc] init];
    merchantSelectedVC.callBack = ^(NSString *merID,NSString *merName,NSDictionary *params){
        
        if (merID && merName) {
            
            ///重置textField的信息
            textField.text = merName;
//            textField.rightViewMode = UITextFieldViewModeNever;
            _inputInfoModel.merchantID = merID;
            _inputInfoModel.merchantName = merName;
            
        } else {
            
            ///重置textField的信息
            textField.text = @"";
            textField.rightViewMode = UITextFieldViewModeAlways;
            
        }
        
    };
    [self.navigationController pushViewController:merchantSelectedVC animated:YES];

}

/**
 *  @author             yangshengmeng, 14-12-21 11:12:45
 *
 *  @brief              搭食团数量选择时的事件，弹出数量选择窗口
 *
 *  @param textField    点击的选择输入框
 *
 *  @since              2.0
 */
#pragma mark - 点击输入数量时的事件
- (void)foodGroudMembersSumCountSelected:(UITextField *)textField
{

    ///设置选择类型
    _pickerView = nil;
    _pickerView = [[QSDatePickerViewController alloc] init];
    _pickerView.pickerType = kPickerType_Item;
    
    ///添加数量源：1-99
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 1 ; i < 100 ; i++) {
        
        [temp addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    _pickerView.dataSource = temp;
    
    [ASDepthModalViewController presentView:_pickerView.view backgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
        
        
        
    }];
    
    _pickerView.onCancelButtonHandler = ^{
        
        [ASDepthModalViewController dismiss];
        
    };
    
    __weak QSNewFoodGroudModel *inputInfoModel = _inputInfoModel;
    _pickerView.onItemConfirmButtonHandler = ^(NSInteger row, NSString *item){
        
        textField.text = item;
        inputInfoModel.membersSumCount = item;
        [ASDepthModalViewController dismiss];
        
    };

}

/**
 *  @author             yangshengmeng, 14-12-21 11:12:50
 *
 *  @brief              时间选择时，弹出时间选择框
 *
 *  @param textField    显示时间的控件
 *
 *  @since              2.0
 */
#pragma mark - 弹出时间选择框
- (void)pickActivityTime:(UITextField *)textField
{
    ///设置选择类型
    _pickerView = nil;
    _pickerView = [[QSDatePickerViewController alloc] init];
    _pickerView.pickerType = kPickerType_DateAndTime;

    [ASDepthModalViewController presentView:_pickerView.view backgroundColor:[UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5] options:ASDepthModalOptionAnimationNone | ASDepthModalOptionBlurNone completionHandler:^(void){
        
    }];
    
    _pickerView.onCancelButtonHandler = ^{
        
        [ASDepthModalViewController dismiss];
        
    };
    
    __weak QSNewFoodGroudModel *inputInfoModel = _inputInfoModel;
    _pickerView.onDateConfirmButtonHandler = ^(NSDate *date, NSString *dateStr){
        
        textField.text = dateStr;
        inputInfoModel.activityTime = date;
        [ASDepthModalViewController dismiss];
        
    };

}

/**
 *  @author yangshengmeng, 14-12-21 13:12:09
 *
 *  @brief  获取随机兴趣标签
 *
 *  @since  2.0
 */
#pragma mark - 获取随机兴趣标签
- (void)getNewsTag
{

    [[QSAPIClientBase sharedClient] randomTagListSuccess:^(QSTagListReturnData *response) {
        
        ///请求成功
        if ([response.data count] >= 5) {
            
            ///清空原数据
            [_unChoicedTagList removeAllObjects];
            
            [_unChoicedTagList addObjectsFromArray:response.data];
            
            ///刷新UI
            [self updateUnChoicedTagUI];
            
        }
        
    } fail:^(NSError *error) {
        
        ///请求失败
        
    }];

}

///添加一个新的标签：需要判断原来是否已存在，存在则不再重复添加
- (void)pickedNNewTag:(NSDictionary *)tagDict
{

    ///遍历对比
    for (NSDictionary *obj in _choicedTagList) {
        
        if ([[tagDict valueForKey:@"id"] isEqualToString:[obj valueForKey:@"tag_id"]]) {
            
            return;
            
        }
        
    }
    
    [_choicedTagList addObject:tagDict];
    
    ///更新UI
    [self updateChoicedTagUI];
    
}

- (void)deleteSelectedTag:(int)index
{

    [_choicedTagList removeObjectAtIndex:index];
    [self updateChoicedTagUI];

}

///更新待选择兴趣标签
- (void)updateUnChoicedTagUI
{

    UIView *view = objc_getAssociatedObject(self, &UnChoicedTagKey);
    
    ///循环创建标签
    for (int i = 0; i < 5; i++) {
        
        UIButton *button = [view subviews][i];
        [button setTitle:[_unChoicedTagList[i] valueForKey:@"tag_name"] forState:UIControlStateNormal];
        
    }
    
}

///更新已选的标签
- (void)updateChoicedTagUI
{

    UIScrollView *view = objc_getAssociatedObject(self, &ChoicedTagKey);
    
    ///清空
    for (UIView *obj in [view subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    ///循环创建标签
    CGFloat width = 80.0f;
    CGFloat gap = 10.0f;
    CGFloat height = 30.0f;
    CGFloat xpoint = 0.0f;
    for (int i = 0; i < [_choicedTagList count]; i++) {
        
        UIButton *button = [UIButton createBlockActionButton:CGRectMake(xpoint,0.0f, width, height) andStyle:nil andCallBack:^(UIButton *button) {
            
            ///添加一个标签到已选择中
            [self deleteSelectedTag:i];
            
            
        }];
        button.backgroundColor = kBaseGreenColor;
        [button setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = height/2.0f;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitle:[_choicedTagList[i] valueForKey:@"tag_name"] forState:UIControlStateNormal];
        
        [view addSubview:button];
        
        ///重置x坐标
        xpoint += (width + gap);
        
    }
    
    ///当添加的标签超出范围时，让底view可以滚动
    if (xpoint > view.frame.size.width) {
        
        view.contentSize = CGSizeMake(xpoint-width, view.frame.size.height);
        
    }
    
}

///返回当前选择的标签数据
- (NSArray *)getTagParamsArray
{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in _choicedTagList) {
        
        [array addObject:[obj valueForKey:@"tag_name"]];
        
    }
    return array;

}

- (void)addFoodGroudWithParams:(NSDictionary *)params
{

    ///开启HUD
    [QSYCustomHUD showOperationHUD:self.view];
    
    [[QSAPIClientBase sharedClient] addFoodGroudWithParams:params andCallBack:^(BOOL flag, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否添加成功
        if (!flag) {
            
            ///隐藏HUD
            [QSYCustomHUD hiddenOperationHUD];
            
            [self showAlertMessageWithTime:0.5 andMessage:@"添加失败，请稍后再试" andCallBack:^(CGFloat showTime) {
                
            }];
            return;
            
        }
        
        ///隐藏HUD
        [QSYCustomHUD hiddenOperationHUD];
        
        ///添加成功
        [self showAlertMessageWithTime:0.5 andMessage:@"添加成功！" andCallBack:^(CGFloat showTime) {
            
            ///返回列表
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        return;
        
    }];

}

@end
