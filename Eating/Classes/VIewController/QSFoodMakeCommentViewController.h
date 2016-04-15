//
//  QSFoodMakeCommentViewController.h
//  eating
//
//  Created by MJie on 14-11-9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSMerchantDetailData;
@interface QSFoodMakeCommentViewController : QSViewController

@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, strong) QSMerchantDetailData *merchantDetailData;
@property (nonatomic, strong) UIImage *merchantLogo;

@property (weak, nonatomic) IBOutlet UIButton *handoverButton;

@property (weak, nonatomic) IBOutlet UIScrollView *CommentScrollView;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UIView *recommendView;
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;
@property (weak, nonatomic) IBOutlet UIView *consumeView;
@property (weak, nonatomic) IBOutlet UITextField *consumeTextField;

@property (weak, nonatomic) IBOutlet UIView *foodView;
@property (weak, nonatomic) IBOutlet UITableView *foodTableView;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *shareWeiboButton;
@property (weak, nonatomic) IBOutlet UIButton *shareQQWeiboButton;
@property (weak, nonatomic) IBOutlet UIButton *shareQQButton;
@property (weak, nonatomic) IBOutlet UIButton *shareWebchatTimelineButton;
@property (weak, nonatomic) IBOutlet UIButton *shareWebchatSessionButton;

@property (weak, nonatomic) IBOutlet UIButton *starButton1;
@property (weak, nonatomic) IBOutlet UIButton *starButton2;
@property (weak, nonatomic) IBOutlet UIButton *starButton3;
@property (weak, nonatomic) IBOutlet UIButton *starButton4;
@property (weak, nonatomic) IBOutlet UIButton *starButton5;

- (IBAction)onHandoverButtonAction:(id)sender;

- (IBAction)onRecommendButtonAction:(id)sender;

- (IBAction)onShareButtonAction:(id)sender;

- (IBAction)onStarButtonAction:(id)sender;

@end
