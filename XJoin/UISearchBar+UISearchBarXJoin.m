//
//  UISearchBar+UISearchBarXJoin.m
//  XJoin
//
//  Created by shadow on 14-8-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UISearchBar+UISearchBarXJoin.h"
#import "XJoin.h"
@implementation UISearchBar (UISearchBarXJoin)
- (void)prepareForView {
	[super prepareForView];
	if (IOS_VERSION_LOW_7) {
		UIView *view = [[UIView alloc] initWithFrame:self.bounds];
		view.backgroundColor = COLOR_MAIN_GRAY_LIGHT;
		[self insertSubview:view atIndex:1];
	}
}

@end
