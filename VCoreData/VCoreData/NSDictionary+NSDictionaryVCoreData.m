//
//  NSDictionary+NSDictionaryVCoreData.m
//  VCoreData
//
//  Created by shadow on 14-5-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSDictionary+NSDictionaryVCoreData.h"
#import "VCoreData.h"
@implementation NSDictionary (NSDictionaryVCoreData)
- (BOOL)put {
	for (id obj in[self allValues]) {
		[obj put];
	}
	return YES;
}

@end
