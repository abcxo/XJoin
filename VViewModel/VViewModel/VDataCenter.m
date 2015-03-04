//
//  VDataCenter.m
//  VViewModel
//
//  Created by shadow on 14-3-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "VDataCenter.h"
#import "VModel.h"

NSMutableArray *AllocNotRetainedMutableArray() {
	CFMutableArrayRef setRef = NULL;
	CFArrayCallBacks notRetainedCallbacks = kCFTypeArrayCallBacks;
	notRetainedCallbacks.retain = NULL;
	notRetainedCallbacks.release = NULL;
	setRef = CFArrayCreateMutable(kCFAllocatorDefault,
	                              0,
	                              &notRetainedCallbacks);
	return (__bridge NSMutableArray *)setRef;
}

@interface VDataCenter ()
@property (nonatomic, strong) NSMutableAtomicDictionary *dataSource;
@end

@implementation VDataCenter

- (instancetype)init {
	self = [super init];
	if (self) {
		self.dataSource = [[NSMutableAtomicDictionary alloc] init];
		self.observers = AllocNotRetainedMutableArray();
	}
	return self;
}

- (void)reloadData {
}

- (void)addObserver:(id <VDataCenterDelegate> )observer {
	[self.observers removeObject:observer];
	[self.observers addObject:observer];
}

- (void)removeObserver:(id <VDataCenterDelegate> )observer {
	[self.observers removeObject:observer];
}

- (void)removeObserverAtIndex:(NSInteger)index {
	[self.observers removeObjectAtIndex:index];
}

@end
