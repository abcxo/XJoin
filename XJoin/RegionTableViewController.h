//
//  RegionTableViewController.h
//  XJoin
//
//  Created by shadow on 14-8-25.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJoinDefine.h"
@interface RegionTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) id <BackPassViewControllerDelegate> passedDelegate;
@end
