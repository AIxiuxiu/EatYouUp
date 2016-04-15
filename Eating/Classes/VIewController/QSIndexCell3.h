//
//  QSIndexCell3.h
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewCell.h"

@class QSMerchantDetailData;
@class QSMerchantIndexReturnData;
@interface QSIndexCell3 : QSViewCell

@property (nonatomic, strong) QSMerchantDetailData *item;

@property (weak, nonatomic) IBOutlet UIScrollView *containScrollowView;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UIButton *introButton;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *distanceButton;
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;

@property (weak, nonatomic) IBOutlet UIButton *tapButton;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (nonatomic, unsafe_unretained) BOOL showCollectionButton;

@property (nonatomic, strong) void(^onVoiceButtonHandler)();
@property (nonatomic, strong) void(^onIntroButtonHandler)(QSMerchantIndexReturnData *);
@property (nonatomic, strong) void(^onTapButtonHandler)();

@property (nonatomic, strong) void(^onCollectButtonHandler)(BOOL);

@property (nonatomic, strong) void(^onOpenHandler)();

- (IBAction)onVoiceButtonAction:(id)sender;

- (IBAction)onIntroButtonAction:(id)sender;

- (IBAction)onTapButtonAction:(id)sender;

- (IBAction)onCollectButtonAction:(id)sender;

- (void)showMenu;

- (void)hideMenu;
@end
