//
//  NSUserDefaults+NSUserDefaultsVFoundation.m
//  VFoundation
//
//  Created by shadow on 14-5-9.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSUserDefaults+NSUserDefaultsVFoundation.h"

@implementation NSUserDefaults (NSUserDefaultsVFoundation)
+ (id)objectForKey:(id)key {
	return [[self standardUserDefaults] objectForKey:key];
}

+ (void)setObject:(id)obj ForKey:(id)key {
	[[self standardUserDefaults] setObject:obj forKey:key];
}

@end
