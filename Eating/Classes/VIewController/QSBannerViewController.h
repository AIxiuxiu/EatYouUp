//
//  QSBannerViewController.h
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSBannerViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *imageUrls;

@property (nonatomic, unsafe_unretained) CGRect frame;
@property (nonatomic, unsafe_unretained) NSTimeInterval scrollTime;
@property (nonatomic, unsafe_unretained) BOOL canDrag;

@property (nonatomic, strong) void(^onTapBanner)(NSInteger);
- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images;

- (id)initWithFrame:(CGRect)frame withImageUrls:(NSMutableArray *)urls;

@end
