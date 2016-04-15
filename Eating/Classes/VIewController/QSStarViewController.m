//
//  QSStarViewController.m
//  eating
//
//  Created by System Administrator on 11/10/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSStarViewController.h"

@interface QSStarViewController ()

@end

@implementation QSStarViewController

+ (UIView *)cellStarView:(NSInteger)point showPointLabal:(BOOL)isShow
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    for (int i = 0 ; i < 5 ; i++) {
        UIButton *star = [UIButton buttonWithType:UIButtonTypeCustom];
        star.tag = i;
        star.frame = CGRectMake(2+12*i, 5, 11, 10);
        if (i+1 <= point) {
            [star setBackgroundImage:IMAGENAME(@"common_star_selected") forState:UIControlStateNormal];
        }
        else{
            [star setBackgroundImage:IMAGENAME(@"common_star") forState:UIControlStateNormal];

        }
        [view addSubview:star];
    }
    
    CGRect frame = view.frame;
    frame.size.width = 2+12*5+11;
    view.frame = frame;
    
    if (isShow) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(18+11*5, 0, 25, 20);
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = [NSString stringWithFormat:@"%ld分",(long)point];
        label.textColor = [UIColor orangeColor];
        [view addSubview:label];
        
        frame = view.frame;
        frame.size.width = 18+11*5+25;
        view.frame = frame;
    }
    
    return view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupUI
{
    
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
