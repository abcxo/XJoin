//
//  UserEditContentViewController.m
//  XJoin
//
//  Created by shadow on 14-8-26.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UserEditContentViewController.h"
#import "XJoin.h"
@interface UserEditContentViewController ()

@end

@implementation UserEditContentViewController
- (void)prepareForView {
	[super prepareForView];
	self.contentTV.text = self.user.signature;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (![[self.user.signature trimEdge] isEqualToString:[self.contentTV.text trimEdge]]) {
		self.user.signature = self.contentTV.text;
		if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
			[self.passedDelegate backPassViewController:self pass:@{ @"user":self.user }];
		}
	}
}

@end
