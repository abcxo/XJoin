//
//  NSPriorityQueue.m
//  VFoundation
//
//  Created by shadow on 14-3-27.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSPriorityQueue.h"
@interface NSPriorityQueueNode : NSObject
@property (nonatomic, strong) id value;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, strong) NSComparator comparator;
@end

@implementation NSPriorityQueueNode
@end
CFComparisonResult NSPriorityQueueComparsionCallback(const void *ptr1, const void *ptr2, void *info);
void NSPriorityQueueApplyCallBack(const void *val, void *context);

@interface NSPriorityQueue ()
@property (nonatomic, copy) void (^enumerationBlock)(id object);
@property (nonatomic, copy) NSComparator comparator;
@end

@implementation NSPriorityQueue {
	CFBinaryHeapRef _binaryHeap;
}

#pragma mark - Init & Dealloc

- (void)dealloc {
	CFRelease(_binaryHeap);
}

- (instancetype)init {
	return [self initWithMaxHeap];
}

- (instancetype)initWithComparator:(NSComparator)comparator {
	NSParameterAssert(comparator);

	if (self) {
		_comparator = comparator;

		CFBinaryHeapCallBacks callbacks = {
			.version         = 0,
			.retain          = kCFStringBinaryHeapCallBacks.retain,
			.release         = kCFStringBinaryHeapCallBacks.release,
			.copyDescription = kCFStringBinaryHeapCallBacks.copyDescription,
			.compare         = &NSPriorityQueueComparsionCallback,
		};

		_binaryHeap = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &callbacks, NULL);
	}
	return self;
}

- (instancetype)initWithMinHeap {
	NSComparator comparator = ^NSComparisonResult (NSPriorityQueueNode *obj1, NSPriorityQueueNode *obj2) {
		return [@(obj1.priority)compare : @(obj2.priority)];
	};
	return [self initWithComparator:comparator];
}

- (instancetype)initWithMaxHeap {
	NSComparator comparator = ^NSComparisonResult (NSPriorityQueueNode *obj1, NSPriorityQueueNode *obj2) {
		return [@(obj2.priority)compare : @(obj1.priority)];
	};
	return [self initWithComparator:comparator];
}

- (NSUInteger)count {
	return (NSUInteger)CFBinaryHeapGetCount(_binaryHeap);
}

- (void)enQueue:(id)anObject {
	[self enQueue:anObject withPriority:NSQueuePriorityDefault];
}

- (void)enQueue:(id)anObject withPriority:(NSQueuePriority)priority {
	NSPriorityQueueNode *node = [[NSPriorityQueueNode alloc] init];
	node.value      = anObject;
	node.priority   = priority;
	node.comparator = self.comparator;
	NSAssert(_binaryHeap, nil);
	CFBinaryHeapAddValue(_binaryHeap, (void *)node);
}

- (void)jumpQueue:(id)anObject {
	[self enumerateObjectsUsingBlock: ^(id obj) {
	    NSPriorityQueueNode *node = (NSPriorityQueueNode *)obj;
	    if (node.priority == NSQueuePriorityMax) {
	        node.priority = NSQueuePriorityHigh;
		}
	}];
	[self enQueue:anObject withPriority:NSQueuePriorityMax];
}

- (id)deQueue {
	id value = [self peekQueue];
	CFBinaryHeapRemoveMinimumValue(_binaryHeap);
	return value;
}

- (id)peekQueue {
	NSPriorityQueueNode *node = (NSPriorityQueueNode *)CFBinaryHeapGetMinimum(_binaryHeap);
	if (node) {
		return node.value;
	}
	return nil;
}

- (void)clear {
	CFBinaryHeapRemoveAllValues(_binaryHeap);
}

- (BOOL)containsObject:(id)anObject {
	__block BOOL contains = NO;
	[self enumerateObjectsUsingBlock: ^(id obj) {
	    NSPriorityQueueNode *node = (NSPriorityQueueNode *)obj;
	    if ([node.value isEqual:anObject]) {
	        contains = YES;
		}
	}];
	return contains;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id[])buffer count:(NSUInteger)len {
	NSUInteger queueCount = [self count];
	NSUInteger count = 0;
	// We use state->state to track how far we have enumerated through _list
	// between sucessive invocations of -countByEnumeratingWithState:objects:count:
	unsigned long countOfItemsAlreadyEnumerated = state->state;
	// This is the initialization condition, so we'll do one-time setup here.
	// Ensure that you never set state->state back to 0, or use another method to
	// detect initialization (such as using one of the values of state->extra).
	if (countOfItemsAlreadyEnumerated == 0) {
		// We are not tracking mutations, so we'll set state->mutationsPtr to point
		// into one of our extra values, since these values are not otherwise used
		// by the protocol.
		// If your class was mutable, you may choose to use an internal variable that
		// is updated when the class is mutated.
		// state->mutationsPtr MUST NOT be NULL and SHOULD NOT be set to self.
		state->mutationsPtr = &state->extra[0];
	}
	// Now we provide items and determine if we have finished iterating.
	if (countOfItemsAlreadyEnumerated < queueCount) {
		// Set state->itemsPtr to the provided buffer.
		// state->itemsPtr MUST NOT be NULL.
		state->itemsPtr = buffer;
		// Fill in the stack array, either until we've provided all items from the list
		// or until we've provided as many items as the stack based buffer will hold.
		CFBinaryHeapRef tmpHeap = CFBinaryHeapCreateCopy(kCFAllocatorDefault, 0, _binaryHeap);
		id obj = nil;
		while ((obj = [self deQueue])) {
			buffer[count] = obj;
			countOfItemsAlreadyEnumerated++;
			// We must return how many items are in state->itemsPtr.
			count++;
		}
		_binaryHeap = CFBinaryHeapCreateCopy(kCFAllocatorDefault, 0, tmpHeap);
		CFRelease(tmpHeap);
	}
	else {
		// We've already provided all our items.  Signal that we are finished by returning 0.
		count = 0;
	}
	// Update state->state with the new value of countOfItemsAlreadyEnumerated so that it is
	// preserved for the next invocation.
	state->state = countOfItemsAlreadyEnumerated;

	return count;
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj))block {
	CFBinaryHeapApplyFunction(_binaryHeap, &NSPriorityQueueApplyCallBack, (void *)block);
}

@end

CFComparisonResult NSPriorityQueueComparsionCallback(
    const void *ptr1,
    const void *ptr2,
    void *      info
    ) {
	NSPriorityQueueNode *node1 = (__bridge NSPriorityQueueNode *)ptr1;
	NSPriorityQueueNode *node2 = (__bridge NSPriorityQueueNode *)ptr2;
	NSCAssert(node1.comparator == node2.comparator, @"All the node should have the same comparator");
	NSCAssert(node1.comparator != nil, nil);
	NSComparator comparator = node1.comparator;
	return (CFComparisonResult)comparator(node1, node2);
}

void NSPriorityQueueApplyCallBack(
    const void *val,
    void *      context
    ) {
	void (^block)(id object) = (__bridge void (^)(__strong id))(context);
	if (block) {
		NSPriorityQueueNode *node = (__bridge NSPriorityQueueNode *)(val);
		block(node);
	}
}
