//
//  UIApplication+UIApplicationVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-6-4.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UIApplication+UIApplicationVUIKit.h"

@implementation UIApplication (UIApplicationVUIKit)
+ (UIWindow *)window {
	return [[[UIApplication sharedApplication] delegate] window];
}

@end
