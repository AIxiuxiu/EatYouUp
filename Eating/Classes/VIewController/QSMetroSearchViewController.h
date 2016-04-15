//
//  QSMetroSearchViewController.h
//  Eating
//
//  Created by System Administrator on 12/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSMetroSearchViewController : QSViewController

@property (weak, nonatomic) IBOutlet UITableView *metroTabelView1;
@property (weak, nonatomic) IBOutlet UITableView *metroTabelView2;

@property (nonatomic, copy) NSString *metroLine;
@property (nonatomic, copy) NSString *metroStation;

@end
