//
//  QSFoodCommentListCell.m
//  Eating
//
//  Created by MJie on 14-11-11.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSFoodCommentListCell.h"
#import "QSAPIModel+Comment.h"
#import "QSConfig.h"
#import "QSStarViewController.h"
#import <UIImageView+AFNetworking.h>

@interface QSFoodCommentListCell()

@property (nonatomic, strong) UIView *starView;

@end

@implementation QSFoodCommentListCell

- (void)setItem:(QSCommentDetailData *)item
{
    _item = item;
    self.nameLabel.text = _item.user_name;
    
    [self.portraitImageView roundView];
    [self.portraitImageView setImageWithURL:[NSURL URLWithString:[_item.user_link imageUrl]] placeholderImage:nil];
    
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_item.article_time doubleValue]];
    self.dateLabel.text = [fm stringFromDate:date];
    
    
    self.starView = [QSStarViewController cellStarView:[_item.evaluate integerValue]/2 showPointLabal:NO];

    [self.contentView addSubview:self.starView];
    
    self.consumeLabel.text = [NSString stringWithFormat:@"人均:￥%@",_item.per];
    
    self.commentLabel.text = _item.conment;
    

    
    [self setNeedsDisplay];
}

+ (CGFloat)cellHeight:(QSCommentDetailData *)item
{
    CGSize size = [item.conment sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(300, 500) lineBreakMode:NSLineBreakByWordWrapping];
    if (item.image_list_new.count) {
        return size.height+63+70;
    }
    else{
        return size.height+63;
    }

}

- (void)drawRect:(CGRect)rect
{
    CGSize size = [_item.conment sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(300, 500) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = self.commentLabel.frame;
    frame.origin.x = 10;
    frame.origin.y = CGRectGetMaxY(self.dateLabel.frame)+5;
    frame.size.width = size.width+5;
    frame.size.height = size.height;
    self.commentLabel.frame = frame;
    
    
    CGFloat xx = 20;
    CGFloat yy = CGRectGetMaxY(self.commentLabel.frame)+20;
    CGFloat width = 48;
    CGFloat intervalx = (self.frame.size.width - 20 - width*5)/6;
    NSInteger ctn = _item.image_list_new.count > 5 ? 5 : _item.image_list_new.count;
    for (int i = 0 ; i < ctn ; i++) {
        NSDictionary *info = _item.image_list_new[i];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(xx, yy, width, width)];
        [image setImageWithURL:[NSURL URLWithString:[info objectForKey:@"image_link"]] placeholderImage:nil];
        [self.contentView addSubview:image];
        xx += width+intervalx;
    }
    
    frame = self.containView.frame;
    if (_item.image_list_new.count) {
        frame.size.height = CGRectGetMaxY(self.commentLabel.frame)+3+70;
    }
    else{
        frame.size.height = CGRectGetMaxY(self.commentLabel.frame)+3;
    }
    self.containView.frame = frame;
    
    self.starView.center = CGPointMake(self.consumeLabel.center.x+37, self.nameLabel.center.y+10);
    
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(self.containView.frame)+13;
    self.frame = frame;
}

- (void)awakeFromNib {

    self.nameLabel.textColor = kBaseGrayColor;
    self.dateLabel.textColor = kBaseGrayColor;
    self.consumeLabel.textColor = kBaseGrayColor;
    self.commentLabel.textColor = kBaseGrayColor;
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.font = [UIFont systemFontOfSize:14.0];
    [self.containView.layer setCornerRadius:5];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
