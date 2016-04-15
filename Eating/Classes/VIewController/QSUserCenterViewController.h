//
//  QSUserCenterViewController.h
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSUserCenterViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIScrollView *userScrollowView;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIImageView *starbgImageView;

@property (weak, nonatomic) IBOutlet UIButton *orderButton1;
@property (weak, nonatomic) IBOutlet UIButton *orderButton2;
@property (weak, nonatomic) IBOutlet UIButton *orderButton3;
@property (weak, nonatomic) IBOutlet UIButton *orderButton4;



- (IBAction)onEditButtonAction:(id)sender;

- (IBAction)onMessageButtonAction:(id)sender;

- (IBAction)onCameraButtonAction:(id)sender;

- (IBAction)onOrderButtonAction:(id)sender;

//-(UIImage*)getSubImage:(CGRect)rect;
@end
