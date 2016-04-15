//
//  QSBusinessSearchViewController.m
//  Eating
//
//  Created by System Administrator on 12/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSBusinessSearchViewController.h"
#import "UserManager.h"
#import "NSString+JSON.h"
#import "QSMerchantViewController.h"

@interface QSBusinessSearchViewController ()
@property (nonatomic, strong) NSDictionary *bussinessDict;

@property (nonatomic, strong) UIImageView *bgImage;
@end

@implementation QSBusinessSearchViewController

- (UIImageView *)bgImage
{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _bgImage.backgroundColor = kBaseOrangeColor;
        _bgImage.center = CGPointMake(34, 22);
        [_bgImage roundView];
    }
    
    return _bgImage;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bussinessTabelView2.backgroundColor = kBaseBackgroundColor;
    NSString *linejson = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BUSINESS440" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    _bussinessDict = [linejson JSON];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupUI
{
    self.titleLabel.text = @"选择商圈";
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.bussinessTabelView1) {
        
        return [UserManager sharedManager].countyArray.count;
        
    } else {
        
        NSArray *temp = [self.bussinessDict objectForKey:self.county];
        return temp.count;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.textLabel.textColor = kBaseGrayColor;
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    if (tableView == self.bussinessTabelView1) {
        
        cell.textLabel.text = [UserManager sharedManager].countyArray[indexPath.row];
        
        if ([self.county isEqualToString:[UserManager sharedManager].countyCodeArray[indexPath.row]]) {

            [cell.contentView insertSubview:self.bgImage belowSubview:cell.textLabel];
            cell.textLabel.textColor = [UIColor whiteColor];
            
        } else {
            
            cell.textLabel.textColor = kBaseGrayColor;
            
        }
        
    } else {
        
        NSDictionary *dict = [self.bussinessDict objectForKey:self.county];
        cell.textLabel.text = [dict allValues][indexPath.row];
        
    }
    
    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.bussinessTabelView1) {
        
        self.county = [UserManager sharedManager].countyCodeArray[indexPath.row];
        [self.bussinessTabelView1 reloadData];
        [self.bussinessTabelView2 reloadData];
        
    } else {
        
        NSDictionary *dict = [self.bussinessDict objectForKey:self.county];
        self.bussiness = [dict allKeys][indexPath.row];
        
        QSMerchantViewController *viewVC = [[QSMerchantViewController alloc] init];
        viewVC.metro = self.bussiness;
        viewVC.showBackButton = YES;
        [self.navigationController pushViewController:viewVC animated:YES];
        
    }
    
}

@end
