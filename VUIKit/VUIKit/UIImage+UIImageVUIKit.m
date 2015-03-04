//
//  UIImage+UIImageVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-6-4.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UIImage+UIImageVUIKit.h"
#import "VUIKit.h"
@implementation UIImage (UIImageVUIKit)
+ (UIImage *)snapshot:(UIView *)view {
	if (IOS_VERSION_LOW_7) {
		UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 1);
		[view.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *snapShot = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return snapShot;
	}
	else {
		UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 1);
		[view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
		UIImage *snapShot = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return snapShot;
	}
}

@end
