//
//  SignUpViewController.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJoinDefine.h"
@class CircleImageView, PPiFlatSegmentedControl;
@interface SignUpViewController : UIViewController <BackPassViewControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *regionBtn;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet PPiFlatSegmentedControl *genderSeg;

@end
