//
//  QSFoodCommentViewController.m
//  eating
//
//  Created by MJie on 14-11-9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodCommentViewController.h"
#import "QSFoodMakeCommentViewController.h"
#import "QSStarViewController.h"
#import "QSFoodCommentListCell.h"
#import "QSAPIClientBase+Comment.h"
#import "QSAPIModel+Comment.h"

@interface QSFoodCommentViewController ()

@property (nonatomic, strong) QSCommentListReturnData *commentListReturnData;

@end

@implementation QSFoodCommentViewController

- (void)setCommentListReturnData:(QSCommentListReturnData *)commentListReturnData
{
    
    _commentListReturnData = commentListReturnData;
    self.headerCountLabel.text = [NSString stringWithFormat:@"评价 (%d条)",(int)_commentListReturnData.data.count];
    [self.commentTableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.commentTableView.frame;
    frame.size.width = DeviceWidth;
    frame.size.height = DeviceHeight - 110;
    self.commentTableView.frame = frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getCommentList];
}

- (void)getCommentList
{
    __weak QSFoodCommentViewController *weakSelf = self;
    [self showLoadingHud];
    [[QSAPIClientBase sharedClient] commentListWithMerchantId:self.merchant_id
                                                      success:^(QSCommentListReturnData *response) {
                                                                                                           [weakSelf hideLoadingHud];
                                                          weakSelf.commentListReturnData = response;
                                                          
                                                      } fail:^(NSError *error) {
                                                                                                           [weakSelf hideLoadingHud];
                                                      }];
}

- (void)setupUI
{
    self.titleLabel.text = @"全部评论";
    
    self.headerCountLabel.textColor = kBaseGrayColor;
    [self.headerBgImageView roundCornerRadius:8];
    UIView *star = [QSStarViewController cellStarView:4 showPointLabal:YES];
    star.center = CGPointMake(DeviceMidX, self.headerCountLabel.center.y+25);
    [self.headerView addSubview:star];
    self.commentTableView.tableHeaderView = self.headerView;
    
    
}

- (IBAction)onMakeCommentButtonAction:(id)sender
{
    if (![self checkIsLogin]) {
        return;
    }
    QSFoodMakeCommentViewController *viewVC = [[QSFoodMakeCommentViewController alloc] init];
    viewVC.merchant_id = self.merchant_id;
    viewVC.merchantDetailData = self.merchantDetailData;
    viewVC.merchantLogo = self.merchantLogo;
    [self.navigationController pushViewController:viewVC animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentListReturnData.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QSFoodCommentListCell cellHeight:self.commentListReturnData.data[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    QSFoodCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"QSFoodCommentListCell" owner:self options:nil];
        if ([nibs count] > 0) {
            cell = nibs[0];
        }

    }
    cell.item = self.commentListReturnData.data[indexPath.row];
    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
