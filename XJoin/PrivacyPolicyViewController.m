//
//  PrivacyPolicyViewController.m
//  XJoin
//
//  Created by shadow on 14-10-15.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import "XJoin.h"
@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

- (void)prepareForView {
	[super prepareForView];
	NSString *path = [[NSBundle mainBundle]pathForResource:@"privacypolicy" ofType:@"doc"];
	NSURL *url = [NSURL fileURLWithPath:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
}

@end
