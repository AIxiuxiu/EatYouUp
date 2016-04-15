//
//  QSIndexCell2.h
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewCell.h"

@interface QSIndexCell2 : QSViewCell

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIImageView *icon1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *icon2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *icon1Label;
@property (weak, nonatomic) IBOutlet UILabel *icon2Label;
@property (weak, nonatomic) IBOutlet UIButton *icon1Button;
@property (weak, nonatomic) IBOutlet UIButton *icon2Button;

@property (nonatomic, strong) void(^onIconButtonHandler)(NSInteger);

- (IBAction)onIconButtonAction:(id)sender;

 @end
