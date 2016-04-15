//
//  QSAPIModel+AddFoodGroud.m
//  Eating
//
//  Created by ysmeng on 14/12/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSAPIModel+AddFoodGroud.h"

@implementation QSAPIModel (AddFoodGroud)

@end

@implementation QSAddFoodGroudReturnData

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        
        //mapping字典
        NSDictionary *mappingDict = @{@"type" : @"type",
                                      @"info" : @"errorInfo",
                                      @"code" : @"errorCode"};
        [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
        
    });
    
    ///返回mapping结果
    return shared_mapping;

}

@end