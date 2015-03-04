//
//  VCoreDataController.m
//  VCoreData
//
//  Created by shadow on 14-4-2.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "VCoreDataController.h"
#import "VCoreData.h"
@interface VCoreDataController () {
	id <VCoreDataPersistorProtocol> _persistor;
	VCoreDataCache *_cache;
}

@end
@implementation VCoreDataController
- (id)init {
	self = [super init];
	if (self) {
//		_cache = [[VCoreDataCache alloc] init];
		_persistor = [VCoreDataSQLPersistor sharedInstance];
	}
	return self;
}

- (NSArray *)queryData:(VCoreDataQueryRequest *)request {
	if (![request.properties isMeaningful]) {
		request.properties = [request.classes arrayWithBlock: ^id (id obj, NSInteger index) {
		    return [ClassClass(obj) allProperties];
		}];
	}

	NSArray *result = [_cache queryData:request];
	if (![result isMeaningful]) {
		result = [_persistor queryData:request];

		if ([result isMeaningful]) {
			VCoreDataAddRequest *addRequest = [request transformCopy:[VCoreDataAddRequest class]];
			addRequest.objects = [result arrayWithBlock: ^id (id obj, NSInteger index) {
			    return obj;
			}];
			[_cache addData:addRequest];
		}
	}
	return result;
}

- (BOOL)updateData:(VCoreDataUpdateRequest *)request {
	[_cache updateData:request];
	return [_persistor updateData:request];
}

- (BOOL)addData:(VCoreDataAddRequest *)request; {
	[_cache addData:request];
	return [_persistor addData:request];
}

- (BOOL)deleteData:(VCoreDataDelRequest *)request {
	[_cache deleteData:request];
	return [_persistor deleteData:request];
}

- (id)executeData:(VCoreDataExecuteRequest *)request {
	return [_persistor executeData:request];
}

@end
