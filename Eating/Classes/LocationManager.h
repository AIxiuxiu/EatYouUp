//
//  LocationManager.h
//  Eating
//
//  Created by System Administrator on 12/16/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface LocationManager : NSObject<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;


+ (LocationManager *)sharedManager;

- (void)startUpdateUserLocation;

@end
