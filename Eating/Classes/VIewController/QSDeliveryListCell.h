//
//  QSDeliveryListCell.h
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSDeliveryDetailData;
@interface QSDeliveryListCell : UITableViewCell

@property (weak, nonatomic) QSDeliveryDetailData *item;

@property (weak, nonatomic) IBOutlet UIScrollView *containScrollowView;

@property (weak, nonatomic) IBOutlet UIView *infoView;
//@property (weak, nonatomic) IBOutlet UIImageView *infoBackgroundImageView;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *tapButton;
@property (weak ,nonatomic) IBOutlet UILabel *nikeLabel;

@property (nonatomic, strong) void(^onDeleteButtonHandler)();
@property (nonatomic, strong) void(^onTapButtonHandler)();

- (IBAction)onTapButtonAction:(id)sender;

- (IBAction)onDeleteButtonAction:(id)sender;

@end
