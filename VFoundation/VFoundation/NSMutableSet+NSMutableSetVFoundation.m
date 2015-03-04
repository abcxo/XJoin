//
//  NSMutableSet+VFoundation.m
//  VFoundation
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSMutableSet+NSMutableSetVFoundation.h"
#import "VFoundation.h"
@implementation NSMutableSet (NSMutableSetVFoundation)
- (void)__exchange__addObject:(id)object {
	if (object != nil) {
		[self __exchange__addObject:object];
	}
}

@end
