//
//  NSDictionary+VFoundation.m
//  VFoundation
//
//  Created by JessieYong on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSDictionary+NSDictionaryVFoundation.h"
#import "VFoundation.h"


@implementation NSDictionary (NSDictionaryVFoundation)

__ENABLE_EXCHANGE_METHOD_AND_CLASS__(SELString(initWithObjects : forKeys : count :), @"__NSPlaceholderDictionary")



- (instancetype)__exchange__initWithObjects:(const id[])objects forKeys:(const id <NSCopying>[])keys count:(NSUInteger)cnt {
	BOOL isHasNil = NO;
	for (int i = 0; i < cnt; i++) {
		id obj = objects[i];
		id key = keys[i];
		if (!obj || !key) {
			isHasNil = YES;
			break;
		}
	}
	if (isHasNil) {
		return nil;
	}
	return [self __exchange__initWithObjects:objects forKeys:keys count:cnt];
}

- (instancetype)__self_exchange__initWithObjects:(const id[])objects forKeys:(const id <NSCopying>[])keys count:(NSUInteger)cnt {
	BOOL isHasNil = NO;
	for (int i = 0; i < cnt; i++) {
		id obj = objects[i];
		id key = keys[i];
		if (!obj || !key) {
			isHasNil = YES;
			break;
		}
	}
	if (isHasNil) {
		return nil;
	}
	return [self __self_exchange__initWithObjects:objects forKeys:keys count:cnt];
}

+ (NSDictionary *)dictionaryWithDictionaries:(NSDictionary *)dict, ...NS_REQUIRES_NIL_TERMINATION
{
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
	va_list ap;
	va_start(ap, dict);
	NSDictionary *d = dict;
	while (d) {
		d = va_arg(ap, id);
		if ([d isKindOfClass:[NSDictionary class]]) {
			[dic addEntriesFromDictionary:d];
		}
	}
	va_end(ap);
	return dic;
}

- (BOOL)isEmpty {
	BOOL isEmpty = [super isEmpty];
	if (!isEmpty) {
		isEmpty = !(self.count > 0 && self.count != NSNotFound);
	}
	return isEmpty;
}

@end

@implementation NSDictionary (NSDictionaryURL)

- (NSString *)toParameters {
	NSMutableArray *result = [[NSMutableArray alloc] init];
	for (NSString *key in[self allKeys]) {
		[result addObject:[key addFormat:@"=%@", [self objectForKey:key]]];
	}
	return [result componentsJoinedByString:@"&"];
}

@end
