//
//  MessageDetailViewController.h
//  XJoin
//
//  Created by shadow on 15/5/11.
//  Copyright (c) 2015年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageEntity;
@interface MessageDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) MessageEntity *message;
@end
