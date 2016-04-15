//
//  QSFoodCommentViewController.h
//  eating
//
//  Created by MJie on 14-11-9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSMerchantDetailData;
@interface QSFoodCommentViewController : QSViewController

@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, strong) QSMerchantDetailData *merchantDetailData;
@property (nonatomic, strong) UIImage *merchantLogo;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIButton *makeCommentButton;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerCountLabel;

- (IBAction)onMakeCommentButtonAction:(id)sender;

@end
