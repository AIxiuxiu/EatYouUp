//
//  QSRecommendFoodListCell.h
//  Eating
//
//  Created by System Administrator on 11/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kRecommendFoodType_RecommendSelect,
    kRecommendFoodType_RecommendShow,
    kRecommendFoodType_TakeoutShow,
    kRecommendFoodType_TakeoutSelect
}kRecommendFoodType;

//@class QSFoodDetailData;
//@class QSTakeoutDetailData;
@interface QSRecommendFoodListCell : UITableViewCell

@property (nonatomic, strong) id item;


@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *foodStatusButton;
@property (strong, nonatomic) UIView *priceView;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UIButton *countButton;
@property (nonatomic, unsafe_unretained) BOOL isSelected;
//@property (nonatomic, unsafe_unretained) BOOL isSoldout;

@property (nonatomic, unsafe_unretained) kRecommendFoodType cellType;


@property (nonatomic, strong) void(^onCheckHandler)(BOOL);
@property (nonatomic, strong) void(^onCountHandler)();

- (IBAction)onCheckBoxButtonAction:(id)sender;

- (IBAction)onCountSelectButtonAction:(id)sender;
@end
