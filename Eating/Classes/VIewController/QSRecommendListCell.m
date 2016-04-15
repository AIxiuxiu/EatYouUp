//
//  QSRecommendListCell.m
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSRecommendListCell.h"
#import "QSCouponCellViewController.h"
#import "QSStarViewController.h"
#import <UIImageView+AFNetworking.h>
#import "NSString+Name.h"

@interface QSRecommendListCell()

@property (nonatomic, strong) NSMutableArray *couponViews;
@property (nonatomic, strong) UIView *couponContainView;

@end

@implementation QSRecommendListCell

- (NSMutableArray *)couponViews
{
    if (!_couponViews) {
        _couponViews = [[NSMutableArray alloc] init];
    }
    return _couponViews;
}

- (void)setItem:(NSDictionary *)item
{
    _item = item;
    self.shopNameLabel.textColor = [_item objectForKey:@"merchant_name"];
    [self.logoImageView setImageWithURL:[NSURL URLWithString:[[_item objectForKey:@"merchant_logo"] imageUrl]] placeholderImage:nil];
}

- (void)awakeFromNib {
    
    self.shopNameLabel.textColor = kBaseGrayColor;
    [self.distanceButton setTitle:@"     150m" forState:UIControlStateNormal];
    [self.logoImageView roundView];
    self.logoImageView.clipsToBounds = YES;
    UIView *star = [QSStarViewController cellStarView:4 showPointLabal:YES];
    CGRect frame = star.frame;
    frame.origin.x = CGRectGetMinX(self.shopNameLabel.frame);
    frame.origin.y = CGRectGetMaxY(self.shopNameLabel.frame);
    star.frame = frame;
    [self.contentView addSubview:star];
    
    [self.distanceButton customButton:kCustomButtonType_IndexCellDistance];
    
    

}

+ (CGFloat)cellHeight:(NSInteger)count
{
    return 64;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
