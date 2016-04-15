//
//  QSBindMobileViewController.h
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSPhoneVerification;
@interface QSBindMobileViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIView *bindView;
@property (weak, nonatomic) IBOutlet UIView *bindmobileView;
@property (weak, nonatomic) IBOutlet UITextField *bindmobileTextField;
@property (nonatomic, strong) QSPhoneVerification *bindverButton;
@property (weak, nonatomic) IBOutlet UIView *bindverView;
@property (weak, nonatomic) IBOutlet UITextField *bindverTextField;
@property (weak, nonatomic) IBOutlet UIButton *bindconfirmButton;

@property (weak, nonatomic) IBOutlet UIView *exchangeView;
@property (weak, nonatomic) IBOutlet UIView *exchangemobile1View;
@property (weak, nonatomic) IBOutlet UITextField *exchangemobile1TextField;
@property (weak, nonatomic) IBOutlet UIView *exchangemobile2View;
@property (weak, nonatomic) IBOutlet UITextField *exchangemobile2TextField;
@property (nonatomic, strong) QSPhoneVerification *exchangemobile2verButton;
@property (weak, nonatomic) IBOutlet UIView *exchangeverView;
@property (weak, nonatomic) IBOutlet UITextField *exchangeverTextField;
@property (weak, nonatomic) IBOutlet UIButton *exchangeconfirmButton;


- (IBAction)onVerButtonAction:(id)sender;

- (IBAction)onConfirmButtonAction:(id)sender;

- (IBAction)onSwButtonAction:(id)sender;

@end
