//
//  ActivityNewViewController.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrossScrollView.h"
#import "XJoinDefine.h"
@class ActivityEntity;
@interface ActivityNewViewController : UIViewController <CrossScrollViewDataSource, CrossScrollViewDelegate, BackPassViewControllerDelegate>
@property (nonatomic, weak) id <BackPassViewControllerDelegate> passedDelegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeEndBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UITextField *typeTF;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UILabel *parCountLabel;
@property (weak, nonatomic) IBOutlet CrossScrollView *parScrollView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) ActivityEntity *activity;

@end
