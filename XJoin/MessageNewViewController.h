//
//  MessageNewViewController.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageNewViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *uid;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
