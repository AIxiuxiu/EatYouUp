//
//  QSVolumeTypeView.m
//  Eating
//
//  Created by ysmeng on 14/11/29.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSVolumeTypeView.h"
//#import "QSBlockActionButton.h"
#import "QSConfig.h"

//使用tag值记录行数
#define TAG_VOLUMETYPE_SELECTED_ROOT 200

@interface QSVolumeTypeView (){
    
    NSMutableArray *_volumeTypeSource;  //优惠卷类型数据
    NSMutableArray *_selectedIndexArray;//!<当前选择状态的下标项数组
    
}

@end

@implementation QSVolumeTypeView

//加载显示
#pragma mark - 显示优惠卷类型选择窗口
+ (void)showVolumeTypeView:(UIView *)targetView andSelectedArray:(NSArray *)tempArray andCallBack:(void(^)(NSDictionary *filterDict))callBack
{
    QSVolumeTypeView *view = [[QSVolumeTypeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, targetView.frame.size.width, targetView.frame.size.height) andSelectedArray:tempArray andCallBack:callBack];
    view.alpha = 0.0f;
    
    //加载到目标视图
    [targetView addSubview:view];
    
    //动画显示
    [UIView animateWithDuration:0.3 animations:^{
        
        view.alpha = 1.0f;
        
    }];
}

//*******************************
//             UI搭建/初始化
//*******************************
#pragma mark - UI搭建/初始化
- (instancetype)initWithFrame:(CGRect)frame andSelectedArray:(NSArray *)tempArray andCallBack:(void(^)(NSDictionary *filterData))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        //数组初始化
        _volumeTypeSource = [[NSMutableArray alloc] initWithCapacity:5];
        
        //保存回调
        if (callBack) {
            
            self.callBack = callBack;
            
        }
        
        ///保存选择状态的下标数据
        _selectedIndexArray = [[NSMutableArray alloc] init];
        if (tempArray) {
            [_selectedIndexArray addObjectsFromArray:tempArray];
        }
        
        ///创建UI
        [self createVolumeTypeUI];
        
        ///添加手势：点击时从父视图移除
        [self addSingleTapGesture];
    }
    
    return self;
}

- (void)createVolumeTypeUI
{
    //背景颜色
    self.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5f];
    
    //底view:15 + 30 45 * 6
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-240.0f)/2.0f, 110.0f, 240.0f, 314.0f)];
    rootView.layer.cornerRadius = 12.0f;
    rootView.backgroundColor = [UIColor whiteColor];
    [self addSubview:rootView];
    //添加单击手势，点击底view时不影响事件
    [self addSingleTapGesture:rootView];
    
    //添加筛选按钮
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(10.0f, rootView.frame.size.height-37.0f, rootView.frame.size.width-20.0f, 30.0f);
    [filterButton addTarget:self action:@selector(filterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterButton setTitleColor:kBaseOrangeColor forState:UIControlStateHighlighted];
    filterButton.backgroundColor = kBaseOrangeColor;
    filterButton.layer.cornerRadius = filterButton.frame.size.height/2.0f;
    filterButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [rootView addSubview:filterButton];
    
    //类型选择窗口:TAG_VOLUMETYPE_SELECTED_ROOT
    NSArray *typeList = [self getVolumeTypeList];
    
    //根据类型的个数创建不同的view
    if ([typeList count] > 6) {
        [self createTypeScrollView:typeList andView:rootView];
    } else {
        [self createVolumeTypeButton:typeList andView:rootView];
    }
}

//如果过多的类型，则创建scrollView
- (void)createTypeScrollView:(NSArray *)typeList andView:(UIView *)view
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height-44.0f)];
    [view addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    //加载滚动
    scrollView.contentSize = CGSizeMake(view.frame.size.width, 45.0f * [typeList count]+10.0f);
    
    //加载按钮
    [self createVolumeTypeButton:typeList andView:scrollView];
}

//创建类型按钮
- (void)createVolumeTypeButton:(NSArray *)typeList andView:(UIView *)view
{
    for (int i = 0; i < [typeList count]; i++) {
        //类型
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 15.0f+(15.0f+15.0f+15.0f)*i, 80.0f, 15.0f)];
        typeLabel.font = [UIFont systemFontOfSize:14.0f];
        typeLabel.textColor = kBaseGrayColor;
        [view addSubview:typeLabel];
        typeLabel.text = typeList[i];
        
        //开关
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(view.frame.size.width-60.0f, 7.5f+(30.0f+15.0f)*i, 50.0f, 30.0f)];
        [switchView addTarget:self action:@selector(volumeTypeSwitchAction:) forControlEvents:UIControlEventValueChanged];
        switchView.tag = TAG_VOLUMETYPE_SELECTED_ROOT + i;
        [view addSubview:switchView];
        
        ///判断是否需要选择状态
        for (NSString *obj in _selectedIndexArray) {
            
            if ((i + 1) == [obj intValue]) {
                
                [switchView setOn:YES animated:NO];
                
            }
            
        }
        
        //分隔线
        UILabel *sepLine = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 44.0f+45.0f*i, view.frame.size.width-20.0f, 1.0f)];
        sepLine.backgroundColor = kBaseLightGrayColor;
        [view addSubview:sepLine];
    }
}

//获取类型数据
- (NSArray *)getVolumeTypeList
{
    [_volumeTypeSource removeAllObjects];
    [_volumeTypeSource addObjectsFromArray:@[@"限时优惠",@"菜品优惠",@"会员优惠",@"代金卷",@"折扣卷",@"兑换卷"]];
    return _volumeTypeSource;
}

#pragma mark - 点击筛选按钮
- (void)filterButtonAction:(UIButton *)button
{
    ///回调
    if (self.callBack && (0 < [_selectedIndexArray count])) {
        
        self.callBack(@{@"type":_selectedIndexArray});
        
    }
    
    ///移除
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - 点击其他地方时退出
- (void)addSingleTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapGestureAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    if (self.callBack) {
        self.callBack(nil);
    }
}

- (void)addSingleTapGesture:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subViewTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tap];
}

- (void)subViewTapAction:(UITapGestureRecognizer *)tap
{
    
}

- (void)selfTapGestureAction:(UITapGestureRecognizer *)tap
{
    //移除
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - 选择不同的类型时保存参数
- (void)volumeTypeSwitchAction:(UISwitch *)switchView
{
    
    if (switchView.isOn) {
        
        NSString *tempType = [NSString stringWithFormat:@"%d",(int)(switchView.tag - TAG_VOLUMETYPE_SELECTED_ROOT + 1)];
        
        for (NSString *obj in _selectedIndexArray) {
            
            if ([tempType isEqualToString:obj]) {
                return;
            }
            
        }
        
        [_selectedIndexArray addObject:tempType];
        
    } else {
    
        [_selectedIndexArray removeObject:[NSString stringWithFormat:@"%d",(int)(switchView.tag - TAG_VOLUMETYPE_SELECTED_ROOT + 1)]];
    
    }
    
}

@end
