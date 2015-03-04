//
//  UIStoryboard+UIStoryboardVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-5-8.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UIStoryboard+UIStoryboardVUIKit.h"
#import "VUIKit.h"
static const void *nameKey = &nameKey;
@implementation UIStoryboard (UIStoryboardVUIKit)
@dynamic name;
#pragma mark - Exchange methods
//__ENABLE_EXCHANGE_METHOD__(SELString(storyboardWithName : bundle :), SELString(instantiateViewControllerWithIdentifier :), SELString(instantiateInitialViewController))
//
//+ (UIStoryboard *)__exchange__storyboardWithName:(NSString *)name bundle:(NSBundle *)storyboardBundleOrNil {
//	UIStoryboard *result = [self __exchange__storyboardWithName:name bundle:storyboardBundleOrNil];
//	result.name = name;
//	return result;
//}
//
//- (id)__exchange__instantiateViewControllerWithIdentifier:(NSString *)identifier {
//	NSString *storyBoardName = [[NSMutableDictionary sharedInstance] objectForKey:identifier];
//	UIStoryboard *storyBoard = self;
//	if ([storyBoardName isMeaningful]) {
//		storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
//	}
//	UIViewController *result = [storyBoard __exchange__instantiateViewControllerWithIdentifier:identifier];
//	result.storyboard.name = storyBoard.name;
//	return result;
//}
//
//- (id)__exchange__instantiateInitialViewController {
//	id result = [self __exchange__instantiateInitialViewController];
//	return result;
//}

- (void)setName:(NSString *)name {
	objc_setAssociatedObject(self, nameKey, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)name {
	return objc_getAssociatedObject(self, nameKey);
}

@end
