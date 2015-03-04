//
//  NSObject+VFoundation.m
//  VFoundation
//
//  Created by shadow on 14-3-11.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSObject+NSObjectVFoundation.h"
#import "VFoundation.h"
@implementation NSProperty

@end

@implementation NSObject (NSObjectVFoundation)


+ (instancetype)sharedInstance {
	static dispatch_once_t once;
	static NSMutableDictionary *instanceDict;
	dispatch_once(&once, ^{
	    instanceDict = [[NSMutableDictionary alloc] init];
	});
	NSString *instanceKey = NSStringFromClass([self class]);
	id sharedInstance = [instanceDict objectForKey:instanceKey];
	if (!sharedInstance) {
		sharedInstance = [[[self class] alloc] init];
		[instanceDict setObject:sharedInstance forKey:instanceKey];
	}
	return sharedInstance;
}

+ (instancetype)sharedInstance:(id)obj {
	static dispatch_once_t once;
	static NSMutableDictionary *instanceDict;
	dispatch_once(&once, ^{
	    instanceDict = [[NSMutableDictionary alloc] init];
	});
	NSString *instanceKey = NSStringFromClass([self class]);
	id sharedInstance = [instanceDict objectForKey:instanceKey];
	if (!sharedInstance) {
		sharedInstance = obj;
		[instanceDict setObject:sharedInstance forKey:instanceKey];
	}
	return sharedInstance;
}

