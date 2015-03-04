//
//  MessageTableViewController.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoundButton;
@interface MessageTableViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (strong, nonatomic) IBOutlet RoundButton *loginBtn;

@end
