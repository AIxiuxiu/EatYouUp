//
//  QSFoodListCell.h
//  eating
//
//  Created by MJie on 14-11-9.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSViewCell.h"

@class QSFoodDetailData;
@interface QSFoodListCell : QSViewCell

@property (nonatomic, strong) QSFoodDetailData *item1;
@property (nonatomic, strong) QSFoodDetailData *item2;

@property (weak, nonatomic) IBOutlet UIView *foodView1;
@property (weak, nonatomic) IBOutlet UIView *foodView2;

@property (weak, nonatomic) IBOutlet UIImageView *foodPicImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *foodPicImageView2;

@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel1;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel2;

@property (weak, nonatomic) IBOutlet UILabel *foodPriceLabel1;
@property (weak, nonatomic) IBOutlet UILabel *foodPriceLabel2;

@property (weak, nonatomic) IBOutlet UIButton *foodDetailButton1;
@property (weak, nonatomic) IBOutlet UIButton *foodDetailButton2;

@property (weak, nonatomic) IBOutlet UIButton *addFoodButton1;
@property (weak, nonatomic) IBOutlet UIButton *addFoodButton2;

@property (nonatomic, unsafe_unretained) BOOL collectionType;
@property (weak, nonatomic) IBOutlet UIButton *readButton1;
@property (weak, nonatomic) IBOutlet UIButton *readButton2;
@property (weak, nonatomic) IBOutlet UIButton *likeButton1;
@property (weak, nonatomic) IBOutlet UIButton *likeButton2;



@property (nonatomic, strong) void(^onDetailHandler)(NSInteger);
@property (nonatomic, strong) void(^onAddFoodHandler)(QSFoodDetailData *);

- (IBAction)onFoodButtonAction:(id)sender;

- (IBAction)onAddFoodButtonActon:(id)sender;

@end
