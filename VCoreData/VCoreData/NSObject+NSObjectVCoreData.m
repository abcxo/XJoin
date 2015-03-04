//
//  NSObject+NSObjectVCoreData.m
//  VCoreData
//
//  Created by shadow on 14-3-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSObject+NSObjectVCoreData.h"
#import "VCoreData.h"
@implementation NSObject (NSObjectVCoreData)


- (BOOL)put {
	VCoreDataAddRequest *addRequest = [[VCoreDataAddRequest alloc] init];
	addRequest.objects = @[self];
	return [[VCoreDataController sharedInstance] addData:addRequest];
}

+ (BOOL)puts:(NSArray *)array {
	VCoreDataAddRequest *addRequest = [[VCoreDataAddRequest alloc] init];
	addRequest.objects = [array arrayWithBlock: ^id (id obj, NSInteger index) {
	    return obj;
	}];
	return [[VCoreDataController sharedInstance] addData:addRequest];
}

- (NSArray *)all {
	return [self get:nil];
}

+ (NSArray *)all {
	return [self get:nil];
}

- (NSArray *)get:(NSString *)filter {
	VCoreDataQueryRequest *queryRequest = [[VCoreDataQueryRequest alloc] init];
	queryRequest.filter = filter;
	queryRequest.properties = [self allProperties];
	queryRequest.resultClass = [self className];
	queryRequest.classes = @[[self className]];
	return [[VCoreDataController sharedInstance] queryData:queryRequest];
}

+ (NSArray *)get:(NSString *)filter {
	id obj = [[self alloc] init];
	return [obj get:filter];
}

- (NSArray *)get:(NSString *)filter properties:(NSArray *)array {
	NSMutableArray *propertyArray = [[NSMutableArray alloc] init];
	for (NSString *str in array) {
		NSProperty *mProperty = [self propertyForKey:str];
		[propertyArray addObject:mProperty];
	}
	VCoreDataQueryRequest *queryRequest = [[VCoreDataQueryRequest alloc] init];
	queryRequest.filter = filter;
	queryRequest.properties = propertyArray;
	queryRequest.resultClass = [self className];
	queryRequest.classes = @[[self className]];
	return [[VCoreDataController sharedInstance] queryData:queryRequest];
}

+ (NSArray *)get:(NSString *)filter properties:(NSArray *)array {
	id obj = [[self alloc] init];
	return [obj get:filter properties:array];
}

+ (NSArray *)gets:(NSArray *)objs filter:(NSString *)filter properties:(NSArray *)array result:(NSString *)resultClass {
	NSMutableArray *propertyArray = [[NSMutableArray alloc] init];
	for (NSString *str in array) {
		for (id obj in objs) {
			NSProperty *mProperty = [ClassClass(obj) propertyForKey:str];
			if (mProperty) {
				[propertyArray addObject:mProperty];
				break;
			}
		}
	}
	VCoreDataQueryRequest *queryRequest = [[VCoreDataQueryRequest alloc] init];
	queryRequest.filter = filter;
	queryRequest.properties = propertyArray;
	queryRequest.resultClass = resultClass;
	queryRequest.classes = [objs arrayWithBlock: ^id (id obj, NSInteger index) {
	    return [obj className];
	}];
	return [[VCoreDataController sharedInstance] queryData:queryRequest];
}

- (BOOL)update {
	return [self update:nil];
}

- (BOOL)update:(NSString *)filter {
	VCoreDataUpdateRequest *updateRequest = [[VCoreDataUpdateRequest alloc] init];
	updateRequest.filter = filter;
	updateRequest.properties = [self allProperties];
	updateRequest.objects = @[self];
	return [[VCoreDataController sharedInstance] updateData:updateRequest];
}

+ (BOOL)update:(NSString *)filter {
	id obj = [[self alloc] init];
	return [obj update:filter];
}

- (BOOL)update:(NSString *)filter properties:(NSArray *)array {
	NSMutableArray *propertyArray = [[NSMutableArray alloc] init];
	for (NSString *str in array) {
		NSProperty *mProperty = [self propertyForKey:str];
		[propertyArray addObject:mProperty];
	}
	VCoreDataUpdateRequest *updateRequest = [[VCoreDataUpdateRequest alloc] init];
	updateRequest.filter = filter;
	updateRequest.properties = propertyArray;
	updateRequest.objects = @[self];

	return [[VCoreDataController sharedInstance] updateData:updateRequest];
}

