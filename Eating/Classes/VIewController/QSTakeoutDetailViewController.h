//
//  QSTakeoutDetailViewController.h
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"
#import "QSTakeoutOrderListCell.h"

typedef enum
{
    kOrderDetailType_Takeout,
    kOrderDetailType_Book
}kOrderDetailType;

@interface QSTakeoutDetailViewController : QSViewController

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, unsafe_unretained) kTakeoutOrderStatus takeoutStatus;
@property (nonatomic, unsafe_unretained) kBookOrderStatus bookStatus;
@property (nonatomic, unsafe_unretained) kOrderDetailType orderDetailType;

@property (nonatomic,copy) void(^payAgentCallBack)(BOOL flag);

@property (weak, nonatomic) IBOutlet UIScrollView *orderScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *orderSnLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderStatusButton;
@property (weak, nonatomic) IBOutlet UIButton *progressButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIImageView *ellImageView;


@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UIView *dateView;

@property (weak, nonatomic) IBOutlet UILabel *seatItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *addressItemLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;

@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIButton *couponButton;

@property (weak, nonatomic) IBOutlet UIView *payWayView;
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;

@property (weak, nonatomic) IBOutlet UIView *memoView;
@property (weak, nonatomic) IBOutlet UITextField *memoTextField;



@property (weak, nonatomic) IBOutlet UITableView *foodTableView;

- (IBAction)onPayButtonAction:(id)sender;

- (IBAction)onPhoneCallButtonAction:(id)sender;

- (IBAction)onProgressButtonAction:(id)sender;

@end
