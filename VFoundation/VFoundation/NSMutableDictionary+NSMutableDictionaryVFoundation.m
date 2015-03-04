//
//  NSMutableDictionary+VFoundation.m
//  VFoundation
//
//  Created by JessieYong on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSMutableDictionary+NSMutableDictionaryVFoundation.h"
#import "VFoundation.h"
@implementation NSMutableDictionary (NSMutableDictionaryVFoundation)

__ENABLE_EXCHANGE_METHOD_AND_CLASS__(SELString(setObject : forKey :), @"__NSDictionaryM")


- (void)__exchange__setObject:(id)anObject forKey:(id <NSCopying> )aKey {
	if (anObject && aKey) {
		[self __exchange__setObject:anObject forKey:aKey];
	}
}

- (void)__self_exchange__setObject:(id)anObject forKey:(id <NSCopying> )aKey {
	if (anObject && aKey) {
		[self __self_exchange__setObject:anObject forKey:aKey];
	}
}

- (void)removeFirstObject {
	id key = [[self allKeys] firstObject];
	if (key != nil) {
		[self removeObjectForKey:key];
	}
}

- (void)removeLastObject {
	id key = [[self allKeys] lastObject];
	if (key != nil) {
		[self removeObjectForKey:key];
	}
}

- (void)removeDictionary:(NSDictionary *)dict {
	for (id key in[dict allKeys]) {
		[self removeObjectForKey:key];
	}
}

- (id)objectForKey:(id)aKey class:(Class)resultClass {
	id result = [self objectForKey:aKey];
	if (!result) {
		result = [[resultClass alloc] init];
		[self setObject:result forKey:aKey];
	}
	return result;
}

@end
