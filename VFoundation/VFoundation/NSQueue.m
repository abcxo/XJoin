//
//  NSQueue.m
//  VFoundation
//
//  Created by shadow on 14-3-27.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSQueue.h"
#import "VFoundation.h"
@interface NSQueue () {
	NSMutableArray *_mArray;
	NSUInteger _count;
}
@end
@implementation NSQueue
- (id)init {
	if (self = [super init]) {
		_mArray = [[NSMutableArray alloc] init];
		_count = 0;
	}
	return self;
}

- (NSUInteger)count {
	return _count;
}

- (void)enQueue:(id)anObject {
	[_mArray addObject:anObject];
	_count = _mArray.count;
}

- (id)deQueue {
	id obj = nil;
	if (_mArray.count > 0) {
		obj = [_mArray firstObject];
		[_mArray firstObject];
		_count = _mArray.count;
	}
	return obj;
}

- (id)peekQueue {
	return [_mArray firstObject];
}

- (void)clear {
	[_mArray removeAllObjects];
	_count = 0;
}

- (BOOL)isEmpty {
	BOOL isEmpty = [super isEmpty];
	if (!isEmpty) {
		isEmpty = [_mArray isEmpty];
	}
	return isEmpty;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id[])buffer count:(NSUInteger)len {
	return [_mArray countByEnumeratingWithState:state objects:buffer count:len];
}

@end