/**
 *  catch the error of setValue for undefined key
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
//	NSAssert(NO, @"setValue:%@ for undefinedKey:%@", value, key);
}

- (id)valueForUndefinedKey:(NSString *)key {
	return nil;
}

- (NSString *)toJson {
	return nil;
}

+ (id)toObject:(NSDictionary *)json {
	if (json) {
		id result = [[self alloc] init];
		for (NSString *key in[json allKeys]) {
			id value = [json objectForKey:key];
			if ([key isMeaningful] && [value isMeaningful]) {
				if ([value isKindOfClass:[NSArray class]] && [[result valueForKey:key] isKindOfClass:[NSArray class]]) { //假如是nsarray，繼續parse
					NSString *objectClassName = ((NSArray *)[result valueForKey:key]).objectClassName;
					if ([objectClassName isMeaningful] && ![objectClassName isEqualToString:[NSString className]]) {
						value = [ClassClass(objectClassName) toObjects:value];
					}
				}
				[result setValue:value forKey:key];
			}
		}
		return result;
	}
	return nil;
}

+ (id)toObjects:(NSArray *)json {
	if (json) {
		NSMutableArray *result = [[NSMutableArray alloc] init];
		for (NSDictionary *dict in json) {
			[result addObject:[self toObject:dict]];
		}
		return result;
	}
	return nil;
}

- (BOOL)isEmpty {
	return [self isEqual:[NSNull null]];
}

- (BOOL)isMeaningful {
	return ![self isEmpty];
}

#pragma mark -
- (NSArray *)allProperties {
	NSMutableArray *result = [[NSMutableArray alloc] init];
	unsigned int numberOfProperties = 0;
	objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
	for (NSUInteger i = 0; i < numberOfProperties; i++) {
		NSProperty *mProperty = [[NSProperty alloc] init];
		objc_property_t property = propertyArray[i];
		NSString *attribute = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
		const char *rawPropertyType = [[[[[attribute componentsSeparatedByString:@","] firstObject] substringFromIndex:1] deleteStrings:@"@", @"\"", nil] UTF8String];
		NSValue *rawPropertyTypeValue = [NSValue valueWithBytes:&rawPropertyType objCType:rawPropertyType];
		//get type
		NSDataVType type = [rawPropertyTypeValue dataVType];
		id propertyType = [rawPropertyTypeValue objectType];
		NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
		id value = [self valueForKey:name];
		mProperty.propertyType = propertyType;
		mProperty.type = type;
		mProperty.name = name;
		mProperty.value = value;
		mProperty.parentClass = [self className];
		[result addObject:mProperty];
	}
	free(propertyArray);
	return result;
}

+ (NSArray *)allProperties {
	NSMutableArray *result = [[NSMutableArray alloc] init];
	unsigned int numberOfProperties = 0;
	objc_property_t *propertyArray = class_copyPropertyList(self, &numberOfProperties);
	for (NSUInteger i = 0; i < numberOfProperties; i++) {
		NSProperty *mProperty = [[NSProperty alloc] init];
		objc_property_t property = propertyArray[i];
		NSString *attribute = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
		const char *rawPropertyType = [[[[[attribute componentsSeparatedByString:@","] firstObject] substringFromIndex:1] deleteStrings:@"@", @"\"", nil] UTF8String];
		NSValue *rawPropertyTypeValue = [NSValue valueWithBytes:&rawPropertyType objCType:rawPropertyType];
		//get type
		NSDataVType type = [rawPropertyTypeValue dataVType];
		id propertyType = [rawPropertyTypeValue objectType];
		NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
		id value = nil;
		mProperty.propertyType = propertyType;
		mProperty.type = type;
		mProperty.name = name;
		mProperty.value = value;
		mProperty.parentClass = [self className];
		[result addObject:mProperty];
	}
	free(propertyArray);
	return result;
}

- (NSProperty *)primaryProperty {
	return [[self allProperties] firstObject];
}

+ (NSProperty *)primaryProperty {
	return [[self allProperties] firstObject];
}

- (NSProperty *)propertyForKey:(NSString *)str {
	for (NSProperty *mProperty in[self allProperties]) {
		NSString *name = mProperty.name;
		if ([str isEqualToString:name]) {
			return mProperty;
		}
	}
	return nil;
}

+ (NSProperty *)propertyForKey:(NSString *)str {
	for (NSProperty *mProperty in[self allProperties]) {
		NSString *name = mProperty.name;
		if ([str isEqualToString:name]) {
			return mProperty;
		}
	}
	return nil;
}

- (NSString *)className {
	return ClassString(self);
}

+ (NSString *)className {
	return ClassString(self);
}

#pragma mark - NSObect nscoding
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [self init]) {
		for (NSProperty *mProperty in[self allProperties]) {
			NSString *name = mProperty.name;
			[self setValue:[decoder decodeObjectForKey:name] forKey:name];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	for (NSProperty *mProperty in[self allProperties]) {
		NSString *name = mProperty.name;
		NSString *value = mProperty.value;
		[encoder encodeObject:value forKey:name];
	}
}

#pragma mark - NSObect nscopying
- (id)copyWithZone:(NSZone *)zone {
	id result = [[[self class] allocWithZone:zone] init];
	for (NSProperty *mProperty in[result allProperties]) {
		NSString *name = mProperty.name;
		[result setValue:[self valueForKey:name] forKey:name];
	}
	return result;
}

#pragma mark - NSObect nsmutablecopying
- (id)mutableCopyWithZone:(NSZone *)zone {
	id result = [[[self class] allocWithZone:zone] init];
	for (NSProperty *mProperty in[result allProperties]) {
		NSString *name = mProperty.name;
		[result setValue:[self valueForKey:name] forKey:name];
	}
	return result;
}

#pragma mark - NSObect nsdeepcopying
- (id)deepCopy {
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
	return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - NSObect nstransformcopying
- (id)transformCopy:(Class)class {
	id result = [[class alloc] init];
	for (NSProperty *mProperty in[result allProperties]) {
		NSString *name = mProperty.name;
		[result setValue:[self valueForKey:name] forKey:name];
	}
	return result;
}

@end

@implementation NSObject (NSObjectDataType)
- (id)objectType {
	if ([self isKindOfClass:[NSValue class]]) {
		NSValueType type = [(NSValue *)self valueType];
		if (type == NSValueTypeUnKnown) {
			return [[NSString alloc] initWithUTF8String:[(NSValue *)self objCType]];
		}
		else {
			return @(type);
		}
	}
	return NSStringFromClass([self class]);
}

- (NSDataVType)dataVType {
	NSDataVType type = NSDataVTypeBlob;
	if ([self isKindOfClass:[NSValue class]]) {
		NSValue *obj = (NSValue *)self;
		NSValueType valueType = [obj valueType];
		if (valueType == NSValueTypeInt
		    || valueType == NSValueTypeUInt
		    || valueType == NSValueTypeShort
		    || valueType == NSValueTypeUShort
		    || valueType == NSValueTypeLong
		    || valueType == NSValueTypeULong
		    || valueType == NSValueTypeLongLong
		    || valueType == NSValueTypeULongLong
		    || valueType == NSValueTypeBool
		    ) {
			type = NSDataVTypeInteger;
		}
		else if (valueType == NSValueTypeFloat
		         || valueType == NSValueTypeDouble) {
			type = NSDataVTypeReal;
		}

		else {
			NSString *str = [[NSString alloc] initWithUTF8String:[obj objCType]];
			Class class = NSClassFromString(str);
			if ([class isSubclassOfClass:[NSString class]]) {
				type = NSDataVTypeText;
			}
		}
	}
	else if ([self isKindOfClass:[NSString class]]) {
		type = NSDataVTypeText;
	}

	return type;
}

+ (NSString *)dataVTypeToString:(NSDataVType)type {
	switch (type) {
		case NSDataVTypeInteger:
			return @"INTEGER";
			break;

		case NSDataVTypeReal:
			return @"REAL";
			break;

		case NSDataVTypeText:
			return @"TEXT";
			break;

		case NSDataVTypeBlob:
			return @"BLOB";
			break;

		case NSDataVTypeNull:
			return @"INTEGER";
			break;


		default:
			break;
	}
}

@end
