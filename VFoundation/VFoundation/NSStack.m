//
//  NSStack.m
//  VFoundation
//
//  Created by shadow on 14-3-27.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSStack.h"
#import "VFoundation.h"
#define USE_STACKBUF YES
@interface NSStack () {
	NSMutableArray *_mArray;
	NSUInteger _count;
}
@end
@implementation NSStack
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

- (void)push:(id)anObject {
	[_mArray addObject:anObject];
	_count = _mArray.count;
}

- (id)pop {
	id obj = nil;
	if (_mArray.count > 0) {
		obj = [_mArray lastObject];
		[_mArray removeLastObject];
		_count = _mArray.count;
	}
	return obj;
}

- (id)peek {
	return [_mArray lastObject];
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
