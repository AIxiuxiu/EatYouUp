//
//  UserManager.m
//  eating
//
//  Created by System Administrator on 11/6/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "UserManager.h"
#import "QSAPIModel+Food.h"
#import "QSAPIClientBase+Others.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+Name.h"
#import <MAMapKit/MAGeometry.h>
#import <CoreLocation/CLLocation.h>
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"


@implementation UserManager

+ (UserManager *)sharedManager {
    
    static dispatch_once_t pred = 0;
    static UserManager *shared_manager = nil;
    
    dispatch_once(&pred, ^{
        
        shared_manager = [[self alloc] init];
        [shared_manager initMethod];
        
    });
    
    return shared_manager;
    
}

- (NSArray *)countyArray
{
    
    return @[@"市辖区",@"东山区",@"荔湾区",@"越秀区",@"海珠区",@"天河区",@"芳村区",@"白云区",@"黄埔区",@"番禺区",@"花都区",@"增城市",@"从化市",@"萝岗区"];
    
}

- (NSArray *)countyCodeArray
{
    return @[@"440101",@"440102",@"440103",@"440104",@"440105",@"440106",@"440107",@"440111",@"440112",@"440113",@"440114",@"440183",@"440184",@"440190"];
}

- (NSArray *)searchCategoryArray
{
    return @[@"全部",@"粤菜",@"西餐",@"日本料理",@"自助餐",@"东南亚菜",@"小吃",@"韩国料理",@"川菜",@"火锅",@"面包甜点",@"湘菜",@"东北菜",@"清真菜",@"茶餐厅",@"烧烤",@"新疆菜",@"其他"];
}

- (NSArray *)searchCategoryCodeArray
{
    return @[@"0",@"3",@"20",@"36",@"13",@"19",@"14",@"18",@"1",@"12",@"21",@"2",@"9",@"10",@"22",@"40",@"11",@"其他"];
}

- (NSArray *)metroCategoryArray
{
    return @[@"1号线",@"2号线",@"3号线",@"4号线",@"5号线",@"6号线",@"7号线",@"8号线",@"APM线",@"广佛线"];
}

- (NSArray *)metroCategoryCodeArray
{
    return @[@"440201",@"440202",@"440203",@"440204",@"440205",@"440206",@"440207",@"440208",@"440210",@"440209"];
}

- (NSArray *)tradeStatusArray
{
    
    //    0 默认
    //    1 交易成功
    //    2 等待付款
    //    3
    //    4 申请成功
    //    5 交易关闭
    //    6
    //    7 退款中
    return @[@"默认",@"交易成功",@"等待付款",@"",@"购买成功",@"交易关闭",@"",@"退款中"];
    
}

- (void)initMethod
{
    self.carlist = [[NSMutableDictionary alloc] init];
}

- (NSString *)carOriginTotalMoney
{

    CGFloat price = 0.0f;
    for (QSFoodDetailData *obj in [self.carlist allValues]) {
        
        price += (obj.localAmount * [obj.goods_pice floatValue]);
        
    }
    
    return [NSString stringWithFormat:@"%.2f",price];

}

- (BOOL)addFoodToLocalCart:(QSFoodDetailData *)item
{
    
    QSFoodDetailData *info = [self.carlist objectForKey:item.goods_id];
    if (info) {
        
        info.localAmount++;
        [self.carlist setValue:info forKey:info.goods_id];
        return YES;
        
    } else {
        
        item.localAmount = 1;
        [self.carlist setValue:item forKey:item.goods_id];
        return NO;
        
    }
    
}

- (NSString *)carFoodNum
{
    
    NSInteger count = 0;
    for (QSFoodDetailData *info in [self.carlist allValues]) {
        count += info.localAmount;
    }
    
    return [NSString stringWithFormat:@"%d",(int)count];
    
}

- (void)playMerchantSound:(NSString *)urlStr
{
    
    if ([self.playerUrlStr isEqualToString:urlStr]) {
        
        self.playerUrlStr = @"";
        [self stopMerchantSound:urlStr];
        return;
        
    }
    
    __weak UserManager *weakSelf = self;
    __block BOOL isSucc;
    [[QSAPIClientBase sharedClient] getMerchantSounds:urlStr
                                              success:^(NSData *response) {
                                                  weakSelf.playerUrlStr = urlStr;
                                                  weakSelf.player = [[AVAudioPlayer alloc] initWithData:response error:nil];
                                                  [weakSelf.player prepareToPlay];
                                                  [weakSelf.player setVolume:1];
                                                  [weakSelf.player play];
                                                  
                                                  isSucc = [weakSelf.player isPlaying];
                                                  
                                              } fail:^(NSError *error) {
                                                  
                                                  isSucc = NO;
                                              }];
}

- (void)stopMerchantSound:(NSString *)urlStr
{
    
    [self.player stop];
    
}


- (NSString *)distanceBetweenTwoPoint:(CLLocationCoordinate2D)coordinate1 andPoint2:(CLLocationCoordinate2D)coordinate2
{
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(coordinate1.latitude,coordinate1.longitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(coordinate2.latitude ,coordinate2.longitude));
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    
    NSString *str = @"";
    if(distance < 1000){
        str = [NSString stringWithFormat:@"%.0fm",distance];
    }else{
        double dis = distance/1000;
        str = [NSString stringWithFormat:@"%.0fkm",dis];
    }
    return str;
}

+(NSString *)BaiduUrl:(NSString*)str tranType:(NSString*)tranType
{
    
    return [NSString stringWithFormat:@"http://openapi.baidu.com/public/2.0/bmt/translate?client_id=BfnGKPOwrahE5u5YUHCoA74k&q=%@&from=zh&to=%@",[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],tranType];
    
}


+(void)Speaking:(NSString*)word tranType:(NSString *)tranType
        success:(void (^)(NSData *response))success
           fail:(void (^)(NSError *error))fail
{
    
    NSString *type = nil;
    if ([tranType isEqualToString:@"1"]) {
        type = @"kor";
    }else if([tranType isEqualToString:@"2"]){
        type = @"jp";
    }else if([tranType isEqualToString:@"3"]){
        type = @"en";
    }
    
    [[QSAPIClientBase sharedClient] translateWithUrl:[UserManager BaiduUrl:word tranType:type] type:type success:^(NSData *response) {
        
        if (success) {
            success(response);
        }
        

    } fail:^(NSError *error) {
        
        NSLog(@"翻译失败");
        
    }];
    

}


@end
