//
//  QSMapNavViewController.m
//  Eating
//
//  Created by System Administrator on 12/11/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMapNavViewController.h"
#import "RouteDetailViewController.h"
#import "CommonUtility.h"
#import "LineDashPolyline.h"
#import "CustomAnnotationView.h"
#import "QSAPIModel+Merchant.h"
#import "UserManager.h"
#import "QSAPIModel+User.h"

const NSString *NavigationViewControllerStartTitle       = @"起点";
const NSString *NavigationViewControllerDestinationTitle = @"终点";

#define kCalloutViewMargin          -8

@interface CustomPointAnnotation : MAPointAnnotation

@property (nonatomic, strong) QSMerchantDetailData *item;
@property (nonatomic, unsafe_unretained) NSInteger tag;

@end

@interface MyPointAnnotation : MAPointAnnotation

@property (nonatomic, strong) QSMerchantDetailData *item;
@property (nonatomic, unsafe_unretained) NSInteger tag;

@end

@implementation CustomPointAnnotation




@end

@interface QSMapNavViewController ()<MAMapViewDelegate, AMapSearchDelegate>


@property (nonatomic) AMapSearchType searchType;
@property (nonatomic, strong) AMapRoute *route;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

@property (nonatomic, strong) QSMerchantDetailData *merchantDetailData;


@end

@implementation QSMapNavViewController

#pragma mark - Utility

/* 进入详情页面. */
- (IBAction)detailAction:(id)sender
{
    if (self.route == nil)
    {
        return;
    }
    
    [self gotoDetailForRoute:self.route type:self.searchType];
}

- (void)gotoDetailForRoute:(AMapRoute *)route type:(AMapSearchType)type
{
    RouteDetailViewController *routeDetailViewController = [[RouteDetailViewController alloc] init];
    routeDetailViewController.route      = route;
    routeDetailViewController.searchType = type;
    
    [self.navigationController pushViewController:routeDetailViewController animated:YES];
}

- (void)updateTotal
{
    NSUInteger total = 0;
    
    if (self.route != nil)
    {
        switch (self.searchType)
        {
            case AMapSearchType_NaviDrive   :
            case AMapSearchType_NaviWalking : total = self.route.paths.count;    break;
            case AMapSearchType_NaviBus     : total = self.route.transits.count; break;
            default: total = 0; break;
        }
    }
    
    self.totalCourse = total;
}

- (BOOL)increaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse < self.totalCourse - 1)
    {
        self.currentCourse++;
        
        result = YES;
    }
    
    return result;
}

- (BOOL)decreaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse > 0)
    {
        self.currentCourse--;
        
        result = YES;
    }
    
    return result;
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    NSArray *polylines = nil;
    
    /* 公交导航. */
    if (self.searchType == AMapSearchType_NaviBus)
    {
        polylines = [CommonUtility polylinesForTransit:self.route.transits[self.currentCourse]];
    }
    /* 步行，驾车导航. */
    else
    {
        polylines = [CommonUtility polylinesForPath:self.route.paths[self.currentCourse]];
    }
    
    [self.mapView addOverlays:polylines];
    
    /* 缩放地图使其适应polylines的展示. */
    self.mapView.visibleMapRect = [CommonUtility mapRectForOverlays:polylines];
}

/* 清空地图上的overlay. */
- (void)clear
{
    [self.mapView removeOverlays:self.mapView.overlays];
}

/* 将selectedIndex 转换为响应的AMapSearchType. */
- (AMapSearchType)searchTypeForSelectedIndex:(NSInteger)selectedIndex
{
    AMapSearchType searchType = 0;
    
    switch (selectedIndex)
    {
        case 0: searchType = AMapSearchType_NaviDrive;   break;
        case 1: searchType = AMapSearchType_NaviWalking; break;
        case 2: searchType = AMapSearchType_NaviBus;     break;
        default:NSAssert(NO, @"%s: selectedindex = %ld is invalid for Navigation", __func__, (long)selectedIndex); break;
    }
    
    return searchType;
}


#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        polylineRenderer.lineDashPattern = @[@5, @10];
        
        return polylineRenderer;
    }
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* 导航搜索回调. */
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request
                      response:(AMapNavigationSearchResponse *)response
{
    if (self.searchType != request.searchType)
    {
        return;
    }
    
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    
    [self presentCurrentCourse];
}

#pragma mark - Navigation Search

