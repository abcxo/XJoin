//
//  ActivityEntity.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "ActivityEntity.h"
#import "XJoin.h"
@interface ActivityEntity () {
	NSString *_beginDateString;
	NSString *_endDateString;
	LocationEntity *_locationEntity;
}

@end

@implementation ActivityEntity
- (instancetype)init {
	self = [super init];
	if (self) {
		self.participators = [NSMutableArray array];
		self.participators.objectClassName = [ParticipatorEntity className];
		self.photos =  [NSMutableArray array];
		self.photos.objectClassName = [NSString className];
	}
	return self;
}

- (NSString *)activitycover {
	if (![_activitycover containStrings:@"jpg", @"JPG", nil]) {
		_activitycover = nil;
	}
	else if (![_activitycover containString:NETWORK_HOST]) {
		_activitycover = [NETWORK_HOST addString:_activitycover];
	}

	return _activitycover;
}

- (void)setBegin_date:(double)begin_date {
	_begin_date = begin_date;
	_beginDateString = [[NSDate dateWithTimeIntervalSince1970:self.begin_date] string];
}

- (void)setEnd_date:(double)end_date {
	_end_date = end_date;
	_endDateString = [[NSDate dateWithTimeIntervalSince1970:self.end_date] string];
}

- (NSString *)beginDateString {
	return _beginDateString;
}

- (NSString *)endDateString {
	return _endDateString;
}

- (void)setLocation:(NSString *)location {
	_location = location;
	self.locationEntity = [LocationEntity entityWithString:self.location];
}

- (LocationEntity *)locationEntity {
	return _locationEntity;
}

- (void)setLocationEntity:(LocationEntity *)locationEntity {
	_locationEntity = locationEntity;
}

- (BOOL)isMain {
	return [self.creator isEqualToString:[UserEntity mainUser].id];
}

- (NSString *)userstate {
	if (![_userstate isMeaningful]) {
		_userstate = @"";
	}
	return _userstate;
}

@end
