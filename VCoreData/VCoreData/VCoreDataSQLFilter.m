//
//  VCoreDataSQLFilter.m
//  VCoreData
//
//  Created by shadow on 14-4-1.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "VCoreDataSQLFilter.h"
#import "VCoreData.h"
@implementation VCoreDataSQLFilter
- (NSString *)or:(NSString *)str1 filter:(NSString *)str2 {
	return [str1 addFormat:@" OR %@", str2];
}

- (NSString *)and:(NSString *)str1 filter:(NSString *)str2 {
	return [str1 addFormat:@" AND %@", str2];
}

- (NSString *)groupBy:(NSString *)str1 filter:(NSString *)str2 {
	return [str1 addFormat:@" GROUP BY %@", str2];
}

- (NSString *)orderAsc:(NSString *)str1 filter:(NSString *)str2 {
	return [str1 addFormat:@" ORDER BY %@ ASC", str2];
}

- (NSString *)orderDes:(NSString *)str1 filter:(NSString *)str2 {
	return [str1 addFormat:@" ORDER BY %@ DESC", str2];
}

@end
