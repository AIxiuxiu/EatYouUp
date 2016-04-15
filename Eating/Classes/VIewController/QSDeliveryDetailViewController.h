//
//  QSDeliveryDetailViewController.h
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSDeliveryDetailData;
@interface QSDeliveryDetailViewController : QSViewController

@property (nonatomic, strong) QSDeliveryDetailData *item;

@property (weak, nonatomic) IBOutlet UIScrollView *deliveryScrollView;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UIButton *countyButton;

@property (weak, nonatomic) IBOutlet UIButton *setDefaultButton;


- (IBAction)onSetDefaultButtonAction:(id)sender;

- (IBAction)onConfirmButtonAction:(id)sender;

- (IBAction)onAreaButtonAction:(id)sender;
@end
