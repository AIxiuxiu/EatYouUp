//
//  QSRetrivePasswordViewController
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSRetrivePasswordViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIView *mobileContainView;
@property (weak, nonatomic) IBOutlet UIView *verifyContainView;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

//@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIButton *handoverButton;

- (IBAction)onVerifyButtonAction:(id)sender;

- (IBAction)onHandoverButtonAction:(id)sender;

@end
