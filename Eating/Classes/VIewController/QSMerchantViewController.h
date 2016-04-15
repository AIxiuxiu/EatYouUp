//
//  QSMerchantViewController.h
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSMerchantViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIButton *sortButton1;
@property (weak, nonatomic) IBOutlet UIButton *sortButton2;
@property (weak, nonatomic) IBOutlet UIButton *sortButton3;
@property (weak, nonatomic) IBOutlet UIButton *sortButton4;

@property (weak, nonatomic) IBOutlet UIButton *segmentButton1;
@property (weak, nonatomic) IBOutlet UIButton *segmentButton2;

@property (weak, nonatomic) IBOutlet UITableView *merchantTableView;

@property (nonatomic, copy) NSString *searchWord;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *flavor;
@property (nonatomic, copy) NSString *coupon;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *metro;
@property (nonatomic, copy) NSString *bussiness;
@property (nonatomic, copy) NSString *mertag;

@property (nonatomic, unsafe_unretained) BOOL showTakeoutList;

@property (nonatomic, unsafe_unretained) BOOL showBackButton;

- (IBAction)onSegmentButtonAction:(id)sender;

- (IBAction)onFilterButtonAction:(id)sender;
@end
