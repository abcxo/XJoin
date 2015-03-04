//
//  UserEditContentViewController.h
//  XJoin
//
//  Created by shadow on 14-8-26.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJoinDefine.h"
@class UserEntity;
@interface UserEditContentViewController : UIViewController
@property (nonatomic, weak) id <BackPassViewControllerDelegate> passedDelegate;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (nonatomic, strong) UserEntity *user;
@end
