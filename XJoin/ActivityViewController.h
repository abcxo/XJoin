//
//  ActivityViewController.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJoinDefine.h"
@class RoundButton, PPiFlatSegmentedControl;

@interface ActivityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BackPassViewControllerDelegate>

@property (nonatomic, weak) id <BackPassViewControllerDelegate> passedDelegate;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *segment;
@property (strong, nonatomic) NSMutableArray *recommendDataSource;
@property (strong, nonatomic) NSMutableArray *meDataSource;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *recommendTableView;
@property (weak, nonatomic) IBOutlet UITableView *meTableView;
@property (weak, nonatomic) IBOutlet RoundButton *createBtn;
@property (weak, nonatomic) IBOutlet RoundButton *loginBtn;
@end
