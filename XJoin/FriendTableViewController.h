//
//  FriendTableViewController.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJoinDefine.h"
@class RoundButton, NSMutableOrderedDictionary;
@interface FriendTableViewController : UITableViewController
@property (nonatomic, weak) id <BackPassViewControllerDelegate> passedDelegate;
@property (nonatomic, retain) NSMutableOrderedDictionary *dataSource;
@property (nonatomic, retain) NSMutableArray *dataSearchSource;
@property (strong, nonatomic) IBOutlet RoundButton *loginBtn;

@end
