//
//  NSMutableArray+VFoundation.m
//  VFoundation
//
//  Created by JessieYong on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSMutableArray+NSMutableArrayVFoundation.h"
#import "VFoundation.h"

@implementation NSMutableArray (NSMutableArrayVFoundation)
__ENABLE_EXCHANGE_METHOD_AND_CLASS__(SELString(addObject :), @"__NSArrayM")


- (void)__exchange__addObject:(id)anObject {
	if (anObject) {
		[self __exchange__addObject:anObject];
	}
}

- (void)__self_exchange__addObject:(id)anObject {
	if (anObject) {
		[self __self_exchange__addObject:anObject];
	}
}

- (void)removeFirstObject {
	if ([self count] > 0) {
		[self removeObjectAtIndex:0];
	}
}

- (id)objectAtIndex:(NSUInteger)index class:(Class)resultClass {
	id result = [self objectAtIndex:index];
	if (!result) {
		result = [[resultClass alloc] init];
		[self addObject:result];
	}
	return result;
}

- (id)firstObjectWithClass:(Class)resultClass; {
	id result = [self firstObject];
	if (!result) {
		result = [[resultClass alloc] init];
		[self addObject:result];
	}
	return result;
}

@end
