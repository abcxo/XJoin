//
//  VCoreDataCache.m
//  VCoreData
//
//  Created by shadow on 14-3-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "VCoreDataCache.h"
#import "VCoreData.h"
typedef NS_ENUM (NSInteger, VCoreDataCacheLevel) {
	VCoreDataCacheLevelFirst,
	VCoreDataCacheLevelSecond,
};


@interface VCoreDataCache () {
	NSCache *_firstCache;
	NSCache *_secondCache;
}


@end
@implementation VCoreDataCache
- (id)init {
	self = [super init];
	if (self) {
		_firstCache = [[NSCache alloc] init];
		_secondCache = [[NSCache alloc] init];
	}
	return self;
}

- (NSArray *)queryData:(VCoreDataQueryRequest *)request {
	NSMutableArray *result = [[NSMutableArray alloc] init];
	BOOL isMeaningful = [request.filter isMeaningful];
	NSArray *paramArray = [[request.filter trimAll] componentsSeparatedByString:@"="];
	BOOL isParsed = (paramArray.count == 2);
	if (!isMeaningful || (isMeaningful && isParsed)) {
		for (NSString *className in request.classes) {
			Class model = ClassClass(className);
			NSMutableDictionary *classDict = [_firstCache objectForKey:className];
			if (isMeaningful) {
				NSString *name = [paramArray firstObject];
				id value = [paramArray lastObject];
				NSMutableDictionary *propertyDict = [classDict objectForKey:name];
				NSMutableDictionary *propertyValueDict = [propertyDict objectForKey:value];
				NSArray *array = [[propertyValueDict allValues] arrayWithBlock: ^id (id obj, NSInteger index) {
				    return [obj allValues];
				}];
				[result addObjectsFromArray:array];
			}
			else {
				NSProperty *primaryModel = [model primaryProperty];
				NSString *name = primaryModel.name;
				NSMutableDictionary *propertyDict = [classDict objectForKey:name];
				[result addObjectsFromArray:[[propertyDict allValues] arrayWithBlock: ^id (id pValueArray, NSInteger index) { //property value dict
				    return [[pValueArray allValues] arrayWithBlock: ^id (id primaryArray, NSInteger index) { //p-v-k-v
				        return [[primaryArray allValues] arrayWithBlock: ^id (id ob3, NSInteger index) {
				            return [ob3 allValues];
						}];
					}];
				}]];
			}
		}
		return result;
	}
	if (![result isMeaningful]) { //to get second cache
		NSMutableDictionary *classDict = [_secondCache objectForKey:[[request.classes arrayWithBlock: ^id (id obj, NSInteger index) {
		    return [obj className];
		}] componentsJoinedByString:@"__"]];
		[result addObjectsFromArray:[classDict objectForKey:request.filter]];
		return result;
	}
	return nil;
}

- (BOOL)updateData:(VCoreDataUpdateRequest *)request {
	return [self addData:[request transformCopy:[VCoreDataAddRequest class]]];
}

- (BOOL)addData:(VCoreDataAddRequest *)request {
	for (id model in request.objects) {
		NSMutableDictionary *classDict = [_firstCache objectForKey:[model className]];
		if (!classDict) {
			classDict = [[NSMutableDictionary alloc] init];
		}
		NSProperty *primaryModel = [model primaryProperty];
		for (NSProperty *propertyModel in[model allProperties]) {
			if (propertyModel.type != NSDataVTypeBlob && primaryModel.type != NSDataVTypeBlob) {
				NSMutableDictionary *propertyDict = [classDict objectForKey:propertyModel.name];
				if (!propertyDict) {
					propertyDict = [[NSMutableDictionary alloc] init];
				}
				[propertyDict setObject:@{ primaryModel.value:model } forKey:propertyModel.value];
				[classDict setObject:propertyDict forKey:propertyModel.name];
			}
		}
		[_firstCache setObject:classDict forKey:[model className]];

		//second cache
		NSString *secondCacheClassKey = [[request.objects arrayWithBlock: ^id (id obj, NSInteger index) {
		    return [obj className];
		}] componentsJoinedByString:@"__"];
		NSMutableDictionary *classDictSecond = [_secondCache objectForKey:secondCacheClassKey];
		if (!classDictSecond) {
			classDictSecond = [[NSMutableDictionary alloc] init];
		}
		[classDictSecond setObject:request.objects forKey:request.filter];
		[_secondCache setObject:classDictSecond forKey:secondCacheClassKey];
	}
	return YES;
}

- (BOOL)deleteData:(VCoreDataDelRequest *)request {
	BOOL isMeaningful = [request.filter isMeaningful];
	NSArray *paramArray = [[request.filter trimAll] componentsSeparatedByString:@"="];
	BOOL isParsed = (paramArray.count == 2);
	if (!isMeaningful || (isMeaningful && isParsed)) {
		for (NSString *className in request.classes) {
			if (isMeaningful) {
				NSString *name = [paramArray firstObject];
				id value = [paramArray lastObject];
				NSMutableDictionary *classDict = [_firstCache objectForKey:className];
				NSMutableDictionary *propertyDict = [classDict objectForKey:name];
				[propertyDict removeObjectForKey:value];
			}
			else {
				[_firstCache removeObjectForKey:className];
			}
		}
	}
	else {
		return NO;
	}
	return YES;
}

@end
