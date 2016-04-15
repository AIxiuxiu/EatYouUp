//
//  QSAPIModel+Index.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (Index)

@end

@interface QSIndexBannerReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *msg;

@end

@interface QSIndexBannerDataModel : NSObject<QSObjectMapping>

@property (nonatomic,copy) NSString *url;       //!<活动详情地址
@property (nonatomic,copy) NSString *imageUrl;  //!<图片地址

@end
