//
//  UIView+UIViewVUIKit.h
//  VUIKit
//
//  Created by shadow on 14-4-21.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewVUIKit)
- (void)prepareForView;
- (void)removeAllSubViews;
@end

@interface UIView (UIViewSpace)
@property (nonatomic, assign) CGRect resizeFrame;
@property (nonatomic, assign) CGRect previousFrame;
@property (nonatomic, assign) CGPoint previousCenter;
- (void)setFrameX:(CGFloat)x;
- (void)setFrameY:(CGFloat)y;
- (void)setFrameW:(CGFloat)w;
- (void)setFrameH:(CGFloat)h;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;
+ (CGPoint)center;

@end
@interface UIView (UIViewSnapShot)
- (UIImage *)snapshot;
+ (UIImage *)screenshot;

@end

@interface UIView (UIViewAnimations)
- (void)pauseAnimation;
- (void)resumeAnimation;

@end
