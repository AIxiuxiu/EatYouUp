//
//  QSAPIModel+Food.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAPIModel.h"

@interface QSAPIModel (Food)


@end


@interface QSFoodListReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) NSMutableArray *data;

@end

@class QSFoodDetailData;
@interface QSFoodDetailReturnData : NSObject<QSObjectMapping>

@property (nonatomic, unsafe_unretained) BOOL type;
@property (nonatomic, strong) QSFoodDetailData *data;

@end

@interface QSFoodDetailData : NSObject<QSObjectMapping>

@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_pice;
@property (nonatomic, copy) NSString *goods_real_pice;
@property (nonatomic, copy) NSString *goods_style;
@property (nonatomic, copy) NSString *goods_taste;
@property (nonatomic, copy) NSString *goods_evaluation;
@property (nonatomic, copy) NSString *goods_desc;
@property (nonatomic, copy) NSString *goods_image;
@property (nonatomic, copy) NSString *goods_up_time;
@property (nonatomic, copy) NSString *goods_modify_time;
@property (nonatomic, copy) NSString *goods_comment_num;
@property (nonatomic, copy) NSString *goods_marketing_num;
@property (nonatomic, copy) NSString *goods_visit_times;
@property (nonatomic, copy) NSString *good_num;
@property (nonatomic, copy) NSString *share_times;
@property (nonatomic, copy) NSString *sound_times;
@property (nonatomic, copy) NSString *goods_remain;
@property (nonatomic, copy) NSString *goods_image_list;
@property (nonatomic, copy) NSString *goods_over_time;
@property (nonatomic, copy) NSString *goods_type;
@property (nonatomic, copy) NSString *goods_virtual_gold;
@property (nonatomic, copy) NSString *goods_real_virtual_gold;
@property (nonatomic, copy) NSString *goods_cat;
@property (nonatomic, copy) NSString *goods_tag;
@property (nonatomic, copy) NSString *goods_sounds;
@property (nonatomic, copy) NSString *recommend;
@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *goods_taste_tag;
@property (nonatomic, copy) NSString *goods_sale_type;
@property (nonatomic, copy) NSString *goods_correlate;
@property (nonatomic, copy) NSString *add_user_id;
@property (nonatomic, copy) NSString *use_num;
@property (nonatomic, copy) NSString *varil_begin_time;
@property (nonatomic, copy) NSString *varil_end_time;
@property (nonatomic, copy) NSString *hasCaipu;


@property (nonatomic, copy) NSString *goods_vip_pice;
@property (nonatomic, copy) NSString *goods_v_type;
@property (nonatomic, copy) NSString *t_begin_time;
@property (nonatomic, copy) NSString *t_end_time;
@property (nonatomic, copy) NSString *pri_time_per;
@property (nonatomic, copy) NSString *pri_goods_list;
@property (nonatomic, copy) NSString *pri_goods_per;
@property (nonatomic, copy) NSString *vip_per;
@property (nonatomic, copy) NSString *per_type;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *goods_or_num;
@property (nonatomic, copy) NSString *pri_money;
@property (nonatomic, copy) NSString *pro_list;
@property (nonatomic, copy) NSString *cou_list;
@property (nonatomic, copy) NSString *goods_share_num;
@property (nonatomic, copy) NSString *translate_type;
@property (nonatomic, copy) NSString *sendout_num;
@property (nonatomic, copy) NSString *view_num;
@property (nonatomic, copy) NSString *translation_num;
@property (nonatomic, copy) NSString *be_good_num;
@property (nonatomic, copy) NSString *be_book_num;
@property (nonatomic, copy) NSString *marketing;
@property (nonatomic, strong) NSMutableArray *connection_menu;
@property (nonatomic, strong) NSMutableArray *msg;
@property (nonatomic, copy) NSString *num;

///////本地购物车中商品数量
@property (nonatomic, unsafe_unretained) int localAmount;


///////本地购物车中商品数量
@end

//@interface QSFoodConnection : NSObject<>
//
//@end
