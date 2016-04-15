//
//  QSTakeoutOrderListCell.h
//  Eating
//
//  Created by System Administrator on 11/18/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//待付款
//送餐中
//已签收
//已取消
typedef enum
{
    
    kTakeoutOrderStatus_Delect = -1,        //!<已删除
    kTakeoutOrderStatus_Pay = 0,            //!<已支付/待确认
    kTakeoutOrderStatus_UnDelivered = 1,    //!<未安排送餐
    kTakeoutOrderStatus_Delivered = 2,      //!<已送餐，待确认
    kTakeoutOrderStatus_Confirm = 3,        //!<客户已确认
    kTakeoutOrderStatus_Cancelled = 4,      //!<已取消
    kTakeoutOrderStatus_Unpay = 9           //!<待付款
    
}kTakeoutOrderStatus;


typedef enum
{
    
    kBookOrderStatus_UnConfirm = 0,
    kBookOrderStatus_Inqueue,
    kBookOrderStatus_Confirmed,
    kBookOrderStatus_Inshop,
    kBookOrderStatus_ClientCanceled,
    kBookOrderStatus_RestCanceled,
    kBookOrderStatus_Booking,
    
}kBookOrderStatus;


@interface QSTakeoutOrderListCell : UITableViewCell

@property (nonatomic, strong) id item;

@property (nonatomic, unsafe_unretained) kTakeoutOrderStatus takeoutStatus;
@property (nonatomic, unsafe_unretained) kBookOrderStatus bookStatus;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) UIView *countView;

@end
