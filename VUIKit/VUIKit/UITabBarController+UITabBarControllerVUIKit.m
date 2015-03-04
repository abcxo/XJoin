//
//  UITabBarController+UITabBarControllerVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-5-6.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UITabBarController+UITabBarControllerVUIKit.h"
#import "VUIKit.h"
static const void *tabBarHiddenKey = &tabBarHiddenKey;
@implementation UITabBarController (UITabBarControllerVUIKit)
@dynamic tabBarHidden;
- (void)setTabBarHidden:(BOOL)tabBarHidden {
	objc_setAssociatedObject(self, tabBarHiddenKey, @(tabBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isTabBarHidden {
	return [objc_getAssociatedObject(self, tabBarHiddenKey) boolValue];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
	self.tabBarHidden = hidden;
	CGFloat duration = animated ? 0.2 : 0;
	CGFloat tabBarY = hidden ? CGRectGetMaxY(self.tabBar.frame) : CGRectGetLeastY(self.tabBar.frame);
	[UIView animateWithDuration:duration animations: ^{
	    [self.tabBar setFrameY:tabBarY];
	}];
}

@end
