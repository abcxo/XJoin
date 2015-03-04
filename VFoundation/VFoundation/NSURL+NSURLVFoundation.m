//
//  NSURL+VFoundation.m
//  VFoundation
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSURL+NSURLVFoundation.h"

@implementation NSURL (NSURLVFoundation)
- (NSString *)bin {
	return [self lastPathComponent];
}

- (NSString *)parameterForKey:(NSString *)key {
	NSDictionary *parameters = [self parameters];
	return [parameters objectForKey:key];
}

- (NSDictionary *)parameters {
	NSString *parameters = [self query];
	NSArray *parameterArray = [parameters componentsSeparatedByString:@"&"];
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	for (NSString *kv in parameterArray) {
		NSArray *kvArray = [kv componentsSeparatedByString:@"="];
		[result setObject:kvArray[1] forKey:kvArray[0]];
	}
	return result;
}

@end
