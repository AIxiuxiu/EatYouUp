//
//  QSFoodTagEditViewController.h
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSFoodTagEditViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIScrollView *tagScrollView;

@property (weak, nonatomic) IBOutlet UIButton *handoverButton;

- (IBAction)onHandoverButtonAction:(id)sender;

@end