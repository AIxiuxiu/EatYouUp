//
//  QSMetroSearchViewController.m
//  Eating
//
//  Created by System Administrator on 12/12/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSMetroSearchViewController.h"
#import "UserManager.h"
#import "NSString+JSON.h"
#import "QSMerchantViewController.h"

@interface QSMetroSearchViewController ()

@property (nonatomic, strong) NSDictionary *stationDict;
@property (nonatomic, strong) UIImageView *bgImage;
@end

@implementation QSMetroSearchViewController

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
    self.metroTabelView2.backgroundColor = kBaseBackgroundColor;
    NSString *linejson = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LINE440" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    _stationDict = [linejson JSON];
    
//    NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupUI
{
    self.titleLabel.text = @"选择地铁";
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.metroTabelView1) {
        return [UserManager sharedManager].metroCategoryArray.count;
    }
    else{
        NSArray *temp = [self.stationDict objectForKey:self.metroLine];
        return temp.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSMetroSearchViewController *weakSelf = self;
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.textColor = kBaseGrayColor;
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    if (tableView == self.metroTabelView1) {
        cell.textLabel.text = [UserManager sharedManager].metroCategoryArray[indexPath.row];
        
        if ([self.metroLine isEqualToString:[UserManager sharedManager].metroCategoryCodeArray[indexPath.row]]) {
            
            [cell.contentView insertSubview:self.bgImage belowSubview:cell.textLabel];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        else{
            
            cell.textLabel.textColor = kBaseGrayColor;
        }
    }
    else{
        NSDictionary *dict = [self.stationDict objectForKey:self.metroLine];
        cell.textLabel.text = [dict allValues][indexPath.row];
    }

    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.metroTabelView1) {

        self.metroLine = [UserManager sharedManager].metroCategoryCodeArray[indexPath.row];
        [self.metroTabelView1 reloadData];
        [self.metroTabelView2 reloadData];
    }
    else{
        NSDictionary *dict = [self.stationDict objectForKey:self.metroLine];
        self.metroStation = [dict allKeys][indexPath.row];
        
        QSMerchantViewController *viewVC = [[QSMerchantViewController alloc] init];
        viewVC.metro = self.metroStation;
        viewVC.showBackButton = YES;
        [self.navigationController pushViewController:viewVC animated:YES];
    }
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
