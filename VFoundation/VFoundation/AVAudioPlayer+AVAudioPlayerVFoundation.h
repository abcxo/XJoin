//
//  AVAudioPlayer+AVAudioPlayerVFoundation.h
//  VFoundation
//
//  Created by shadow on 14-7-30.
//  Copyright (c) 2014年 SJ. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayer (AVAudioPlayerVFoundation)
- (void)playAtTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
@end
