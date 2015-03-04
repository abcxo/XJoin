//
//  UserQuickLookQRCoderViewController.h
//  XJoin
//
//  Created by shadow on 14-8-26.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserEntity;
@interface UserQuickLookQRCoderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *QRCoderImageView;
@property (nonatomic, strong) UserEntity *user;
@end
