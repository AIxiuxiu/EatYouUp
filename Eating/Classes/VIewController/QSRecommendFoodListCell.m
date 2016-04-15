//
//  QSRecommendFoodListCell.m
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSRecommendFoodListCell.h"
#import "QSConfig.h"
#import "UIButton+UI.h"
#import "UIView+UI.h"
#import "QSAPIModel+Food.h"
#import "QSAPIModel+Takeout.h"
#import "NSString+Name.h"
#import "UIImageView+AFNetworking.h"

//1=>'在售',
//2=>'已停售'

@implementation QSRecommendFoodListCell

- (void)setCellType:(kRecommendFoodType)cellType{
    
    _cellType = cellType;
    
}

- (void)setItem:(id)item
{
    _item = item;
    if ([_item isKindOfClass:[QSFoodDetailData class]]) {
        
        QSFoodDetailData *info = _item;
        self.foodNameLabel.text = info.goods_name;
        [self.countButton setTitle:[NSString stringWithFormat:@"%d",info.localAmount] forState:UIControlStateNormal];
        [self.picImageView setImageWithURL:[NSURL URLWithString:[info.goods_image imageUrl]] placeholderImage:nil];

    } else if ([_item isKindOfClass:[QSTakeoutDetailData class]]){

        QSFoodDetailData *info = _item;
        self.foodNameLabel.text = info.goods_name;
        [self.countButton setTitle:[NSString stringWithFormat:@"%@",info.num] forState:UIControlStateNormal];
        [self.picImageView setImageWithURL:[NSURL URLWithString:[info.goods_image imageUrl]] placeholderImage:nil];
        
    }
}

- (void)awakeFromNib {

    [self.picImageView roundView];
    self.foodNameLabel.textColor = kBaseGrayColor;

    [self.foodStatusButton roundCornerRadius:8];
    [self.checkBox setBackgroundImage:IMAGENAME(@"food_recommend_checkbox.png") forState:UIControlStateNormal];
    [self.checkBox setBackgroundImage:IMAGENAME(@"food_recommend_checkbox_selected.png") forState:UIControlStateSelected];
    [self.foodStatusButton setTitle:@"在售中" forState:UIControlStateNormal];
    [self.foodStatusButton setTitle:@"已售完" forState:UIControlStateDisabled];
    [self.foodStatusButton setBackgroundColor:kBaseGreenColor];
    [self.checkBox addTarget:self action:@selector(onCheckBoxButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.countButton addTarget:self action:@selector(onCountSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.countButton roundButton];
    [self.countButton setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
    
    if (self.cellType == kRecommendFoodType_RecommendSelect) {
        
        self.checkBox.hidden = NO;
        self.countButton.hidden = YES;
        self.checkBox.center = CGPointMake(DeviceWidth-30, CGRectGetMidY(self.frame));
    }
    else if (self.cellType == kRecommendFoodType_RecommendShow){
        
        self.checkBox.hidden = YES;
        self.countButton.hidden =YES;
    }
    else if (self.cellType == kRecommendFoodType_TakeoutShow){
        
        self.checkBox.hidden = YES;
        self.countButton.hidden = NO;
        self.countButton.userInteractionEnabled = NO;
        self.countButton.center = CGPointMake(DeviceWidth-30, CGRectGetMidY(self.frame));
        
    }
    else if (self.cellType == kRecommendFoodType_TakeoutSelect){
        
        self.checkBox.hidden = YES;
        self.countButton.hidden = NO;
        self.countButton.center = CGPointMake(DeviceWidth-30, CGRectGetMidY(self.frame));
        
    }
    
}

//- (void)setIsSoldout:(BOOL)isSoldout
//{
//    _isSoldout = isSoldout;
//    self.foodStatusButton.enabled = !_isSoldout;
////    self.checkBox.hidden = _isSoldout;
//    
//    if (_isSoldout) {
//        
//        [self.foodStatusButton setBackgroundColor:kBaseGrayColor];
//    }
//    else{
//        [self.foodStatusButton setBackgroundColor:kBaseGreenColor];
//
//    }
//    
//}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.checkBox.selected = _isSelected;
    
//    [self setNeedsDisplay];
}


- (IBAction)onCheckBoxButtonAction:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    _isSelected = button.selected;
    if (self.onCheckHandler) {
        self.onCheckHandler(_isSelected);
    }
}

- (IBAction)onCountSelectButtonAction:(id)sender
{
    UIButton *button = sender;
    if (self.onCountHandler) {
        self.onCountHandler();
    }
}

- (void)drawRect:(CGRect)rect
{
    QSFoodDetailData *info = _item;
    
    self.priceView = [UIView priceViewWithPrice:info.goods_pice Color:kBaseOrangeColor];
    [self.contentView addSubview:self.priceView];
    
    if (self.cellType == kRecommendFoodType_RecommendSelect) {
        CGRect frame = self.priceView.frame;
        frame.origin.x = DeviceWidth - CGRectGetWidth(frame) - 50;
        frame.origin.y = 9;
        self.priceView.frame = frame;
        self.checkBox.hidden = NO;
        self.countButton.hidden = YES;
    
    }
    else if (self.cellType == kRecommendFoodType_RecommendShow){
        CGRect frame = self.priceView.frame;
        frame.origin.x = DeviceWidth - CGRectGetWidth(frame) - 20;
        frame.origin.y = 9;
        self.priceView.frame = frame;
        self.checkBox.hidden = YES;
        self.countButton.hidden =YES;
    }
    else if (self.cellType == kRecommendFoodType_TakeoutShow){
        CGRect frame = self.priceView.frame;
        frame.origin.x = DeviceWidth - CGRectGetWidth(frame) - 50;
        frame.origin.y = 9;
        self.priceView.frame = frame;
        self.checkBox.hidden = YES;
        self.countButton.hidden = NO;
        self.checkBox.enabled = NO;
        
    }
    else if (self.cellType == kRecommendFoodType_TakeoutSelect){
        CGRect frame = self.priceView.frame;
        frame.origin.x = DeviceWidth - CGRectGetWidth(frame) - 50;
        frame.origin.y = 9;
        self.priceView.frame = frame;
        self.checkBox.hidden = YES;
        self.countButton.hidden = NO;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
