//
//  QSIndexCell3.m
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSIndexCell3.h"
#import "QSConfig.h"
#import "UIView+UI.h"
#import "QSStarViewController.h"
#import "QSAPIModel+Merchant.h"
#import "QSAPIModel+User.h"
#import "UIImageView+AFNetworking.h"
#import <CoreLocation/CLLocation.h>

@interface QSIndexCell3()<UIApplicationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *starView;

@end

@implementation QSIndexCell3

- (void)setItem:(QSMerchantDetailData *)item
{
    _item = item;
    self.shopNameLabel.text = _item.merchant_name;

    [self.picImageView setImageWithURL:[NSURL URLWithString:_item.merchant_logo] placeholderImage:IMAGENAME(@"merchant_defaultlog")];
    
    self.consumeLabel.text = [NSString stringWithFormat:@"人均￥%@",_item.merchant_per];
    
    self.starView = [QSStarViewController cellStarView:[_item.score integerValue] showPointLabal:YES];
    
    [self.infoView addSubview:self.starView];
    
    //double latitude = 23.144994;
    //double longitude = 113.327572;

    CLLocationCoordinate2D point1 = [UserManager sharedManager].userData.location;
    
    if (point1.latitude <= 0 || point1.longitude <= 0) {
        [self.distanceButton setTitle:@"  计算中" forState:UIControlStateNormal];

    }
    else{
        CLLocationCoordinate2D point2 = CLLocationCoordinate2DMake([_item.latitude doubleValue], [_item.longitude doubleValue]);
        NSString *distance = [[UserManager sharedManager] distanceBetweenTwoPoint:point1 andPoint2:point2];
        [self.distanceButton setTitle:[NSString stringWithFormat:@"   %@",distance] forState:UIControlStateNormal];
    }
    

}

- (void)awakeFromNib {

    self.backgroundColor = kBaseBackgroundColor;
    
    self.shopNameLabel.textColor = kBaseGrayColor;
    self.shopTypeLabel.textColor = kBaseGrayColor;
    [self.distanceButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    self.consumeLabel.textColor = kBaseOrangeColor;
    
    [self.distanceButton setTitle:@"    " forState:UIControlStateNormal];
    [self.distanceButton customButton:kCustomButtonType_IndexCellDistance];
    
    
    [self.picImageView.layer setBorderWidth:2];
    [self.picImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.picImageView roundView];

    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onVoiceButtonAction:)];
    tap1.numberOfTapsRequired = 1;
    tap1.numberOfTouchesRequired = 1;
    [self.voiceButton addGestureRecognizer:tap1];

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onIntroButtonAction:)];
    tap2.numberOfTapsRequired = 1;
    tap2.numberOfTouchesRequired = 1;
    [self.introButton addGestureRecognizer:tap2];
    
    self.infoView.backgroundColor = kBaseBackgroundColor;
    [self.infoBackgroundImageView roundCornerRadius:4];
    [self.menuView roundCornerRadius:4];

    
    [self.voiceButton addTarget:self
                         action:@selector(onVoiceButtonHandler)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.introButton addTarget:self
                         action:@selector(onIntroButtonHandler)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.tapButton addTarget:self
                       action:@selector(onTapButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.collectButton addTarget:self
                       action:@selector(onCollectButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self setNeedsDisplay];
}

- (IBAction)onNop:(id)sender
{
    UITapGestureRecognizer *tap = sender;
    if ([tap locationInView:self.menuView].x >= CGRectGetMinX(self.voiceButton.frame) && [tap locationInView:self.menuView].x <= CGRectGetMaxX(self.voiceButton.frame) && [tap locationInView:self.menuView].y >= CGRectGetMinY(self.voiceButton.frame) && [tap locationInView:self.menuView].y <= CGRectGetMaxY(self.voiceButton.frame)) {
        [self onVoiceButtonAction:self.voiceButton];
    }
    else if ([tap locationInView:self.menuView].x >= CGRectGetMinX(self.introButton.frame) && [tap locationInView:self.menuView].x <= CGRectGetMaxX(self.introButton.frame) && [tap locationInView:self.menuView].y >= CGRectGetMinY(self.introButton.frame) && [tap locationInView:self.menuView].y <= CGRectGetMaxY(self.introButton.frame)) {
        [self onIntroButtonAction:self.introButton];
    }
}

- (IBAction)onVoiceButtonAction:(id)sender
{
    if (self.onVoiceButtonHandler) {
        self.onVoiceButtonHandler();
    }
}


- (IBAction)onIntroButtonAction:(id)sender
{
    if (self.onIntroButtonHandler) {
        QSMerchantIndexReturnData *indexReturnData = [[QSMerchantIndexReturnData alloc] init];
        indexReturnData.type = YES;
        indexReturnData.data = _item;
        self.onIntroButtonHandler(indexReturnData);
    }
}

- (IBAction)onTapButtonAction:(id)sender
{
    if (self.onTapButtonHandler) {
        self.onTapButtonHandler();
    }
}

- (IBAction)onCollectButtonAction:(id)sender
{
    UIButton *button = sender;
//    button.selected = !button.selected;
    if (self.onCollectButtonHandler) {
        self.onCollectButtonHandler(button.selected);
    }
}

- (void)showMenu
{
    [self.containScrollowView setContentOffset:CGPointMake(self.menuView.frame.size.width+20, 0) animated:YES];
}

- (void)hideMenu
{
    [self.containScrollowView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)drawRect:(CGRect)rect
{
    if (self.showCollectionButton) {
        [self.collectButton setBackgroundImage:IMAGENAME(@"user_collection_merchant.png") forState:UIControlStateNormal];
        [self.collectButton setBackgroundImage:IMAGENAME(@"user_collection_merchant_selected.png") forState:UIControlStateSelected];
        self.collectButton.hidden = NO;
        self.distanceButton.hidden = YES;
        self.consumeLabel.hidden = YES;
        self.collectButton.selected = YES;
    }
    
    CGRect frame = self.infoView.frame;
    frame.size.width = DeviceWidth;
    self.infoView.frame = frame;
    
    frame = self.menuView.frame;
    frame.origin.x = DeviceWidth + 7;
    self.menuView.frame = frame;
    
    frame = self.starView.frame;
    frame.origin.x = self.shopNameLabel.frame.origin.x;
    frame.origin.y = CGRectGetMaxY(self.shopTypeLabel.frame)+2;
    self.starView.frame = frame;
    
    
    CGFloat xx = CGRectGetMaxX(self.starView.frame)+5;
    if ([[self.item.free_service allKeys] containsObject:@"1"]) {
        UIImageView *wifi = [[UIImageView alloc] initWithFrame:CGRectMake(xx, self.starView.frame.origin.y+2, 16, 16)];
        wifi.image = IMAGENAME(@"icon_wifi.png");
        [self.infoView addSubview:wifi];
        xx += 20;
    }
    if (self.item.merchant_sounds) {
        UIImageView *voice = [[UIImageView alloc] initWithFrame:CGRectMake(xx, self.starView.frame.origin.y+2, 16, 16)];
        voice.image = IMAGENAME(@"icon_voice.png");
        [self.infoView addSubview:voice];
    }
    


    
    self.containScrollowView.contentSize = CGSizeMake(DeviceWidth+CGRectGetWidth(self.menuView.frame)+20, 90);
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.onOpenHandler) {
        self.onOpenHandler();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
