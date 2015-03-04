//
//  AboutViewController.m
//  XJoin
//
//  Created by shadow on 14-9-2.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "AboutViewController.h"
#import "XJoin.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)prepareForView {
	[super prepareForView];
	NSString *path = [[NSBundle mainBundle]pathForResource:@"about" ofType:@"doc"];
	NSURL *url = [NSURL fileURLWithPath:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
}

@end
