//
//  QSMapNavViewController.h
//  Eating
//
//  Created by System Administrator on 12/11/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMapViewController.h"

@class QSMerchantDetailData;
@interface QSMapNavViewController : QSMapViewController

@property (weak, nonatomic) IBOutlet UIView *mapContainView;

@property (weak, nonatomic) IBOutlet UIButton *routeWayButton1;
@property (weak, nonatomic) IBOutlet UIButton *routeWayButton2;
@property (weak, nonatomic) IBOutlet UIButton *routeWayButton3;

@property (nonatomic, strong) QSMerchantListReturnData *merchantListReturnData;

- (IBAction)onRouteWayButtonAction:(id)sender;

@end
