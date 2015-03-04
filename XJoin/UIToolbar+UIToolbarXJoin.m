//
//  UIToolbar+UIToolbarXJoin.m
//  XJoin
//
//  Created by shadow on 14-8-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UIToolbar+UIToolbarXJoin.h"
#import "XJoin.h"
@implementation UIToolbar (UIToolbarXJoin)
__ENABLE_EXCHANGE_METHOD__(SELString(layoutSubviews))
- (void)prepareForView {
	[super prepareForView];
	if (IOS_VERSION_LOW_7) {
		[self setBackgroundImage:COLOR_MAIN_RED_DARK.image forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
	}
}

- (void)__exchange__layoutSubviews {
	if (IOS_VERSION_LOW_7) {
		for (UIBarButtonItem *item in self.items) {
			if ([item.title isMeaningful]) {
				BOOL isBtn = [item toCustomBarItemWithSize:CGSizeMake(item.width, 30)];
				if (isBtn) {
					if ([item.customView isKindOfClass:[UIButton class]]) {
						UIButton *btn = (UIButton *)item.customView;
						[btn setTitleColor:item.tintColor forState:UIControlStateNormal];
					}
				}
			}
		}
	}

	[self __exchange__layoutSubviews];
}

@end
