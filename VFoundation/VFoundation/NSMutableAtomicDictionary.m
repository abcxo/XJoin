//
//  NSMutableAtomicDictionary.m
//  VFoundation
//
//  Created by shadow on 14-7-25.
//  Copyright (c) 2014年 SJ. All rights reserved.
//

#import "NSMutableAtomicDictionary.h"
#import "VFoundation.h"
@interface NSMutableAtomicDictionary () {
	NSMutableDictionary *_atomicDict;
}


@end
@implementation NSMutableAtomicDictionary
- (instancetype)init {
	@synchronized(self)
	{
		self = [super init];
		if (self) {
			_atomicDict = [[NSMutableDictionary alloc] init];
		}
		return self;
	}
}

- (NSUInteger)count {
	@synchronized(self)
	{
		return [_atomicDict count];
	}
}

- (void)setObject:(id)anObject forKey:(id <NSCopying> )aKey {
	@synchronized(self)
	{
		[_atomicDict setObject:anObject forKey:aKey];
	}
}

- (void)setDictionary:(NSDictionary *)otherDictionary {
	@synchronized(self)
	{
		[_atomicDict setDictionary:otherDictionary];
	}
}

- (id)objectForKey:(id)aKey {
	@synchronized(self)
	{
		return [_atomicDict objectForKey:aKey];
	}
}

- (id)objectForKey:(id)aKey class:(Class)resultClass {
	@synchronized(self)
	{
		return [_atomicDict objectForKey:aKey class:resultClass];
	}
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
	@synchronized(self)
	{
		[_atomicDict addEntriesFromDictionary:otherDictionary];
	}
}

- (void)removeObjectsForKeys:(NSArray *)keyArray {
	@synchronized(self)
	{
		[_atomicDict removeObjectsForKeys:keyArray];
	}
}

- (void)removeObjectForKey:(id)aKey {
	@synchronized(self)
	{
		[_atomicDict removeObjectForKey:aKey];
	}
}

- (void)removeLastObject {
	@synchronized(self)
	{
		[_atomicDict removeLastObject];
	}
}

- (void)removeFirstObject {
	@synchronized(self)
	{
		[_atomicDict removeFirstObject];
	}
}

- (void)removeDictionary:(NSDictionary *)dict {
	@synchronized(self)
	{
		[_atomicDict removeDictionary:dict];
	}
}

- (void)removeAllObjects {
	@synchronized(self)
	{
		[_atomicDict removeAllObjects];
	}
}

- (NSArray *)allKeys {
	@synchronized(self)
	{
		return [_atomicDict allKeys];
	}
}

- (NSArray *)allValues {
	@synchronized(self)
	{
		return [_atomicDict allValues];
	}
}

- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id, id, BOOL *))block {
	@synchronized(self)
	{
		return [_atomicDict enumerateKeysAndObjectsWithOptions:opts usingBlock:block];
	}
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id, id, BOOL *))block {
	@synchronized(self)
	{
		[_atomicDict enumerateKeysAndObjectsUsingBlock:block];
	}
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id[])buffer count:(NSUInteger)len {
	@synchronized(self)
	{
		return [_atomicDict countByEnumeratingWithState:state objects:buffer count:len];
	}
}

@end
