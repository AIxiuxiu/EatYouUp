//
//  QSMapViewController.m
//  Eating
//
//  Created by System Administrator on 12/11/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMapViewController.h"




@interface QSMapViewController ()



@end

@implementation QSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)setupUI
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];

    [self updateUserLoaction];
}

- (void)updateUserLoaction
{
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    [self.mapView setZoomLevel:16.1 animated:YES];
}





#pragma mark - MAMapViewDelegate

- (void)returnAction
{
    [self clearMapView];
    
    [self clearSearch];
    
    self.mapView.userTrackingMode  = MAUserTrackingModeNone;
}

- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

- (void)clearSearch
{
    self.search.delegate = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
