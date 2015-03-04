//
//  TermViewController.m
//  XJoin
//
//  Created by shadow on 14-9-2.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "TermViewController.h"
#import "XJoin.h"
@interface TermViewController ()

@end

@implementation TermViewController

- (void)prepareForView {
	[super prepareForView];
	NSString *path = [[NSBundle mainBundle]pathForResource:@"term" ofType:@"docx"];
	NSURL *url = [NSURL fileURLWithPath:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
}

@end