/* 公交导航搜索. */
- (void)searchNaviBus
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviBus;
    navi.requireExtension = YES;
    navi.city             = @"guangzhou";
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapNavigationSearch:navi];
}

/* 步行导航搜索. */
- (void)searchNaviWalk
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviWalking;
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapNavigationSearch:navi];
}

/* 驾车导航搜索. */
- (void)searchNaviDrive
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviDrive;
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapNavigationSearch:navi];
}

/* 根据searchType来执行响应的导航搜索*/
- (void)SearchNaviWithType:(AMapSearchType)searchType
{
    switch (searchType)
    {
        case AMapSearchType_NaviDrive:
        {
            [self searchNaviDrive];
            
            break;
        }
        case AMapSearchType_NaviWalking:
        {
            [self searchNaviWalk];
            
            break;
        }
        default:AMapSearchType_NaviBus:
        {
            [self searchNaviBus];
            
            break;
        }
    }
}

#pragma mark - Handle Action

/* 切换导航搜索类型. */
- (void)searchTypeAction:(UISegmentedControl *)segmentedControl
{
    self.searchType = [self searchTypeForSelectedIndex:segmentedControl.selectedSegmentIndex];
    
    self.route = nil;
    self.totalCourse   = 0;
    self.currentCourse = 0;
    
    [self clear];
    
    /* 发起导航搜索请求. */
    [self SearchNaviWithType:self.searchType];
}

#pragma mark - 点击不同的交通方式按钮
- (IBAction)onRouteWayButtonAction:(id)sender
{
    UIButton *button = sender;
    self.searchType = [self searchTypeForSelectedIndex:button.tag];
    self.routeWayButton1.enabled = YES;
    self.routeWayButton2.enabled = YES;
    self.routeWayButton3.enabled = YES;
    button.enabled = NO;
    
    self.route = nil;
    self.totalCourse   = 0;
    self.currentCourse = 0;
    
    [self clear];
    
    /* 发起导航搜索请求. */
    [self SearchNaviWithType:self.searchType];
}


/* 进入详情页面. */
- (void)detailAction
{
    if (self.route == nil)
    {
        return;
    }
    
    [self gotoDetailForRoute:self.route type:self.searchType];
}

#pragma mark - Initialization

- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)NavigationViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)NavigationViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.image = [UIImage imageNamed:@"map_userPointIcon.png"];
        
        [self.mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
    
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
{
    self.startCoordinate        = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    [UserManager sharedManager].userData.location = self.startCoordinate;

}

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    //    self.modeSegment.selectedSegmentIndex = mode;
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CustomPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        
        CustomPointAnnotation *customPoint = annotation;
        annotationView.item = customPoint.item;
        annotationView.portrait = [UIImage imageNamed:@"map_merchantPointIcon.png"];

        return annotationView;
    }
    
    return nil;
}


#pragma mark - Action Handle

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint theCenter = self.mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
        __weak QSMapNavViewController *weakSelf = self;
        cusView.onNavButtonHandler = ^(QSMerchantDetailData *response){
            weakSelf.merchantDetailData = response;
            
            weakSelf.destinationCoordinate  = CLLocationCoordinate2DMake([weakSelf.merchantDetailData.latitude doubleValue], [weakSelf.merchantDetailData.longitude doubleValue]);
            
            UIButton *button;
            if (!weakSelf.routeWayButton1.enabled) {
                button = weakSelf.routeWayButton1;
            }
            else if (!weakSelf.routeWayButton2.enabled){
                button = weakSelf.routeWayButton2;
            }
            else if (!weakSelf.routeWayButton3.enabled){
                button = weakSelf.routeWayButton3;
            }
            [weakSelf onRouteWayButtonAction:button];
        };
        
    }
}


- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}


#pragma mark - Life Cycle


- (void)setupUI
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.mapContainView.bounds];
    self.mapView.delegate = self;
    [self.mapContainView addSubview:self.mapView];
    [self addIndexMerchantPoint];
    
}

- (void)addIndexMerchantPoint
{
    for (QSMerchantDetailData *info in self.merchantListReturnData.msg) {
        CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([info.latitude doubleValue], [info.longitude doubleValue]);
        annotation.coordinate = coordinate;
        annotation.title    = info.merchant_name;
        annotation.subtitle = info.address;
        annotation.item = info;
        
        [self.mapView addAnnotation:annotation];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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
