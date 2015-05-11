//
//  MessageDetailViewController.m
//  XJoin
//
//  Created by shadow on 15/5/11.
//  Copyright (c) 2015年 genio. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "XJoin.h"
@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.subjectLabel.text=self.message.subject;
    self.contentLabel.text=self.message.content;
    [self.contentLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
