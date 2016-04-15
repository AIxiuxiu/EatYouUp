//
//  QSFoodMenuViewController.h
//  Eating
//
//  Created by System Administrator on 12/13/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import "QSViewController.h"

@interface QSFoodMenuViewController : QSViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, copy) NSString *menuUrl;
@property (nonatomic, copy) NSString *foodName;
@end
