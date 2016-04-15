//
//  QSAPIModel+Index.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel+Index.h"

@implementation QSAPIModel (Index)

@end


@implementation QSIndexBannerReturnData

+ (RKObjectMapping *)objectMapping {
    
    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"type"]];
        
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"msg" withMapping:[QSIndexBannerDataModel objectMapping]]];
        
    });
    return shared_mapping;
}

@end


@implementation QSIndexBannerDataModel

+ (RKObjectMapping *)objectMapping
{

    static dispatch_once_t pred = 0;
    static RKObjectMapping *shared_mapping = nil;
    
    dispatch_once(&pred, ^{
        shared_mapping = [RKObjectMapping mappingForClass:[self class]];
        [shared_mapping addAttributeMappingsFromArray:@[@"url",@"imageUrl"]];
    });
    return shared_mapping;

}

@end