+ (BOOL)update:(NSString *)filter properties:(NSArray *)array {
	id obj = [[self alloc] init];
	return [obj update:filter properties:array];
}

+ (BOOL)updates:(NSArray *)objs filter:(NSString *)filter properties:(NSArray *)array {
	NSMutableArray *propertyArray = [[NSMutableArray alloc] init];
	for (NSString *str in array) {
		for (id obj in objs) {
			NSProperty *mProperty = [obj propertyForKey:str];
			if (mProperty) {
				[propertyArray addObject:mProperty];
				break;
			}
		}
	}
	VCoreDataUpdateRequest *updateRequest = [[VCoreDataUpdateRequest alloc] init];
	updateRequest.filter = filter;
	updateRequest.properties = propertyArray;
	updateRequest.objects = [objs arrayWithBlock: ^id (id obj, NSInteger index) {
	    return obj;
	}];
	return [[VCoreDataController sharedInstance] updateData:updateRequest];
}

- (BOOL)clear {
	return [self del:nil];
}

+ (BOOL)clear {
	return [self del:nil];
}

- (BOOL)del:(NSString *)filter {
	VCoreDataDelRequest *delRequest = [[VCoreDataDelRequest alloc] init];
	delRequest.filter = filter;
	delRequest.properties = [self allProperties];
	delRequest.classes = @[[self className]];
	return [[VCoreDataController sharedInstance] deleteData:delRequest];
}

- (BOOL)del {
	NSProperty *property = [self primaryProperty];
	if (property.type == NSDataVTypeText) {
		return [self del:Format(@"%@ = '%@'", property.name, property.value)];
	}
	else if (property.type == NSDataVTypeInteger || property.type == NSDataVTypeReal) {
		return [self del:Format(@"%@ = %@", property.name, property.value)];
	}
	return NO;
}

+ (BOOL)del:(NSString *)filter {
	id obj = [[self alloc] init];
	return [obj del:filter];
}

+ (BOOL)del:(NSArray *)objs filter:(NSString *)filter {
	VCoreDataDelRequest *delRequest = [[VCoreDataDelRequest alloc] init];
	delRequest.filter = filter;
	delRequest.properties = [self allProperties];
	delRequest.classes = [objs arrayWithBlock: ^id (id obj, NSInteger index) {
	    return [obj className];
	}];
	return [[VCoreDataController sharedInstance] deleteData:delRequest];
}

- (id)execute:(NSString *)command params:(id)param, ...{
	NSMutableArray *paramArray = [[NSMutableArray alloc] init];
	NSProperty *mProperty = [[NSProperty alloc] init];
	mProperty.name = nil;
	mProperty.propertyType = [param objectType];
	mProperty.type = [param dataVType];
	mProperty.value = param;
	[paramArray addObject:mProperty];

	va_list argList;
	va_start(argList, param);
	id arg = nil;
	while ((arg = va_arg(argList, id)) != nil) {
		NSProperty *mProperty = [[NSProperty alloc] init];
		mProperty.name = nil;
		mProperty.propertyType = [arg objectType];
		mProperty.type = [arg dataVType];
		mProperty.value = arg;
		[paramArray addObject:mProperty];
	}
	va_end(argList);
	VCoreDataExecuteRequest *exexuteRequest = [[VCoreDataExecuteRequest alloc] init];
	exexuteRequest.command = command;
	exexuteRequest.paramArray = paramArray;
	return [[VCoreDataController sharedInstance] executeData:exexuteRequest];
}

