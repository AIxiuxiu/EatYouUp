//
//  QSRecommendViewController.h
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSRecommendViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *saleQButton;
@property (weak, nonatomic) IBOutlet UIButton *cardQButton;
@property (weak, nonatomic) IBOutlet UILabel *saleQLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardQLabel;

- (IBAction)onSaleQButtonAction:(id)sender;

- (IBAction)onCardQButtonAction:(id)sender;

@end
