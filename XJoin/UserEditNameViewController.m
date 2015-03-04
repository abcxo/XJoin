//
//  UserEditNameViewController.m
//  XJoin
//
//  Created by shadow on 14-8-26.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UserEditNameViewController.h"
#import "XJoin.h"
@interface UserEditNameViewController () <UITextFieldDelegate>

@end

@implementation UserEditNameViewController

- (void)prepareForView {
	[super prepareForView];
	self.nameTF.text = self.user.nickname;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if ([self.nameTF.text isMeaningful] && ![[self.user.nickname trimEdge] isEqualToString:[self.nameTF.text trimEdge]]) {
		self.user.nickname = self.nameTF.text;
		if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
			[self.passedDelegate backPassViewController:self pass:@{ @"user":self.user }];
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:YES];
	return YES;
}

@end
