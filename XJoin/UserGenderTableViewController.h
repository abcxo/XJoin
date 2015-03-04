//
//  UserGenderTableViewController.h
//  XJoin
//
//  Created by shadow on 14/11/8.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJoinDefine.h"
@class UserEntity;
@interface UserGenderTableViewController : UITableViewController
@property (nonatomic, weak) id <BackPassViewControllerDelegate> passedDelegate;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (nonatomic, strong) UserEntity *user;
@end
