//
//  QSMerchantIndexCell1.m
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMerchantIndexCell1.h"
#import "UIButton+UI.h"
#import "QSAPIModel+Merchant.h"
#import "UIImageView+AFNetworking.h"
#import "QSStarViewController.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"

@implementation QSMerchantIndexCell1

- (void)setItem:(QSMerchantDetailData *)item
{
    _item = item;
    [self.consumeButton setTitle:_item.merchant_per forState:UIControlStateNormal];
    if (_item.merchant_image_arr.count) {
        NSDictionary *info = _item.merchant_image_arr[0];
        NSString *url = [info objectForKey:@"image_link"];
        [self.bgImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];

    }
    self.collectButton.selected = [_item.isStore boolValue];
    [self.consumeButton setTitle:[NSString stringWithFormat:@" ￥%@",_item.merchant_per] forState:UIControlStateNormal];
    UIView *starView = [QSStarViewController cellStarView:[_item.score integerValue] showPointLabal:YES];
    starView.center = CGPointMake(self.starbgImageView.frame.size.width/2, self.starbgImageView.frame.size.height/2+3);
    [self.starbgImageView addSubview:starView];
    
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


- (IBAction)onCollectButtonAction:(id)sender
{
    if (self.onCollectHandler) {
        self.onCollectHandler(self.collectButton.selected);
    }
}

- (void)awakeFromNib {

    [self.consumeButton customButton:kCustomButtonType_Consume];
    [self.distanceButton customButton:kCustomButtonType_Distance];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
