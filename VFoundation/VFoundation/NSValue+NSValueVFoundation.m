//
//  NSValue+VFoundation.m
//  VFoundation
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSValue+NSValueVFoundation.h"

@implementation NSValue (NSValueVFoundation)
- (NSValueType)valueType {
	const char *t = [self objCType];
	NSValueType type = NSValueTypeUnKnown;
	if (strcmp(t, @encode(int)) == 0) {
		type = NSValueTypeInt;
	}
	else if (strcmp(t, @encode(unsigned int)) == 0) {
		type = NSValueTypeUInt;
	}
	else if (strcmp(t, @encode(short)) == 0) {
		type = NSValueTypeShort;
	}
	else if (strcmp(t, @encode(unsigned short)) == 0) {
		type = NSValueTypeULong;
	}
	else if (strcmp(t, @encode(long)) == 0) {
		type = NSValueTypeLong;
	}
	else if (strcmp(t, @encode(unsigned long)) == 0) {
		type = NSValueTypeULong;
	}
	else if (strcmp(t, @encode(long long)) == 0) {
		type = NSValueTypeLongLong;
	}
	else if (strcmp(t, @encode(unsigned long long)) == 0) {
		type = NSValueTypeULongLong;
	}
	else if (strcmp(t, @encode(bool)) == 0 || strcmp(t, @encode(BOOL)) == 0) {
		type = NSValueTypeBool;
	}
	else if (strcmp(t, @encode(float)) == 0) {
		type = NSValueTypeFloat;
	}
	else if (strcmp(t, @encode(double)) == 0) {
		type = NSValueTypeDouble;
	}
	else if (strcmp(t, @encode(char)) == 0) {
		type = NSValueTypeChar;
	}
	else if (strcmp(t, @encode(unsigned char)) == 0) {
		type = NSValueTypeUChar;
	}

	else {
		type = NSValueTypeUnKnown;
	}
	return type;
}

@end
