//
//  UserDetailTableViewController.h
//  XJoin
//
//  Created by shadow on 14-8-22.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrossScrollView.h"
#import "XJoinDefine.h"
@class CircleImageView, FitLabel, UserEntity, MessageEntity;
typedef NS_ENUM (NSUInteger, UserDetailTableViewControllerType) {
	UserDetailTableViewControllerTypeQuickLook,
	UserDetailTableViewControllerTypeNearBy,
	UserDetailTableViewControllerTypeEdit,
	UserDetailTableViewControllerTypeOperate,
};
@interface UserDetailTableViewController : UITableViewController <CrossScrollViewDataSource, CrossScrollViewDelegate, BackPassViewControllerDelegate>
@property (weak, nonatomic) IBOutlet CrossScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet FitLabel *signatureLabel;

@property (weak, nonatomic) IBOutlet UILabel *photoCountLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ignoreBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *agreeBarItem;

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) UserEntity *user;

@property (nonatomic, strong) MessageEntity *message;

@property (nonatomic, assign) UserDetailTableViewControllerType type;
@end
