//
//  UIBarButtonItem+UIBarButtonItemXJoin.m
//  XJoin
//
//  Created by shadow on 14-8-29.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UIBarButtonItem+UIBarButtonItemXJoin.h"
#import "XJoin.h"
@implementation UIBarButtonItem (UIBarButtonItemXJoin)
__ENABLE_EXCHANGE_METHOD__(SELString(setTitle :),  SELString(setImage :))
- (BOOL)toCustomBarItem {
	return [self toCustomBarItemWithSize:CGSizeMake(self.width > 0 ? self.width : NAV_HEIGHT, NAV_HEIGHT)];
}

- (BOOL)toCustomBarItemWithSize:(CGSize)size {
	if (!self.customView) {
		UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMakeWithSize(size)];
		if (self.image) {
			[btn setImage:self.image forState:UIControlStateNormal];
		}
		else if ([self.title isMeaningful]) {
			btn.text = self.title;
		}
		btn.titleLabel.font = [UIFont systemFontOfSize:16];
		[btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
		[btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];

		btn.tintColor = self.tintColor;
		[btn addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
		[btn setImageEdgeInsets:self.imageInsets];
		self.customView = btn;
		return YES;
	}
	return NO;
}

- (void)__exchange__setTitle:(NSString *)title {
	[self __exchange__setTitle:title];
	if (IOS_VERSION_LOW_7 && self.customView && [self.customView isKindOfClass:[UIButton class]]) {
		((UIButton *)self.customView).text = self.title;
	}
}

- (void)__exchange__setImage:(UIImage *)image {
	[self __exchange__setImage:image];
	if (IOS_VERSION_LOW_7 && self.customView && [self.customView isKindOfClass:[UIButton class]]) {
		[(UIButton *)self.customView setImage : self.image forState : UIControlStateNormal];
	}
}

@end
