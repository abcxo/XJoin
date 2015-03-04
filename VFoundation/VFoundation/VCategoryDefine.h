//
//  VCategoryDefine.h
//  VFoundation
//
//  Created by shadow on 14-3-11.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>



#define MINUTES_DURATION 60
#define HOUR_DURATION (60 * MINUTES_DURATION)
#define DAY_DURATION (24 * HOUR_DURATION)
#define MONTH_DURATION (30 * DAY_DURATION)
#define YEAR_DURATION (12 * MONTH_DURATION)
#define TIMESTAMP_FORMAT @"yyyy-MM-dd HH:mm:ss"
#define DATESTRING_FORMAT @"yyyy年MM月dd日HH:mm"
#define DATESTRING_YEAR_MONTH_FORMAT @"yy年MM月"



#define SELString(a) NSStringFromSelector(@selector(a))
#define SELSEL(a) NSSelectorFromString(a)
#define ClassString(a) NSStringFromClass([a class])
#define ClassClass(a) NSClassFromString(a)
#define Format(string, args...) [NSString stringWithFormat : string, args]

#define EXCHANGE_METHOD(str) [@"__exchange__" addString : str]
#define EXCHANGE_SELF_METHOD(str) [@"__self_exchange__" addString : str]



#define __ENABLE_EXCHANGE_METHOD__(param, ...) \
	+ (void)load { \
		static dispatch_once_t onceToken; \
		dispatch_once(&onceToken, ^{ \
		    NSDictionary *mapping = [self exchangeMethodMapping]; \
		    if ([mapping isMeaningful]) { \
		        for (NSString *fromSELStr in[mapping allKeys]) { \
		            NSString *toSELStr = EXCHANGE_METHOD(fromSELStr); \
		            NSString *toSelfSELStr = EXCHANGE_SELF_METHOD(fromSELStr); \
		            if ([self instancesRespondToSelector:NSSelectorFromString(toSELStr)] || [self respondsToSelector:NSSelectorFromString(toSELStr)]) { \
		                Class class = ClassClass([mapping objectForKey:fromSELStr]); \
		                Class resultClass = self; \
		                if (class != self) { \
		                    Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(fromSELStr)); \
		                    Method originalSelfMethod = class_getInstanceMethod(self, NSSelectorFromString(fromSELStr)); \
		                    Method categoryMethod = class_getInstanceMethod(resultClass, NSSelectorFromString(toSELStr)); \
		                    Method categorySelfMethod = class_getInstanceMethod(self, NSSelectorFromString(toSelfSELStr)); \
		                    method_exchangeImplementations(originalMethod, categoryMethod); \
		                    method_exchangeImplementations(originalSelfMethod, categorySelfMethod); \
		                    Method originalClassMethod = class_getClassMethod(class, NSSelectorFromString(fromSELStr)); \
		                    Method originalSelfClassMethod = class_getClassMethod(self, NSSelectorFromString(fromSELStr)); \
		                    Method categoryClassMethod = class_getClassMethod(resultClass, NSSelectorFromString(toSELStr)); \
		                    Method categorySelfClassMethod = class_getClassMethod(self, NSSelectorFromString(toSelfSELStr)); \
		                    method_exchangeImplementations(originalClassMethod, categoryClassMethod); \
		                    method_exchangeImplementations(originalSelfClassMethod, categorySelfClassMethod); \
						} \
		                else { \
		                    Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(fromSELStr)); \
		                    Method categoryMethod = class_getInstanceMethod(resultClass, NSSelectorFromString(toSELStr)); \
		                    method_exchangeImplementations(originalMethod, categoryMethod); \
		                    Method originalClassMethod = class_getClassMethod(class, NSSelectorFromString(fromSELStr)); \
		                    Method categoryClassMethod = class_getClassMethod(resultClass, NSSelectorFromString(toSELStr)); \
		                    method_exchangeImplementations(originalClassMethod, categoryClassMethod); \
						} \
					} \
				} \
			} \
		}); \
	} \
	+ (NSDictionary *)exchangeMethodMapping { \
		NSMutableDictionary *result = nil; \
		if (!result) { \
			result = [[NSMutableDictionary alloc] init]; \
		} \
		NSArray *array = @[param, ## __VA_ARGS__]; \
		for (id key in array) { \
			if (key) { \
				[result setObject:ClassString(self) forKey:key]; \
			} \
		} \
		return result; \
	} \



#define __ENABLE_EXCHANGE_METHOD_AND_CLASS__(param, ...) \
	+ (void)load { \
		static dispatch_once_t onceToken; \
		dispatch_once(&onceToken, ^{ \
		    NSDictionary *mapping = [self exchangeMethodMapping]; \
		    if ([mapping isMeaningful]) { \
		        for (NSString *fromSELStr in[mapping allKeys]) { \
		            NSString *toSELStr = EXCHANGE_METHOD(fromSELStr); \
		            NSString *toSelfSELStr = EXCHANGE_SELF_METHOD(fromSELStr); \
		            if ([self instancesRespondToSelector:NSSelectorFromString(toSELStr)] || [self respondsToSelector:NSSelectorFromString(toSELStr)]) { \
		                Class class = ClassClass([mapping objectForKey:fromSELStr]); \
		                Class resultClass = self; \
		                if (class != self) { \
		                    Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(fromSELStr)); \
		                    Method originalSelfMethod = class_getInstanceMethod(self, NSSelectorFromString(fromSELStr)); \
		                    Method categoryMethod = class_getInstanceMethod(resultClass, NSSelectorFromString(toSELStr)); \
		                    Method categorySelfMethod = class_getInstanceMethod(self, NSSelectorFromString(toSelfSELStr)); \
		                    method_exchangeImplementations(originalMethod, categoryMethod); \
		                    method_exchangeImplementations(originalSelfMethod, categorySelfMethod); \
		                    Method originalClassMethod = class_getClassMethod(class, NSSelectorFromString(fromSELStr)); \
		                    Method originalSelfClassMethod = class_getClassMethod(self, NSSelectorFromString(fromSELStr)); \
		                    Method categoryClassMethod = class_getClassMethod(resultClass, NSSelectorFromString(toSELStr)); \
		                    Method categorySelfClassMethod = class_getClassMethod(self, NSSelectorFromString(toSelfSELStr)); \
		                    method_exchangeImplementations(originalClassMethod, categoryClassMethod); \
		                    method_exchangeImplementations(originalSelfClassMethod, categorySelfClassMethod); \
						} \
		                else { \
		                    Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(fromSELStr)); \
		                    Method categoryMethod = class_getInstanceMethod(resultClass, NSSelectorFromString(toSELStr)); \
		                    method_exchangeImplementations(originalMethod, categoryMethod); \
		                    Method originalClassMethod = class_getClassMethod(class, NSSelectorFromString(fromSELStr)); \
		                    Method categoryClassMethod = class_getClassMethod(resultClass, NSSelectorFromString(toSELStr)); \
		                    method_exchangeImplementations(originalClassMethod, categoryClassMethod); \
						} \
					} \
				} \
			} \
		}); \
	} \
	+ (NSDictionary *)exchangeMethodMapping { \
		NSMutableDictionary *result = nil; \
		if (!result) { \
			result = [[NSMutableDictionary alloc] init]; \
		} \
		NSArray *array = @[param, ## __VA_ARGS__]; \
		for (int i = 0; i < array.count; i++) { \
			id key = [array objectAtIndex:i++]; \
			id obj = [array objectAtIndex:i]; \
			if (key && obj) { \
				[result setObject:obj forKey:key]; \
			} \
		} \
		return result; \
	} \

typedef NS_ENUM (NSInteger, NSValueType) {
	NSValueTypeInt,
	NSValueTypeUInt,
	NSValueTypeShort,
	NSValueTypeUShort,
	NSValueTypeLong,
	NSValueTypeULong,
	NSValueTypeLongLong,
	NSValueTypeULongLong,
	NSValueTypeBool,
	NSValueTypeFloat,
	NSValueTypeDouble,
	NSValueTypeChar,
	NSValueTypeUChar,
	NSValueTypeUnKnown,
};



@interface VCategoryDefine : NSObject

@end
