//
//  CALayer+CALayerVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-8-12.
//  Copyright (c) 2014年 SJ. All rights reserved.
//

#import "CALayer+CALayerVUIKit.h"
#import "VUIKit.h"
@implementation CALayer (CALayerVUIKit)
- (void)pauseAnimation {
	CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
	self.speed = 0.0;
	self.timeOffset = pausedTime;
}

- (void)resumeAnimation {
	CFTimeInterval pausedTime = [self timeOffset];
	self.speed = 1.0;
	self.timeOffset = 0.0;
	self.beginTime = 0.0;
	CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
	self.beginTime = timeSincePause;
}

@end
