//
//  ActivityDetailViewController.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrossScrollView.h"
#import "XJoinDefine.h"
@class ActivityEntity;
@interface ActivityDetailViewController : UIViewController <CrossScrollViewDelegate, CrossScrollViewDataSource>
@property (nonatomic, weak) id <BackPassViewControllerDelegate> passedDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;

@property (weak, nonatomic) IBOutlet UILabel *parCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *photoCountLabel;


@property (weak, nonatomic) IBOutlet CrossScrollView *parScrollView;
@property (weak, nonatomic) IBOutlet CrossScrollView *photoScrollView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loveBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *joinBarItem;


@property (strong, nonatomic) ActivityEntity *activity;
@property (strong, nonatomic) NSString *aid;

@end
