//
//  QSAPIModel.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@implementation QSAPIModel

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type",@"msg",@"info",@"code"]];
    });
    
    return shared_mapping;
}

@end

@implementation QSAPIModelString

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type",@"msg",@"code"]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end

@implementation QSAPITokenModel

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type",@"info",@"code",@"msg"]];
    });
    
    return shared_mapping;
    
}

@end

@implementation QSAPIModelDict

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type",@"msg"]];
    });
    NSLog(@"%@",shared_mapping);
    return shared_mapping;
}

@end

@implementation QSAPIBaseInfoModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"type" : @"flag",
                                      @"info" : @"errorInfo",
                                      @"code" : @"errorCode"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;
    
}

@end


@implementation QSAPIModelDictddd

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type",@"msg"]];
    });
    
    return shared_mapping;
}

@end