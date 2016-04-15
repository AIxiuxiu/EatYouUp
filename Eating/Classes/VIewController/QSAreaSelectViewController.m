//
//  QSAreaSelectViewController.m
//  Eating
//
//  Created by System Administrator on 11/27/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSAreaSelectViewController.h"
#import "UIView+UI.h"
@interface QSAreaSelectViewController ()

@end

@implementation QSAreaSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view roundCornerRadius:5];
    [self.listTableView roundCornerRadius:5];
    if (self.listSeletType == kListSelectType_County) {
        self.dataSource = [[NSMutableArray alloc] initWithObjects:@"市辖区",@"东山区",@"荔湾区",@"越秀区",@"海珠区",@"天河区",@"芳村区",@"白云区",@"黄埔区",@"番禺区",@"花都区",@"增城市",@"从化市",@"萝岗区", nil];
        [self.listTableView reloadData];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak QSAreaSelectViewController *weakSelf = self;
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onSelectAreaHanler) {
        self.onSelectAreaHanler(@"",self.dataSource[indexPath.row]);
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
