//
//  UserEntity.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UserEntity.h"
#import "XJoin.h"
@interface UserEntity () {
	NSString *_from;
	NSString *_distance;
	NSString *_last_login;
}

@end
@implementation UserEntity
- (instancetype)init {
	self = [super init];
	if (self) {
		self.photos = [NSMutableArray array];
		self.photos.objectClassName = [NSString className];
	}
	return self;
}

+ (UserEntity *)mainUser {
	return [[UserEntity get:Format(@"id = %@", [[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_MAIN_UID])] firstObject];
}

- (BOOL)isMain {
	return [self.id isEqualToString:[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_MAIN_UID]];
}

- (NSURL *)avatarURL {
	if (self.isMain) {
		NSString *path = [self avatarFileUrl];
		if ([FileManager isFileExisted:path]) {
			return [path fileURL];
		}
	}
	return [self.coverurl URL];
}

- (NSString *)avatarFileUrl {
	NSString *path = [[FileManager documentsPath] stringByAppendingPathComponent:@"avatar.jpg"];
	return path;
}

- (NSString *)coverurl {
	if (![_coverurl containStrings:@"jpg", @"JPG", nil]) {
		_coverurl = nil;
	}
	else if (![_coverurl containString:NETWORK_HOST]) {
		_coverurl = [NETWORK_HOST addString:_coverurl];
	}

	return _coverurl;
}

- (void)setFrom:(NSString *)from {
	_from = from;
}

- (NSString *)from {
	return _from;
}

- (NSString *)region {
	if ([_region isMeaningful]) {
		return _region;
	}
	return self.from;
}

- (NSString *)distance {
	return _distance;
}

- (void)setDistance:(NSString *)distance {
	_distance = distance;
}

- (NSString *)last_login {
	return _last_login;
}

- (void)setLast_login:(NSString *)last_login {
	_last_login = last_login;
}

@end
