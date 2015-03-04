//
//  SettingTableViewController.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleImageView, ZJSwitch;
@interface SettingTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet ZJSwitch *notificationSwitch;

@end
