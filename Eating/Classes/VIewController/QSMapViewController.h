//
//  QSMapViewController.h
//  Eating
//
//  Created by System Administrator on 12/11/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>


@class QSMerchantListReturnData;
@interface QSMapViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIView *mapContainView;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@end
