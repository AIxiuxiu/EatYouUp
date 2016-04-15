//
//  QSIndexCell1.m
//  eating
//
//  Created by System Administrator on 11/7/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSIndexCell1.h"
#import "QSBannerViewController.h"
#import "QSAPIModel+Index.h"
#import "NSString+Name.h"
#import "XLCycleScrollView.h"
#import "QSConfig.h"
#import <UIImageView+AFNetworking.h>

@interface QSIndexCell1()<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>

@property (nonatomic, strong) QSBannerViewController *advertisementView;
@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, strong) XLCycleScrollView *slcycleView;

@end

@implementation QSIndexCell1

///重置广告对象数组
- (NSMutableArray *)imageUrls
{
    if (!_imageUrls && _indexBannerReturnData) {
        
        _imageUrls = [[NSMutableArray alloc] init];
        
        for (QSIndexBannerDataModel *info in _indexBannerReturnData.msg) {
            
            [_imageUrls addObject:info];
            
        }
        
    }

    return _imageUrls;
}

- (void)setIndexBannerReturnData:(QSIndexBannerReturnData *)indexBannerReturnData
{
    _indexBannerReturnData = indexBannerReturnData;
    
    [self.slcycleView reloadData];
}

///返回行高
- (CGFloat)cellHeight
{
    return 203;
}

- (void)awakeFromNib {
    
    self.slcycleView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, [self cellHeight])];
    self.slcycleView.delegate = self;
    self.slcycleView.datasource = self;
    self.slcycleView.userInteractionEnabled = YES;
    [self addSubview:self.slcycleView];
   
}




///返回一共有多少个广告页
- (NSInteger)numberOfPages
{
    return self.imageUrls.count;
}

///返回当前下标的图片视图
#pragma mark - 返回当前下标的广告view
- (UIView *)pageAtIndex:(NSInteger)index
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.slcycleView.bounds];
    NSString *url = ((QSIndexBannerDataModel *)self.imageUrls[index]).imageUrl;
    [imageView setImageWithURL:[NSURL URLWithString:[url imageUrl]] placeholderImage:nil];
    imageView.userInteractionEnabled = YES;
    
    return imageView;
    
}

///点击每一个广告图片时，回调
#pragma mark - 点击广告图片
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
    
    ///回调进入活动详情
    if (self.callBack) {
        
        self.callBack(YES,((QSIndexBannerDataModel *)self.imageUrls[index]).url);
        
    }
    
}

@end
