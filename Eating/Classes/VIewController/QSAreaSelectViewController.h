//
//  QSAreaSelectViewController.h
//  Eating
//
//  Created by System Administrator on 11/27/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kListSelectType_County
}kListSelectType;
@interface QSAreaSelectViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (nonatomic, unsafe_unretained) kListSelectType listSeletType;

@property (nonatomic, strong) void(^onSelectAreaHanler)(NSString *, NSString *);
@end
