//
//  LocationManager.m
//  Eating
//
//  Created by System Administrator on 12/16/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "LocationManager.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"
#import "QSConfig.h"
#import "QSTabbarViewController.h"

@implementation LocationManager

+ (LocationManager *)sharedManager
{
    static LocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}

- (id)init
{
    if (self = [super init]) {
        [self setupManager];
    }
    return self;
}

- (void)setupManager
{
    [MAMapServices sharedServices].apiKey =@"69b5d2052ca9ed68091bc553dfb8fb24";
    self.search = [[AMapSearchAPI alloc] initWithSearchKey: @"69b5d2052ca9ed68091bc553dfb8fb24" Delegate:self];
}

- (void)startUpdateUserLocation
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(-10, -10, 1, 1)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
{
    
    QSUserData *userData = [UserManager sharedManager].userData;
    if (!userData) {
        
        userData = [[QSUserData alloc] init];
        
    }
    userData.location = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    
    ///保存用户坐标
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f",userLocation.coordinate.latitude] forKey:@"current_user_latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f",userLocation.coordinate.longitude] forKey:@"current_user_longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UserManager sharedManager].userData = userData;
    self.mapView.showsUserLocation = NO;
    
    [self searchReGeocodeWithCoordinate:userData.location];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserDidUpdateLocationNotification
                                                        object:nil];
    
}

/* 逆地理编码查找 */
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];

}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
 
        [UserManager sharedManager].userData.reGeocodeSearchResponse = response;
        [UserManager sharedManager].userData.adcode = response.regeocode.addressComponent.adcode;
        NSLog(@"%@",[UserManager sharedManager].userData.reGeocodeSearchResponse.regeocode.addressComponent.adcode);
    }
}

@end
