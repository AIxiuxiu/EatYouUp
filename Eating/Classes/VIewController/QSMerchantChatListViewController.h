//
//  QSMerchantChatListViewController.h
//  Eating
//
//  Created by System Administrator on 12/17/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@class QSMerchantDetailData;
@interface QSMerchantChatListViewController : QSViewController

@property (nonatomic, strong) QSMerchantDetailData *merchantDetailData;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

- (IBAction)onSendButtonAction:(id)sender;

@end
