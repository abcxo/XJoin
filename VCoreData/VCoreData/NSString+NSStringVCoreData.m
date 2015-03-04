//
//  NSString+NSStringVCoreData.m
//  VCoreData
//
//  Created by shadow on 14-3-31.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSString+NSStringVCoreData.h"
#import "VCoreData.h"
@implementation NSString (NSStringVCoreData)
- (NSString *)or:(NSString *)str {
	return [[VCoreDataSQLFilter sharedInstance] or:self filter:str];
}

- (NSString *)and:(NSString *)str {
	return [[VCoreDataSQLFilter sharedInstance] and:self filter:str];
}

- (NSString *)groupBy:(NSString *)str {
	return [[VCoreDataSQLFilter sharedInstance] groupBy:self filter:str];
}

- (NSString *)orderAsc:(NSString *)str {
	return [[VCoreDataSQLFilter sharedInstance] orderAsc:self filter:str];
}

- (NSString *)orderDes:(NSString *)str {
	return [[VCoreDataSQLFilter sharedInstance] orderDes:self filter:str];
}

@end
