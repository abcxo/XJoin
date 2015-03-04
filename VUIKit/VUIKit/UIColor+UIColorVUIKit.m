//
//  UIColor+UIColorVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-8-28.
//  Copyright (c) 2014年 SJ. All rights reserved.
//

#import "UIColor+UIColorVUIKit.h"
#import "VUIKit.h"
@implementation UIColor (UIColorVUIKit)
- (UIImage *)image {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [self CGColor]);
	CGContextFillRect(context, rect);
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}

@end
