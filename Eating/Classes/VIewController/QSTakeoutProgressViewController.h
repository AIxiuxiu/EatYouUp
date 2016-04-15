//
//  QSTakeoutProgressViewController.h
//  Eating
//
//  Created by System Administrator on 12/1/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSTakeoutDetailData;
@interface QSTakeoutProgressViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIButton *pointButton;
@property (weak, nonatomic) IBOutlet UIButton *pointButton1;
@property (weak, nonatomic) IBOutlet UIButton *pointButton2;
@property (weak, nonatomic) IBOutlet UIButton *pointButton3;
@property (weak, nonatomic) IBOutlet UIButton *pointButton4;

@property (weak, nonatomic) IBOutlet UIImageView *portButton1;
@property (weak, nonatomic) IBOutlet UIImageView *portButton2;
@property (weak, nonatomic) IBOutlet UIImageView *portButton3;
@property (weak, nonatomic) IBOutlet UIImageView *portButton4;

@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel1;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel2;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel3;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel4;

@property (weak, nonatomic) IBOutlet UILabel *statusTimeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *statusTimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *statusTimeLabel3;
@property (weak, nonatomic) IBOutlet UILabel *statusTimeLabel4;

@property (nonatomic, strong) QSTakeoutDetailData *item;

@end
