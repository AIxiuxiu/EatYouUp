//
//  QSAPIClientBase+Comment.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIClientBase.h"

@class QSCommentListReturnData;
@interface QSAPIClientBase (Comment)

- (void)commentListWithMerchantId:(NSString *)merchant_id
                          success:(void(^)(QSCommentListReturnData *response))success
                             fail:(void(^)(NSError *error))fail;

//$iMerId = isset($aData['merchant_id'])?$aData['merchant_id']:'';//商户id $iUserId = isset($aData['user_id'])?$aData['user_id']:'';//用户id $sContext = isset($aData['context'])?$aData['context']:'';//内容 $fEvaluate = isset($aData['evaluate'])?$aData['evaluate']:'';//评价 $fPer = isset($aData['per'])?$aData['per']:'';//平均价格 $aImageList = isset($aData['image_list'])?$aData['image_list']:'';//图片数组 
- (void)addMerchantCommentWithMerchantId:(NSString *)merchant_id
                                 context:(NSString *)context
                                evaluate:(NSString *)evaluate
                                     per:(NSString *)per
                               imageList:(NSMutableArray *)image_list
                                 success:(void(^)(QSAPIModel *response))success
                                    fail:(void(^)(NSError *error))fail;

@end
