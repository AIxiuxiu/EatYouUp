//
//  QSMerchantCollectionCell.h
//  Eating
//
//  Created by System Administrator on 12/13/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSMerchantDetailData;
@class QSMerchantIndexReturnData;
@interface QSMerchantCollectionCell : UITableViewCell

@property (nonatomic, strong) QSMerchantDetailData *item;

@property (weak, nonatomic) IBOutlet UIScrollView *containScrollowView;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *distanceButton;
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;

@property (weak, nonatomic) IBOutlet UIButton *tapButton;

@property (nonatomic, strong) void(^onVoiceButtonHandler)();
@property (nonatomic, strong) void(^onIntroButtonHandler)(QSMerchantIndexReturnData *);
@property (nonatomic, strong) void(^onTapButtonHandler)();

- (IBAction)onVoiceButtonAction:(id)sender;

- (IBAction)onIntroButtonAction:(id)sender;

- (IBAction)onTapButtonAction:(id)sender;

- (void)showMenu;

- (void)hideMenu;
@end
