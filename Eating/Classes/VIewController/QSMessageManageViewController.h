//
//  QSMessageManageViewController.h
//  Eating
//
//  Created by System Administrator on 12/5/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

typedef enum
{
    kMessageListType_Merchant,
    kMessageListType_System
    
}kMessageListType;

@interface QSMessageManageViewController : QSViewController

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@property (nonatomic, unsafe_unretained) kMessageListType messageListType;

@property (weak, nonatomic) IBOutlet UIButton *segmentButton1;
@property (weak, nonatomic) IBOutlet UIButton *segmentButton2;

- (IBAction)onSegmentButtonAction:(id)sender;

@end
