//
//  QSAPIClientBase+Others.h
//  Eating
//
//  Created by System Administrator on 12/4/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@interface QSAPIClientBase (Others)


- (void)getMerchantSounds:(NSString *)urlStr
                  success:(void(^)(NSData *response))success
                     fail:(void(^)(NSError *error))fail;



@end
