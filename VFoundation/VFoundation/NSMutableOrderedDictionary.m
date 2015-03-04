//
//  NSMutableOrderedDictionary.m
//  VFoundation
//
//  Created by shadow on 14-7-16.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSMutableOrderedDictionary.h"
#import "VFoundation.h"
@interface NSMutableOrderedDictionary () {
	NSMutableArray *_orderedArray;
	NSMutableDictionary *_orderedDict;
}

@end

@implementation NSMutableOrderedDictionary
- (instancetype)init {
	self = [super init];
	if (self) {
		_orderedArray = [[NSMutableArray alloc] init];
		_orderedDict = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)setObject:(id)anObject forKey:(id)aKey {
	[_orderedArray removeObject:aKey];
	[_orderedArray addObject:aKey];
	[_orderedDict setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey {
	[_orderedArray removeObject:aKey];
	[_orderedDict removeObjectForKey:aKey];
}

- (void)removeAllObjects {
	[_orderedArray removeAllObjects];
	[_orderedDict removeAllObjects];
}

- (NSUInteger)count {
	return [_orderedArray count];
}

- (id)objectForKey:(id)aKey {
	return [_orderedDict objectForKey:aKey];
}

- (id)objectAtIndex:(NSUInteger)index {
	return [self objectForKey:[_orderedArray objectAtIndex:index]];
}

- (NSUInteger)indexOfKey:(id)akey {
	return [_orderedArray indexOfObject:akey];
}

- (id)keyAtIndex:(NSUInteger)index {
	return [_orderedArray objectAtIndex:index];
}

- (NSEnumerator *)keyEnumerator {
	return [_orderedArray objectEnumerator];
}

- (NSArray *)allKeys {
	return _orderedArray;
}

- (NSArray *)allValues {
	return [_orderedArray arrayWithBlock: ^id (id obj, NSInteger index) {
	    return [_orderedDict objectForKey:obj];
	}];
}

@end
