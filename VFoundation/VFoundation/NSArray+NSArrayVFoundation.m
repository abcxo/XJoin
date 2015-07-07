//
//  NSArray+VFoundation.m
//  VFoundation
//
//  Created by JessieYong on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSArray+NSArrayVFoundation.h"
#import "VFoundation.h"
static const void *objectClassNameKey = &objectClassNameKey;
@implementation NSArray (NSArrayVFoundation)
@dynamic objectClassName;
#pragma mark - Exchange methods
__ENABLE_EXCHANGE_METHOD_AND_CLASS__(/*SELString(initWithObjects : count :), @"__NSPlaceholderArray",*/ SELString(objectAtIndex :), @"__NSArrayI")

- (instancetype)__exchange__initWithObjects:(const id[])objects count:(NSUInteger)cnt {
	BOOL isHasNil = NO;
	for (int i = 0; i < cnt; i++) {
		id obj = objects[i];
		if (!obj) {
			isHasNil = YES;
			break;
		}
	}
	if (isHasNil) {
		return nil;
	}
	return [self __exchange__initWithObjects:objects count:cnt];
}

- (instancetype)__self_exchange__initWithObjects:(const id[])objects count:(NSUInteger)cnt {
	BOOL isHasNil = NO;
	for (int i = 0; i < cnt; i++) {
		id obj = objects[i];
		if (!obj) {
			isHasNil = YES;
			break;
		}
	}
	if (isHasNil) {
		return nil;
	}
	return [self __self_exchange__initWithObjects:objects count:cnt];
}

- (id)__exchange__objectAtIndex:(NSUInteger)index {
	if (index < self.count) {
		return [self __exchange__objectAtIndex:index];
	}
	return nil;
}

- (void)setObjectClassName:(NSString *)objectClassName {
	objc_setAssociatedObject(self, objectClassNameKey, objectClassName, OBJC_ASSOCIATION_COPY);
}

- (NSString *)objectClassName {
	return objc_getAssociatedObject(self, objectClassNameKey);
}

- (BOOL)isEmpty {
	BOOL isEmpty = [super isEmpty];
	if (!isEmpty) {
		isEmpty = !(self.count > 0 && self.count != NSNotFound);
	}
	return isEmpty;
}

- (NSArray *)arrayWithBlock:(id (^)(id, NSInteger))block {
	NSMutableArray *result = [[NSMutableArray alloc] init];
	int i = 0;
	for (id obj in self) {
		id m = block(obj, i++);
		if (m) {
			if ([m isKindOfClass:[NSArray class]]) {
				[result addObjectsFromArray:m];
			}
			else {
				[result addObject:m];
			}
		}
	}
	return result;
}

@end
