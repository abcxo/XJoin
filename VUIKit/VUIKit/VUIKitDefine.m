//
//  VUIKitDefine.m
//  VUIKit
//
//  Created by shadow on 14-4-17.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "VUIKitDefine.h"

@implementation VUIKitDefine
CGFloat CGRectGetLeastX(CGRect rect) {
	return rect.origin.x - rect.size.width;
}

CGFloat CGRectGetLeastY(CGRect rect) {
	return rect.origin.y - rect.size.height;
}

CGRect CGRectMakeWithSize(CGSize size) {
	return CGRectMake(0, 0, size.width, size.height);
}

CGRect CGRectMakeWithRect(CGRect rect) {
	return CGRectMakeWithSize(rect.size);
}

@end
