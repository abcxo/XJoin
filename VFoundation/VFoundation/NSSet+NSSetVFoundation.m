//
//  NSSet+VFoundation.m
//  VFoundation
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSSet+NSSetVFoundation.h"
#import "VFoundation.h"
@implementation NSSet (NSSetVFoundation)
- (BOOL)isEmpty {
	BOOL isEmpty = [super isEmpty];
	if (!isEmpty) {
		isEmpty = !(self.count > 0 && self.count != NSNotFound);
	}
	return isEmpty;
}

@end
