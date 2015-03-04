//
//  UIStoryboardSegue+UIStoryboardSegueVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-6-4.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UIStoryboardSegue+UIStoryboardSegueVUIKit.h"
#import "VUIKit.h"
static const void *userInfoKey = &userInfoKey;
static const void *senderKey = &senderKey;
@implementation UIStoryboardSegue (UIStoryboardSegueVUIKit)
@dynamic userInfo;
@dynamic sender;


- (void)setUserInfo:(id)userInfo {
	objc_setAssociatedObject(self, userInfoKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)userInfo {
	return objc_getAssociatedObject(self, userInfoKey);
}

- (void)setSender:(id)sender {
	objc_setAssociatedObject(self, senderKey, sender, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)sender {
	return objc_getAssociatedObject(self, senderKey);
}

- (void)dismiss {
	@autoreleasepool {
		UIViewController *destinationViewController = (UIViewController *)self.destinationViewController;
		destinationViewController.segue = nil;
	}
}

@end
