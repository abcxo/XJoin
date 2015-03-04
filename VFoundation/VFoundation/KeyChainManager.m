//
//  KeyChainManager.m
//  VFoundation
//
//  Created by shadow on 14-3-15.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "KeyChainManager.h"
#import "SFHFKeychainUtils.h"
static NSString *bundleIdentifier = nil;
@implementation KeyChainManager
+ (void)initialize {
	[super initialize];
	bundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
}

+ (BOOL)setObject:(id)object forKey:(id)key {
	if (object && key) {
		NSError *err = nil;
		[SFHFKeychainUtils storeUsername:key andPassword:object forServiceName:bundleIdentifier updateExisting:YES error:&err];
		if (!err) {
			return YES;
		}
	}
	return NO;
}

+ (id)objectForKey:(id)key {
	if (key) {
		NSError *err = nil;
		id object = [SFHFKeychainUtils getPasswordForUsername:key andServiceName:bundleIdentifier error:&err];
		if (!err) {
			return object;
		}
	}
	return nil;
}

+ (BOOL)removeObject:(id)key {
	if (key) {
		NSError *err = nil;
		BOOL isSuc = [SFHFKeychainUtils deleteItemForUsername:key andServiceName:bundleIdentifier error:&err];
		return isSuc;
	}
	return NO;
}

+ (BOOL)removeAllObject {
	NSError *err = nil;
	BOOL isSuc = [SFHFKeychainUtils purgeItemsForServiceName:bundleIdentifier error:&err];
	return isSuc;
}

@end
