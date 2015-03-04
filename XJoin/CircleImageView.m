//
//  CircleImageView.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "CircleImageView.h"
#import "XJoin.h"
@implementation CircleImageView

- (void)prepareForView {
	[super prepareForView];
	[self clipToCircle];
}

- (void)clipToCircle {
	self.contentMode = UIViewContentModeScaleAspectFill;
	self.clipsToBounds = YES;
	self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
}

@end
