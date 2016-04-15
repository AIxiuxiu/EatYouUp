//
//  QSFoodTagEditViewController.m
//  Eating
//
//  Created by System Administrator on 11/25/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSFoodTagEditViewController.h"
#import "QSAPIClientBase+User.h"
#import "QSAPIModel+User.h"

@interface QSFoodTagEditViewController ()

@property (nonatomic, strong) QSTagListReturnData *randomTaglistReturnData;
@property (nonatomic, strong) QSTagListReturnData *userTaglistReturnData;
@property (nonatomic, strong) NSMutableArray *userTagDataSource;

@property (nonatomic, strong) UIView *userTagView;
@property (nonatomic, strong) NSMutableArray *userTagButtons;

@property (nonatomic, strong) UIView *randomTagView;
@property (nonatomic, strong) NSMutableArray *randomTagButtons;


@end

@implementation QSFoodTagEditViewController


- (NSMutableArray *)userTagButtons
{
    if (!_userTagButtons) {
        _userTagButtons = [[NSMutableArray alloc] init];
    }
    return _userTagButtons;
}

- (UIView *)userTagView
{
    if (!_userTagView) {
        _userTagView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, DeviceWidth - 20, 200)];
        _userTagView.backgroundColor = [UIColor whiteColor];
        [self.tagScrollView addSubview:_userTagView];
    }
    return _userTagView;
}

- (NSMutableArray *)randomTagButtons
{
    if (!_randomTagButtons) {
        _randomTagButtons = [[NSMutableArray alloc] init];
    }
    return _randomTagButtons;
}

- (UIView *)randomTagView
{
    if (!_randomTagView) {
        _randomTagView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, DeviceWidth - 20, 100)];
        _randomTagView.backgroundColor = [UIColor clearColor];
        [self.tagScrollView addSubview:_randomTagView];
    }
    return _randomTagView;
}


- (void)setRandomTaglistReturnData:(QSTagListReturnData *)randomTaglistReturnData
{
    _randomTaglistReturnData = randomTaglistReturnData;
    
    [self setupRandomTagListView];
}

- (void)setUserTaglistReturnData:(QSTagListReturnData *)userTaglistReturnData
{
    _userTaglistReturnData = userTaglistReturnData;
    self.userTagDataSource = [[NSMutableArray alloc] init];
    for (NSDictionary *info in _userTaglistReturnData.data) {
        [self.userTagDataSource addObject:[info objectForKey:@"tag_name"]];
    }
    [self setupMyTagListView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getRandomTagList];
    
    [self getUserTagList];
}

- (void)setupUI
{
    self.titleLabel.text = @"我的美食标签";
    [self.handoverButton roundCornerRadius:18];
}

- (void)setupMyTagListView
{
    CGFloat xx = 10;
    CGFloat yy = 10;
    
    for (UIButton *button in self.userTagView.subviews) {
        [button removeFromSuperview];
    }
    [self.userTagButtons removeAllObjects];
    
    for (int i = 0 ; i < _userTagDataSource.count ; i++) {
        NSString *tagname = _userTagDataSource[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.backgroundColor = kBaseGreenColor;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [button setTitle:tagname forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onMyTagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [tagname sizeWithFont:button.titleLabel.font forWidth:200 lineBreakMode:NSLineBreakByWordWrapping];
        if (xx + size.width+20 > DeviceWidth-20) {
            xx = 10;
            yy += 30;
        }
        
        button.frame = CGRectMake(xx, yy, size.width+20, 20);
        [button roundCornerRadius:10];
        [self.userTagButtons addObject:button];
        [self.userTagView addSubview:button];
        
        xx = CGRectGetMaxX(button.frame)+10;
        if (xx >= CGRectGetMaxY(self.userTagView.frame)) {
            xx = 10;
            yy += 30;
        }
        
    }
}

- (void)setupRandomTagListView
{
    CGFloat xx = 10;
    CGFloat yy = 10;
    
    for (UIButton *button in self.randomTagView.subviews) {
        [button removeFromSuperview];
    }
    [self.randomTagButtons removeAllObjects];
    
    for (int i = 0 ; i < _randomTaglistReturnData.data.count ; i++) {
        NSDictionary *dict = _randomTaglistReturnData.data[i];
        NSString *tagname = [dict objectForKey:@"tag_name"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [button setTitle:tagname forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onRandomTagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [tagname sizeWithFont:button.titleLabel.font forWidth:200 lineBreakMode:NSLineBreakByWordWrapping];
        
        if (xx + size.width+20 > self.randomTagView.frame.size.width) {
            xx = 10;
            yy += 30;
        }
        
        button.frame = CGRectMake(xx, yy, size.width+20, 20);
        [button roundCornerRadius:10];
        [self.randomTagButtons addObject:button];
        [self.randomTagView addSubview:button];
        
        xx = CGRectGetMaxX(button.frame)+10;
        if (xx >= CGRectGetMaxY(self.randomTagView.frame)) {
            xx = 10;
            yy += 30;
        }
        
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [button setTitle:@"换一批" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getRandomTagList) forControlEvents:UIControlEventTouchUpInside];
    CGSize size = [@"换一批" sizeWithFont:button.titleLabel.font forWidth:200 lineBreakMode:NSLineBreakByWordWrapping];
    if (xx + size.width+20 > self.randomTagView.frame.size.width) {
        xx = 10;
        yy += 30;
    }

    button.frame = CGRectMake(xx, yy, size.width+20, 20);
    [button roundCornerRadius:10];
    [self.randomTagButtons addObject:button];
    [self.randomTagView addSubview:button];
}

- (IBAction)onRandomTagButtonAction:(id)sender
{
    UIButton *button = sender;
    NSDictionary *dict = self.randomTaglistReturnData.data[button.tag];
    if (![self.userTagDataSource containsObject:[dict objectForKey:@"tag_name"]]) {
        [self.userTagDataSource addObject:[dict objectForKey:@"tag_name"]];
        [self setupRandomTagListView];
        [self setupMyTagListView];
    }

}

- (IBAction)onMyTagButtonAction:(id)sender
{
    UIButton *button = sender;
    [self.userTagDataSource removeObjectAtIndex:button.tag];
    [self setupMyTagListView];
}

- (IBAction)onHandoverButtonAction:(id)sender
{

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    __weak QSFoodTagEditViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] userTagUpdate:self.userTagDataSource
                                          success:^(QSAPIModel *response) {
                                              [weakSelf showTip:self.view tipStr:@"更新标签成功"];
                                          } fail:^(NSError *error) {
                                              [weakSelf showTip:self.view tipStr:@"更新标签失败"];

                                          }];
    
}

- (void)getRandomTagList
{
    __weak QSFoodTagEditViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] randomTagListSuccess:^(QSTagListReturnData *response) {
        weakSelf.randomTaglistReturnData = response;
    } fail:^(NSError *error) {
        
    }];
}

- (void)getUserTagList
{
    __weak QSFoodTagEditViewController *weakSelf = self;
    [[QSAPIClientBase sharedClient] userTagListSuccess:^(QSTagListReturnData *response) {
        weakSelf.userTaglistReturnData = response;
    } fail:^(NSError *error) {
        
    }];
}

- (void)addTag:(NSString *)tag_id
{
    __weak QSFoodTagEditViewController *weakSelf = self;
    
}

- (void)deleteTag:(NSString *)tag_id
{
    __weak QSFoodTagEditViewController *weakSelf = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
