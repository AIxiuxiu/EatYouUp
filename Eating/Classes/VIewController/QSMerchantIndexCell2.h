//
//  QSMerchantIndexCell2.h
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewCell.h"

@class QSMerchantDetailData;
@interface QSMerchantIndexCell2 : QSViewCell

@property (nonatomic, strong) QSMerchantDetailData *item;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIScrollView *foodScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIView *couponView;

@property (nonatomic, strong) void(^onChatButtonHandler)();
@property (nonatomic, strong) void(^onCallButtonHandler)();
@property (nonatomic, strong) void(^onAllButtonHandler)();
@property (nonatomic, strong) void(^onFoodButtonHandler)(NSString *);

- (IBAction)onCallToMerchantButtonAction:(id)sender;

- (IBAction)onChatToMerchantButtonAction:(id)sender;

- (IBAction)onAllMerchantButtonAction:(id)sender;

- (IBAction)onFoodButtonAction:(id)sender;
@end
