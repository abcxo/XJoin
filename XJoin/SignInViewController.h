//
//  SignInViewController.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoundButton;
@interface SignInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet RoundButton *loginBtn;


//fb login sure
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *FBpasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *FBuserNameTF;
@property (weak, nonatomic) IBOutlet RoundButton *editBtn;
@property (weak, nonatomic) IBOutlet RoundButton *backBtn;

@end
