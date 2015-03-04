//
//  UIView+UIViewVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-4-21.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UIView+UIViewVUIKit.h"
#import "VUIKit.h"

@implementation UIView (UIViewVUIKit)

__ENABLE_EXCHANGE_METHOD__(SELString(initWithCoder :), SELString(initWithFrame :))



- (id)__exchange__initWithCoder:(NSCoder *)aDecoder {
	id result = [self __exchange__initWithCoder:aDecoder];
	[self prepareForView];
	return result;
}

- (id)__exchange__initWithFrame:(CGRect)frame {
	id result = [self __exchange__initWithFrame:frame];
	[self prepareForView];
	return result;
}

- (void)prepareForView {
}

- (void)removeAllSubViews {
	for (UIView *view in[self subviews]) {
		[view removeFromSuperview];
	}
}

@end
static const void *resizeFrameKey = &resizeFrameKey;
static const void *previousFrameKey = &previousFrameKey;
static const void *previousCenterKey = &previousCenterKey;
@implementation UIView (UIViewSpace)
@dynamic resizeFrame;
@dynamic previousFrame;
@dynamic previousCenter;


- (void)setResizeFrame:(CGRect)resizeFrame {
	objc_setAssociatedObject(self, resizeFrameKey, [NSValue valueWithCGRect:resizeFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if (IOS_VERSION_LOW_7) {
		self.frame = resizeFrame;
	}
}

- (CGRect)resizeFrame {
	return [objc_getAssociatedObject(self, resizeFrameKey) CGRectValue];
}

- (void)setPreviousFrame:(CGRect)previousFrame {
	objc_setAssociatedObject(self, previousFrameKey, [NSValue valueWithCGRect:previousFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)previousFrame {
	return [objc_getAssociatedObject(self, previousFrameKey) CGRectValue];
}

- (void)setPreviousCenter:(CGPoint)previousCenter {
	objc_setAssociatedObject(self, previousCenterKey, [NSValue valueWithCGPoint:previousCenter], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)previousCenter {
	return [objc_getAssociatedObject(self, previousCenterKey) CGPointValue];
}

- (void)setFrameX:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (void)setFrameY:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (void)setFrameW:(CGFloat)w {
	CGRect frame = self.frame;
	frame.size.width = w;
	self.frame = frame;
}

- (void)setFrameH:(CGFloat)h {
	CGRect frame = self.frame;
	frame.size.height = h;
	self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}

- (void)setSize:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

+ (CGPoint)center {
	return CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
}

@end

@implementation UIView (UIViewSnapShot)

- (UIImage *)snapshot {
	return [UIImage snapshot:self];
}

+ (UIImage *)screenshot {
	return [UIImage snapshot:[UIApplication window]];
}

@end

@implementation UIView (UIViewAnimations)
- (void)pauseAnimation {
	[self.layer pauseAnimation];
	NSArray *array = [self.layer sublayers];
	[array enumerateObjectsUsingBlock: ^(CALayer *obj, NSUInteger idx, BOOL *stop) {
	    [obj pauseAnimation];
	}];
}

- (void)resumeAnimation {
	[self.layer resumeAnimation];
	NSArray *array = [self.layer sublayers];
	[array enumerateObjectsUsingBlock: ^(CALayer *obj, NSUInteger idx, BOOL *stop) {
	    [obj resumeAnimation];
	}];
}

@end
