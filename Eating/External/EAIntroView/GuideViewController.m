//
//  GuideViewController.m
//  DateApp
//
//  Created by likunding on 14-7-25.
//  Copyright (c) 2014年 likunding. All rights reserved.
//

#import "GuideViewController.h"
#import "QSConfig.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self showIntroWithCrossDissolve];

}

- (void)showIntroWithCrossDissolve {
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"cdn_1.jpg"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"cdn_2.jpg"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"cdn_3.jpg"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"cdn_4.jpg"];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.bgImage = [UIImage imageNamed:@"cdn_5.jpg"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"跳过" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake((DeviceWidth-230)/2, [UIScreen mainScreen].bounds.size.height - 50, 230, 40)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    intro.skipButton = btn;
    
    [intro setDelegate:_delegate];
    [intro showInView:self.view animateDuration:0.0];
    
}

- (void)introDidFinish {
    
    NSLog(@"Intro callback");

}

@end
