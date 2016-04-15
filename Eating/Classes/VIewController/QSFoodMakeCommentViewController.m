//
//  QSFoodMakeCommentViewController.m
//  eating
//
//  Created by MJie on 14-11-9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodMakeCommentViewController.h"
#import "QSRecommendFoodListViewController.h"
#import "QSStarViewController.h"
#import "QSRecommendFoodListCell.h"
#import "QSAPIClientBase+Comment.h"
#import "QSAPIModel+Comment.h"
#import "QSAPIModel+Food.h"
#import "SocaialManager.h"

@interface QSFoodMakeCommentViewController ()<UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *recommendFoodList;
@property (nonatomic, strong) NSArray *starButtons;
@property (nonatomic, unsafe_unretained) NSInteger rate;
@end

@implementation QSFoodMakeCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.CommentScrollView.frame;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 69;
    self.CommentScrollView.frame = frame;
    
    frame = self.infoView.frame;
    frame.size.width = DeviceWidth;
    self.infoView.frame = frame;
    
    frame = self.commentTextView.frame;
    frame.size.width = DeviceWidth - 20;
    self.commentTextView.frame = frame;
    
    frame = self.recommendView.frame;
    frame.size.width = (DeviceWidth - 20 - 8)/2;
    self.recommendView.frame = frame;
    
    frame = self.consumeView.frame;
    frame.origin.x = CGRectGetMaxX(self.recommendView.frame)+8;
    frame.size.width = (DeviceWidth - 20 - 8)/2;
    self.consumeView.frame = frame;
    
    frame = self.starView.frame;
    frame.origin.x = (DeviceWidth - frame.size.width)/2;
    self.starView.frame =frame;
}

- (NSArray *)starButtons
{
    if (!_starButtons) {
        _starButtons = [[NSArray alloc] initWithObjects:self.starButton1,self.starButton2,self.starButton3,self.starButton4,self.starButton5, nil];
    }
    return _starButtons;
}

- (void)setupUI
{
    self.titleLabel.text = @"添加评论";
    
    [self setupStarView];
    
    [self setupInforView];
    
    [self setupTableView];
    
    [self setupShareView];
}

- (void)setupStarView
{

}

- (void)setupTableView
{
    CGRect frame = self.foodView.frame;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(self.infoView.frame);
    frame.size.width = DeviceWidth;
    frame.size.height = 0;
    self.foodView.frame = frame;
}

- (void)setupInforView
{
    self.infoView.backgroundColor = kBaseBackgroundColor;
    self.commentTextView.textColor = kBaseGrayColor;
    self.commentTextView.delegate = self;
    [self.commentTextView roundCornerRadius:0];
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 21)];
    self.placeholderLabel.textColor = kBaseLightGrayColor;
    self.placeholderLabel.text = @"请在此聊天框输入内容";
    self.placeholderLabel.font = [UIFont systemFontOfSize:13.0];
    [self.commentTextView addSubview:self.placeholderLabel];
    
    [self.recommendView roundCornerRadius:10];
    [self.consumeView roundCornerRadius:10];
    
    [self.recommendButton customButton:kCustomButtonType_CommentMakeRecommend];
}

- (void)setupShareView
{
    CGRect frame = self.shareView.frame;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(self.foodView.frame)+20;
    self.shareView.frame = frame;
}

- (void)onShareButtonAction:(id)sender
{

    UIButton *button = sender;
        [self.commentTextView resignFirstResponder];
    if (button == self.shareWebchatTimelineButton) {
        [[SocaialManager sharedManager] shareToWechatTimelineWithFeedID:nil
                                                                Content:@"省心省力省钱省时间，“吃订你”轻轻一点立即省"
                                                               UserName:nil
                                                               WorkName:nil
                                                                 Images:self.merchantLogo
                                                                Success:^(BOOL isSucc) {
                                                                    
                                                                }];
    }
    else if (button == self.shareWebchatSessionButton){
        [[SocaialManager sharedManager] shareToWechatSessionWithFeedID:nil
                                                                Content:@"省心省力省钱省时间，“吃订你”轻轻一点立即省"
                                                               UserName:nil
                                                               WorkName:nil
                                                                 Images:self.merchantLogo
                                                                Success:^(BOOL isSucc) {
                                                                    
                                                                }];
    }
    
}

