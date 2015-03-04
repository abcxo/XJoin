//
//  UINavigationBar+UINavigationBarXJoin.m
//  XJoin
//
//  Created by shadow on 14-8-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UINavigationBar+UINavigationBarXJoin.h"
#import "XJoin.h"
@implementation UINavigationBar (UINavigationBarXJoin)
__ENABLE_EXCHANGE_METHOD__(SELString(layoutSubviews))
- (void)prepareForView {
	[super prepareForView];
	if (IOS_VERSION_LOW_7) {
		[self setBackgroundImage:COLOR_MAIN_RED_DARK.image forBarMetrics:UIBarMetricsDefault];
		[self setTitleTextAttributes:@{ UITextAttributeFont: [UIFont systemFontOfSize:17] }];
		[self setTitleVerticalPositionAdjustment:2 forBarMetrics:UIBarMetricsDefault];
	}
}

- (void)__exchange__layoutSubviews {
	if (IOS_VERSION_LOW_7) {
		for (UINavigationItem *item in self.items) {
			UIBarButtonItem *leftItem = item.leftBarButtonItem;
			UIBarButtonItem *rightItem = item.rightBarButtonItem;
			[leftItem toCustomBarItem];
			[rightItem toCustomBarItem];
		}
	}

	[self __exchange__layoutSubviews];
}

@end
