//
//  MessageEntity.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "MessageEntity.h"
#import "XJoin.h"
@interface MessageEntity () {
	NSString *_timeString;
}

@end
@implementation MessageEntity
- (NSString *)touser_coverurl {
	if (![_touser_coverurl containStrings:@"jpg", @"JPG", nil]) {
		_touser_coverurl = nil;
	}
	else if (![_touser_coverurl containString:NETWORK_HOST])      {
		_touser_coverurl = [NETWORK_HOST addString:_touser_coverurl];
	}

	return _touser_coverurl;
}

- (NSString *)fromuser_coverurl {
	if (![_fromuser_coverurl containStrings:@"jpg", @"JPG", nil]) {
		_fromuser_coverurl = nil;
	}
	else if (![_fromuser_coverurl containString:NETWORK_HOST])      {
		_fromuser_coverurl = [NETWORK_HOST addString:_fromuser_coverurl];
	}

	return _fromuser_coverurl;
}

- (void)setCreateDate:(double)createDate {
	_createDate = createDate;
	_timeString = [[NSDate dateWithTimeIntervalSince1970:self.createDate] string];
}

- (NSString *)timeString {
	return _timeString;
}

@end
