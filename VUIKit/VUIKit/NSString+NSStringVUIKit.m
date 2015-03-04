//
//  NSString+NSStringVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-5-13.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSString+NSStringVUIKit.h"
#import "VUIKit.h"
@implementation NSString (NSStringVUIKit)
- (CGSize)sizeConstrainedOfSize:(CGSize)constrainedSize {
	if (IOS_VERSION_LOW_7) {
		UIFont *nameFont = [UIFont fontWithName:@"Helvetica" size:14];
		CGSize size = [self sizeWithFont:nameFont constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByCharWrapping];
		return size;
	}
	else {
		NSAttributedString *atrString = [[NSAttributedString alloc] initWithString:self];
		NSRange range = NSMakeRange(0, atrString.length);
		NSDictionary *dic = [atrString attributesAtIndex:0 effectiveRange:&range];
		CGSize size = [self boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
		return size;
	}
}

@end
