//
//  AVAudioPlayer+AVAudioPlayerVFoundation.m
//  VFoundation
//
//  Created by shadow on 14-7-30.
//  Copyright (c) 2014年 SJ. All rights reserved.
//

#import "AVAudioPlayer+AVAudioPlayerVFoundation.h"

@implementation AVAudioPlayer (AVAudioPlayerVFoundation)
- (void)playAtTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
	self.currentTime = time;
	[self play];
	[NSTimer scheduledTimerWithTimeInterval:duration
	                                 target:self
	                               selector:@selector(stopPlaying:)
	                               userInfo:nil
	                                repeats:NO];
}

- (void)stopPlaying:(NSTimer *)theTimer {
	[self stop];
}

@end
