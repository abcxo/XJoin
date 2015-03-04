//
//  FitLabel.m
//  XJoin
//
//  Created by shadow on 14-8-22.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "FitLabel.h"
#import "XJoin.h"
@implementation FitLabel
- (void)prepareForView {
	[super prepareForView];
	self.previousFrame = self.frame;
}

- (void)setText:(NSString *)text {
	if (![self.text isEqualToString:text]) {
		self.frame = self.previousFrame;
		[super setText:text];
		[self sizeToFit];
	}
	else {
		[super setText:text];
	}
}

@end
