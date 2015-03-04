//
//  UIScrollView+UISrollViewVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-4-21.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UIScrollView+UISrollViewVUIKit.h"
#import "VUIKit.h"

@implementation UIScrollView (UISrollViewVUIKit)
__ENABLE_EXCHANGE_METHOD__(SELString(setContentSize :))

- (void)__exchange__setContentSize:(CGSize)contentSize {
	if (contentSize.height == SCREEN_MAX) {
		contentSize.height = SCREEN_HEIGHT;
	}
	[self __exchange__setContentSize:contentSize];
}

@end
