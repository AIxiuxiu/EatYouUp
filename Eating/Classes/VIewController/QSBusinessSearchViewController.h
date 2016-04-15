//
//  QSBusinessSearchViewController.h
//  Eating
//
//  Created by System Administrator on 12/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSBusinessSearchViewController : QSViewController

@property (nonatomic, copy) NSString *county;
@property (nonatomic, copy) NSString *bussiness;

@property (weak, nonatomic) IBOutlet UITableView *bussinessTabelView1;
@property (weak, nonatomic) IBOutlet UITableView *bussinessTabelView2;

@end
