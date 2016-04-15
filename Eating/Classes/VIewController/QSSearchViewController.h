//
//  QSSearchViewController.h
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSSearchViewController : QSViewController

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIView *areaView;

@property (weak, nonatomic) IBOutlet UIButton *typeSearchButton1;
@property (weak, nonatomic) IBOutlet UIButton *typeSearchButton2;
@property (weak, nonatomic) IBOutlet UIButton *typeSearchButton3;
@property (weak, nonatomic) IBOutlet UIButton *typeSearchButton4;

- (IBAction)onTypeSearchButtonAction:(id)sender;

@end
