//
//  QSMerchantIndexCell2.m
//  eating
//
//  Created by MJie on 14-11-8.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSMerchantIndexCell2.h"
#import "QSConfig.h"
#import "UIButton+UI.h"
#import "QSAPIModel+Merchant.h"
#import "NSString+Name.h"
#import "QSAPIModel+Food.h"
#import "UIImageView+AFNetworking.h"
@interface QSMerchantIndexCell2()<UIScrollViewDelegate>

@property (nonatomic, unsafe_unretained) CGFloat intervalx;
@property (nonatomic, unsafe_unretained) CGFloat foodbuttonwidth;
@end

@implementation QSMerchantIndexCell2

- (void)setItem:(QSMerchantDetailData *)item
{
    _item = item;

    self.addressLabel.text = _item.address;
    
    self.foodbuttonwidth = 56;
    self.intervalx = (CGRectGetWidth(self.frame)-self.foodbuttonwidth*4)/5;
    
    [self.pageControl setNumberOfPages:self.item.mar_menu_list.count/4 == 0 ? 1 : self.item.mar_menu_list.count/4];
    
    
    for (int i = 0 ; i < self.item.mar_menu_list.count ; i++) {
        QSFoodDetailData *info = self.item.mar_menu_list[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        
      
        button.frame = CGRectMake(i*self.foodbuttonwidth+(i+1)*self.intervalx+i/4*25, 22, self.foodbuttonwidth, self.foodbuttonwidth);
        [self.foodScrollView addSubview:button];
        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
        [button.layer setBorderWidth:1];
        [button roundButton];
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(onFoodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *temp = [[UIImageView alloc] init];
        
    
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[info.goods_image imageUrl]]];
        
      
        
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

        [temp setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
          
            
            [button setImage:image forState:UIControlStateNormal];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x-10, CGRectGetMaxY(button.frame), self.foodbuttonwidth+20, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kBaseGrayColor;
        label.font = [UIFont systemFontOfSize:9.0];
        label.text = info.goods_name;
        [self.foodScrollView addSubview:label];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    self.foodScrollView.contentSize = CGSizeMake(self.frame.size.width * (self.item.mar_menu_list.count/4 == 0 ? 1 : self.item.mar_menu_list.count/4), self.foodScrollView.frame.size.height);
}

- (void)awakeFromNib {
    
    self.addressLabel.textColor = kBaseGrayColor;
    
    [self.chatButton customButton:kCustomButtonType_ChatToMerchant];
    [self.callButton customButton:kCustomButtonType_CallToMerchant];
    
    [self.chatButton addTarget:self action:@selector(onChatToMerchantButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.callButton addTarget:self action:@selector(onCallToMerchantButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.allButton addTarget:self action:@selector(onAllMerchantButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.pageControl setTintColor:kBaseGreenColor];
    [self.pageControl setCurrentPageIndicatorTintColor:kBaseLightGrayColor];
}

- (IBAction)onChatToMerchantButtonAction:(id)sender
{
    if (self.onChatButtonHandler) {
        self.onChatButtonHandler();
    }
}

- (IBAction)onCallToMerchantButtonAction:(id)sender
{
    if (self.onCallButtonHandler) {
        self.onCallButtonHandler();
    }
}

- (IBAction)onAllMerchantButtonAction:(id)sender
{
    if (self.onAllButtonHandler) {
        self.onAllButtonHandler();
    }
}

- (IBAction)onFoodButtonAction:(id)sender
{
    UIButton *button = sender;
    if (self.onFoodButtonHandler) {
        QSFoodDetailData *info = self.item.mar_menu_list[button.tag];
        self.onFoodButtonHandler(info.goods_id);
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
    [self.pageControl setCurrentPage:scrollView.contentOffset.x/self.frame.size.width];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
