//
//  UITabBar+UITabBarXJoin.m
//  XJoin
//
//  Created by shadow on 14-8-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UITabBar+UITabBarXJoin.h"
#import "XJoin.h"
@implementation UITabBar (UITabBarXJoin)

__ENABLE_EXCHANGE_METHOD__(SELString(layoutSubviews))
- (void)prepareForView {
	[super prepareForView];
	if (IOS_VERSION_LOW_7) {
		[self setBackgroundImage:COLOR_MAIN_RED_DARK.image];
		self.selectionIndicatorImage = COLOR_MAIN_RED_DARK.image;
	}
}

- (void)__exchange__layoutSubviews {
	[self __exchange__layoutSubviews];
	if (IOS_VERSION_LOW_7) {
		for (UITabBarItem *item in[self items]) {
			switch (item.tag) {
				case 2000:
					[item setFinishedSelectedImage:[UIImage imageNamed:@"tab_item_activity_white"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_item_activity_orange"]];

					break;

				case 2001:
					[item setFinishedSelectedImage:[UIImage imageNamed:@"tab_item_message_white"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_item_message_orange"]];

					break;

				case 2002:
					[item setFinishedSelectedImage:[UIImage imageNamed:@"tab_item_friend_white"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_item_friend_orange"]];

					break;

				case 2003:
					[item setFinishedSelectedImage:[UIImage imageNamed:@"tab_item_setting_white"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_item_setting_orange"]];

					break;


				default:
					break;
			}
		}
	}
}

@end
