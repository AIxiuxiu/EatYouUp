//
//  QSYMemberIconlistView.m
//  Eating
//
//  Created by ysmeng on 14/12/18.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSYMemberIconlistView.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Name.h"
#import "UIView+UI.h"
#import "QSAPIModel+FoodGroud.h"

@implementation QSYMemberIconlistView

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///添加底可滚动的scrollView
        [self createMembersIconListUI];
        
    }
    
    return self;

}

- (void)createMembersIconListUI
{

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    [self addSubview:scrollView];

}

/**
 *  @author         yangshengmeng, 14-12-18 10:12:34
 *
 *  @brief          根据给定的成员数组，更新团员信息头像
 *
 *  @param array    成员数据数组
 *
 *  @since          2.0
 */
#pragma mark - 根据给定的成员数组，更新团员信息头像
- (void)updateMembersIconListWithArray:(NSArray *)array
{

    UIScrollView *scrollView = [self subviews][0];
    
    ///先清空原来的数据
    for (UIView *obj in [scrollView subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    ///再添加
    CGFloat xpoint = 0.0f;
    for (int i = 0; i < [array count]; i++) {
        
        ///获取model
        QSYFoodGroudMemberDataModel *model = array[i];
        
        ///头像的底view
        UIImageView *iconAboveView = [[UIImageView alloc] initWithFrame:CGRectMake(xpoint, 0.0f, scrollView.frame.size.height, scrollView.frame.size.height)];
        iconAboveView.backgroundColor = [UIColor colorWithRed:266.0f/255.0f green:266.0f/255.0f blue:266.0f/255.0f alpha:1.0];
        [iconAboveView roundView];
        [scrollView addSubview:iconAboveView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5f, 2.5f, iconAboveView.frame.size.width-5.0f, iconAboveView.frame.size.height-5.0f)];
        [imageView roundView];
        [imageView setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:nil];
        
        ///将头像添加到底view上
        [iconAboveView addSubview:imageView];
        
        ///重置xpoint
        xpoint += (scrollView.frame.size.height + 5.0f);
        
    }
    
    ///判断是否需要滚动
    if (xpoint > scrollView.frame.size.width-scrollView.frame.size.height-5.0f) {
        
        scrollView.contentSize = CGSizeMake(xpoint, scrollView.frame.size.height);
        
    }

}

@end
