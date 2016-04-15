//
//  QSRankSearchViewController.h
//  Eating
//
//  Created by System Administrator on 12/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSRankSearchViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIButton *segmentButton1;
@property (weak, nonatomic) IBOutlet UIButton *segmentButton2;
@property (weak, nonatomic) IBOutlet UIButton *segmentButton3;

@property (weak, nonatomic) IBOutlet UITableView *merchantTableView;

@property (nonatomic, copy) NSString *searchWord;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *flavor;
@property (nonatomic, copy) NSString *coupon;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *metro;
@property (nonatomic, copy) NSString *bussiness;
@property (nonatomic, copy) NSString *mertag;

- (IBAction)onSegmentButtonAction:(id)sender;

@end
