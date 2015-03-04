//
//  ParticipatorEntity.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "ParticipatorEntity.h"
#import "XJoin.h"
@implementation ParticipatorEntity
- (NSString *)coverurl {
	if (![_coverurl containStrings:@"jpg", @"JPG", nil]) {
		_coverurl = nil;
	}
	else if (![_coverurl containString:NETWORK_HOST]) {
		_coverurl = [NETWORK_HOST addString:_coverurl];
	}

	return _coverurl;
}

@end