- (IBAction)onStarButtonAction:(id)sender
{
    UIButton *button = sender;
    self.starButton1.selected = NO;
    self.starButton2.selected = NO;
    self.starButton3.selected = NO;
    self.starButton4.selected = NO;
    self.starButton5.selected = NO;
    for (int i = 0 ; i <= button.tag ; i++) {
        UIButton *star = self.starButtons[i];
        star.selected = YES;
    }
    self.rate = (button.tag + 1)*2;
}

- (IBAction)onHandoverButtonAction:(id)sender
{
    
    if ([self.commentTextView.text isEqualToString:@""]) {
        [self showTip:self.view tipStr:@"请输入评价"];
        return;
    }
    if (self.rate == 0) {
        [self showTip:self.view tipStr:@"请评分"];
        return;
    }
    if ([self.consumeTextField.text isEqualToString:@""]) {
        [self showTip:self.view tipStr:@"请填写人均消费"];
        return;
    }
    [self.commentTextView resignFirstResponder];
    __weak QSFoodMakeCommentViewController *weakSelf = self;
    
    NSMutableArray *image_list = [[NSMutableArray alloc] init];
    for (QSFoodDetailData *info in self.recommendFoodList) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:info.goods_name forKey:@"goods_name"];
        [dict setValue:info.goods_image forKey:@"goods_image"];
        [image_list addObject:dict];
    }
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] addMerchantCommentWithMerchantId:self.merchant_id
                                                             context:self.commentTextView.text
                                                            evaluate:[NSString stringWithFormat:@"%ld",self.rate]
                                                                 per:self.consumeTextField.text
                                                           imageList:image_list
                                                             success:^(QSAPIModel *response) {
                                                                                                                  [weakSelf hideLoadingHud];
                                                                 [weakSelf.navigationController popViewControllerAnimated:YES];
                                                             } fail:^(NSError *error){
                                                                                                                [weakSelf hideLoadingHud];
                                                             }];
}

- (IBAction)onRecommendButtonAction:(id)sender
{
    [self.commentTextView resignFirstResponder];
    QSRecommendFoodListViewController *viewVC = [[QSRecommendFoodListViewController alloc] init];
    viewVC.merchant_id = self.merchant_id;
    viewVC.preFoodlist = self.recommendFoodList;
    [self.navigationController pushViewController:viewVC animated:YES];
    
    viewVC.onConfirmHandler = ^(NSMutableArray *foodlist){
        _recommendFoodList = [NSMutableArray arrayWithArray:foodlist];
        CGFloat height;
        if (!_recommendFoodList.count) {
            height = 0;
        }
        else{
            height = 50+_recommendFoodList.count*68;
        }
        CGRect frame = self.foodView.frame;
        frame.origin.x = 0;
        frame.origin.y = CGRectGetMaxY(self.infoView.frame)+10;
        frame.size.height = height;
        self.foodView.frame = frame;
        
        frame = self.foodTableView.frame;
        frame.size.height = _recommendFoodList.count*68;
        self.foodTableView.frame = frame;
        
        [self.foodTableView reloadData];
        
        [self setupShareView];
        self.CommentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.shareView.frame)+20);
    };
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recommendFoodList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSFoodMakeCommentViewController *weakSelf = self;
    static NSString *identifier = @"Cell";
    QSRecommendFoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSRecommendFoodListCell" owner:self options:nil];
        if ([nibs count] > 0) {
            cell = nibs[0];
        }
        cell.cellType = kRecommendFoodType_RecommendShow;
    }
    cell.item = self.recommendFoodList[indexPath.row];

    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = ![textView.text isEqualToString:@""];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = ![textView.text isEqualToString:@""];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.commentTextView resignFirstResponder];
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
