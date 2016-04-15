//
//  UserManager.h
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class QSUserData;
@class QSFoodDetailData;
@class QSMerchantIndexReturnData;
@class AVAudioPlayer;
@interface UserManager : NSObject

+ (UserManager *)sharedManager;

@property (nonatomic, strong) QSUserData *userData;//!<用户数据
@property (nonatomic, strong) NSMutableDictionary *carlist;
@property (nonatomic, strong) QSMerchantIndexReturnData *merchantIndexReturnData;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, copy) NSString *playerUrlStr;
@property (nonatomic, strong) NSArray *countyArray;
@property (nonatomic, strong) NSArray *countyCodeArray;
@property (nonatomic, strong) NSArray *searchCategoryArray;
@property (nonatomic, strong) NSArray *searchCategoryCodeArray;
@property (nonatomic, strong) NSArray *metroCategoryArray;
@property (nonatomic, strong) NSArray *metroCategoryCodeArray;
@property (nonatomic, strong) NSArray *tradeStatusArray;

- (BOOL)addFoodToLocalCart:(QSFoodDetailData *)item;

- (NSString *)carOriginTotalMoney;

- (NSString *)carFoodNum;

- (void)playMerchantSound:(NSString *)urlStr;

- (void)stopMerchantSound:(NSString *)urlStr;

+(void)Speaking:(NSString*)word
       tranType:(NSString*)tranType
        success:(void (^)(NSData *))success
           fail:(void (^)(NSError *))fail;

- (NSString *)distanceBetweenTwoPoint:(CLLocationCoordinate2D)coordinate1 andPoint2:(CLLocationCoordinate2D)coordinate2;

@end
