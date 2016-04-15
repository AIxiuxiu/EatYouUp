//
//  QSTakeoutOrderListViewController.h
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

typedef enum
{
    kOrderListType_Book,
    kOrderListType_Takeout

}kOrderListType;

@interface QSTakeoutOrderListViewController : QSViewController

@property (nonatomic, copy) NSString *merchant_id;

@property (weak, nonatomic) IBOutlet UITableView *orderTableView;

@property (nonatomic, unsafe_unretained) kOrderListType orderListType;
@property (nonatomic, unsafe_unretained) NSInteger orderType;
@property (weak, nonatomic) IBOutlet UIButton *segmentButton1;
@property (weak, nonatomic) IBOutlet UIButton *segmentButton2;

- (IBAction)onSegmentButtonAction:(id)sender;

@end
