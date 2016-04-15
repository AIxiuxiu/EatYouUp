//
//  QSFoodListCell.m
//  eating
//
//  Created by MJie on 14-11-9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodListCell.h"
#import "QSConfig.h"
#import "UIView+UI.h"
#import "QSAPIModel+Food.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+UI.h"

@implementation QSFoodListCell

- (void)setItem1:(QSFoodDetailData *)item1
{
    _item1 = item1;
    self.foodNameLabel1.text = _item1.goods_name;
    self.foodPriceLabel1.text = [NSString stringWithFormat:@"￥%@",_item1.goods_pice];
    [self.foodPicImageView1 setImageWithURL:[NSURL URLWithString:_item1.goods_image] placeholderImage:nil];
    NSArray *temp = [_item1.goods_tag componentsSeparatedByString:@","];
    if (temp.count > 1 && !_collectionType){
        [self.foodView1 customFoodView:[temp[1] integerValue]];
    }
    
    [self setNeedsDisplay];

}

- (void)setItem2:(QSFoodDetailData *)item2
{
    _item2 = item2;
    if (!_item2.goods_name) {
        self.foodView2.hidden = YES;
        return;
    }
    self.foodView2.hidden = NO;
    self.foodNameLabel2.text = _item2.goods_name;
    self.foodPriceLabel2.text = [NSString stringWithFormat:@"￥%@",_item2.goods_pice];
    [self.foodPicImageView2 setImageWithURL:[NSURL URLWithString:_item2.goods_image] placeholderImage:nil];
    NSArray *temp = [_item2.goods_tag componentsSeparatedByString:@","];
    if (temp.count > 1 && !_collectionType){
        [self.foodView2 customFoodView:[temp[1] integerValue]];
    }
    
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    
    [self.foodView1 roundCornerRadius:5];
    [self.foodView2 roundCornerRadius:5];
    
    self.foodPicImageView1.contentMode = UIViewContentModeScaleToFill;
    self.foodPicImageView2.contentMode = UIViewContentModeScaleToFill;
    
    self.foodDetailButton1.tag = 0;
    self.foodDetailButton2.tag = 1;
    
    [self.foodDetailButton1 addTarget:self action:@selector(onFoodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.foodDetailButton2 addTarget:self action:@selector(onFoodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.foodPriceLabel1.textColor = kBaseOrangeColor;
    self.foodPriceLabel2.textColor = kBaseOrangeColor;
    
    
}

- (void)drawRect:(CGRect)rect
{
    if (_collectionType) {
        self.foodPriceLabel1.hidden = YES;
        self.foodPriceLabel2.hidden = YES;
        self.addFoodButton1.hidden = YES;
        self.addFoodButton2.hidden = YES;
        
        self.readButton1.hidden = NO;
        self.readButton2.hidden = NO;
        self.likeButton1.hidden = NO;
        self.likeButton2.hidden = NO;
        
        [self.readButton1 setTitle:[NSString stringWithFormat:@"   %@",_item1.goods_visit_times] forState:UIControlStateNormal];
        [self.readButton2 setTitle:[NSString stringWithFormat:@"   %@",_item1.goods_visit_times] forState:UIControlStateNormal];
        [self.likeButton1 setTitle:[NSString stringWithFormat:@"   %@",_item1.be_good_num] forState:UIControlStateNormal];
        [self.likeButton2 setTitle:[NSString stringWithFormat:@"   %@",_item1.be_good_num] forState:UIControlStateNormal];
        
        [self.readButton1 customButton:kCustomButtonType_FoodViewTimes];
        [self.readButton2 customButton:kCustomButtonType_FoodViewTimes];
        [self.likeButton1 customButton:kCustomButtonType_foodLike];
        [self.likeButton2 customButton:kCustomButtonType_foodLike];
        
    }
}

- (IBAction)onFoodButtonAction:(id)sender
{
    UIButton *button = sender;
    if (self.onDetailHandler) {
        self.onDetailHandler(button.tag);
    }
}

- (IBAction)onAddFoodButtonActon:(id)sender
{
    UIButton *button = sender;
    if (button == self.addFoodButton1) {
        if (self.onAddFoodHandler) {
            self.onAddFoodHandler(self.item1);
        }
    }
    else{
        if (self.onAddFoodHandler) {
            self.onAddFoodHandler(self.item2);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