+ (id)execute:(NSString *)command params:(id)param, ...{
	NSMutableArray *paramArray = [[NSMutableArray alloc] init];
	NSProperty *mProperty = [[NSProperty alloc] init];
	mProperty.name = nil;
	mProperty.propertyType = [param objectType];
	mProperty.type = [param dataVType];
	mProperty.value = param;
	[paramArray addObject:mProperty];

	va_list argList;
	va_start(argList, param);
	id arg = nil;
	while ((arg = va_arg(argList, id)) != nil) {
		NSProperty *mProperty = [[NSProperty alloc] init];
		mProperty.name = nil;
		mProperty.propertyType = [arg objectType];
		mProperty.type = [arg dataVType];
		mProperty.value = arg;
		[paramArray addObject:mProperty];
	}
	va_end(argList);
	VCoreDataExecuteRequest *exexuteRequest = [[VCoreDataExecuteRequest alloc] init];
	exexuteRequest.command = command;
	exexuteRequest.paramArray = paramArray;
	return [[VCoreDataController sharedInstance] executeData:exexuteRequest];
}

- (id)executeWithPersistorType:(VCoreDataPersistorType)type command:(NSString *)command params:(id)param, ...{
	NSMutableArray *paramArray = [[NSMutableArray alloc] init];
	NSProperty *mProperty = [[NSProperty alloc] init];
	mProperty.name = nil;
	mProperty.propertyType = [param objectType];
	mProperty.type = [param dataVType];
	mProperty.value = param;
	[paramArray addObject:mProperty];

	va_list argList;
	va_start(argList, param);
	id arg = nil;
	while ((arg = va_arg(argList, id)) != nil) {
		NSProperty *mProperty = [[NSProperty alloc] init];
		mProperty.name = nil;
		mProperty.propertyType = [arg objectType];
		mProperty.type = [arg dataVType];
		mProperty.value = arg;
		[paramArray addObject:mProperty];
	}
	va_end(argList);
	VCoreDataExecuteRequest *exexuteRequest = [[VCoreDataExecuteRequest alloc] init];
	exexuteRequest.command = command;
	exexuteRequest.paramArray = paramArray;
	return [[VCoreDataController sharedInstance] executeData:exexuteRequest];
}

+ (id)executeWithPersistorType:(VCoreDataPersistorType)type command:(NSString *)command params:(id)param, ...{
	NSMutableArray *paramArray = [[NSMutableArray alloc] init];
	NSProperty *mProperty = [[NSProperty alloc] init];
	mProperty.name = nil;
	mProperty.propertyType = [param objectType];
	mProperty.type = [param dataVType];
	mProperty.value = param;
	[paramArray addObject:mProperty];

	va_list argList;
	va_start(argList, param);
	id arg = nil;
	while ((arg = va_arg(argList, id)) != nil) {
		NSProperty *mProperty = [[NSProperty alloc] init];
		mProperty.name = nil;
		mProperty.propertyType = [arg objectType];
		mProperty.type = [arg dataVType];
		mProperty.value = arg;
		[paramArray addObject:mProperty];
	}
	va_end(argList);
	VCoreDataExecuteRequest *exexuteRequest = [[VCoreDataExecuteRequest alloc] init];
	exexuteRequest.command = command;
	exexuteRequest.paramArray = paramArray;
	return [[VCoreDataController sharedInstance] executeData:exexuteRequest];
}

- (id)dataWithRequest:(VCoreDataRequest *)request {
	if ([request isKindOfClass:[VCoreDataQueryRequest class]]) {
		return [[VCoreDataController sharedInstance] queryData:(VCoreDataQueryRequest *)request];
	}
	else if ([request isKindOfClass:[VCoreDataAddRequest class]]) {
		return @([[VCoreDataController sharedInstance] addData:(VCoreDataAddRequest *)request]);
	}
	else if ([request isKindOfClass:[VCoreDataUpdateRequest class]]) {
		return @([[VCoreDataController sharedInstance] updateData:(VCoreDataUpdateRequest *)request]);
	}
	else if ([request isKindOfClass:[VCoreDataDelRequest class]]) {
		return @([[VCoreDataController sharedInstance] deleteData:(VCoreDataDelRequest *)request]);
	}
	else if ([request isKindOfClass:[VCoreDataExecuteRequest class]]) {
		return [[VCoreDataController sharedInstance] executeData:(VCoreDataExecuteRequest *)request];
	}
	return nil;
}

+ (id)dataWithRequest:(VCoreDataRequest *)request {
	id obj = [[self alloc] init];
	return [obj dataWithRequest:request];
}

@end
