//
//  NSArray+NSArrayVCoreData.m
//  VCoreData
//
//  Created by shadow on 14-5-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSArray+NSArrayVCoreData.h"

@implementation NSArray (NSArrayVCoreData)
- (BOOL)put {
	for (id obj in self) {
		[obj put];
	}
	return YES;
}

@end
