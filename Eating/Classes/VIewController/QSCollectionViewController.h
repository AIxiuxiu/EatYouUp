//
//  QSCollectionViewController.h
//  Eating
//
//  Created by System Administrator on 12/13/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSCollectionViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIButton *segmentButton1;
@property (weak, nonatomic) IBOutlet UIButton *segmentButton2;

@property (weak, nonatomic) IBOutlet UITableView *collectionTableView;

- (IBAction)onSegmentButtonAction:(id)sender;

@end
