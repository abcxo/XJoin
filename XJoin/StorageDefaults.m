//
//  StorageDefaults.m
//  HighCBar
//
//  Created by shadow on 14-7-16.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "StorageDefaults.h"
#import "XJoin.h"

@implementation Defaults {
	@protected NSUserDefaults *_defaults;
}

- (void)setObject:(id)obj forKey:(id)aKey {
	[self.defaults setObject:obj forKey:aKey];
	[self.defaults synchronize];
}

- (id)objectForKey:(id)key {
	return [self.defaults objectForKey:key];
}

- (void)removeObjectForKey:(id)aKey {
	[self.defaults removeObjectForKey:aKey];
	[self.defaults synchronize];
}

- (NSUserDefaults *)defaults {
	if (!_defaults) {
		_defaults = [NSUserDefaults standardUserDefaults];
	}
	return _defaults;
}

@end


@implementation UserDefaults
- (NSUserDefaults *)defaults {
	if (!_defaults) {
		_defaults = [[NSUserDefaults alloc] initWithUser:@"user"];
	}
	return _defaults;
}

@end



@implementation AppDefaults
- (NSUserDefaults *)defaults {
	if (!_defaults) {
		_defaults = [[NSUserDefaults alloc] initWithUser:@"app"];
	}
	return _defaults;
}

@end

@implementation StorageDefaults
+ (UserDefaults *)userDefaults {
	return [UserDefaults sharedInstance];
}

+ (AppDefaults *)appDefaults {
	return [AppDefaults sharedInstance];
}

@end
