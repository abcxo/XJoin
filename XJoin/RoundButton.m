//
//  RoundButton.m
//  XJoin
//
//  Created by shadow on 14-8-21.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "RoundButton.h"
#import "XJoin.h"
@implementation RoundButton

- (void)prepareForView {
	[super prepareForView];
	self.layer.cornerRadius = 5;
}

@end
