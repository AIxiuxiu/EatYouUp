//
//  QSRecommendListCell.h
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSRecommendListCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *item;

@property (weak, nonatomic) IBOutlet UIImageView *headerBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *distanceButton;

@property (nonatomic, strong) NSMutableArray *coupons;

+ (CGFloat)cellHeight:(NSInteger)count;

@end
