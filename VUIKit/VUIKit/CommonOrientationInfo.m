#import "CommonOrientationInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "VUIKit.h"

@implementation CommonOrientationInfo
@synthesize screenWidth, screenHeight;
@synthesize isKeyboardShown;
@synthesize orientation;
@synthesize keyboardBeginInfo;
@synthesize keyboardEndInfo, nextOrientaion;

- (id)init {
	if (self = [super init]) {
		screenHeight = [[UIScreen mainScreen] bounds].size.height;
		screenWidth = [[UIScreen mainScreen] bounds].size.width;
		orientation = [UIApplication sharedApplication].statusBarOrientation;
	}

	return self;
}

- (NSInteger)nextKeyboardHeight {
	return 0;
}

#pragma mark get value
- (NSInteger)getOffsetHeight {
	if (IS_LANDSCAPE) {
		return 80;
	}
	return 80;
}

- (NSInteger)getDeleteHeight {
	if (IS_LANDSCAPE) {
		return 20;
	}
	return 10;
}

#pragma mark - override
- (NSInteger)screenHeight {
	NSInteger height = [[UIScreen mainScreen] bounds].size.height;
	NSInteger width = [[UIScreen mainScreen] bounds].size.width;
	return screenHeight = IS_LANDSCAPE ? width : height;
}

- (NSInteger)screenWidth {
	NSInteger height = [[UIScreen mainScreen] bounds].size.height;
	NSInteger width = [[UIScreen mainScreen] bounds].size.width;
	return screenWidth = IS_LANDSCAPE ? height : width;
}

- (NSInteger)getStatusBarHeight {
	NSInteger statusBarHeight = 0;
	if (IS_LANDSCAPE) {
		statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.width;
	}
	else {
		statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	}
	return statusBarHeight;
}

- (NSInteger)getTabBarHeight {
	if (IS_LANDSCAPE) {
		return 49;
	}
	return 49;
}

- (NSInteger)getNavigationBarHeight {
	if (IS_LANDSCAPE) {
		return 32;
	}
	return 44;
}

#pragma -mark vertical
- (NSInteger)getVerticalViewHeight {
	NSInteger viewHeight = [self verticalScreenHeight] - [self getVerticalNavigationBarHeight] - [self getVerticalStatusBarHeight];
	return viewHeight;
}

- (NSInteger)getVerticalControllerHeight {
	return [self verticalScreenHeight] - [self getVerticalStatusBarHeight];
}

- (NSInteger)verticalScreenHeight {
	NSInteger height = [[UIScreen mainScreen] bounds].size.height;
	return height;
}

- (NSInteger)verticalScreenWidth {
	NSInteger width = [[UIScreen mainScreen] bounds].size.width;
	return width;
}

- (NSInteger)getVerticalStatusBarHeight {
	NSInteger statusHeight;
	if (IS_LANDSCAPE) {
		statusHeight = [UIApplication sharedApplication].statusBarFrame.size.width;
	}
	else {
		statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	}
	return statusHeight;
}

- (NSInteger)getVerticalNavigationBarHeight {
	return 44;
}

- (NSInteger)getKeyboardHeight {
	return IS_LANDSCAPE ? keyboardEndInfo.size.width : keyboardEndInfo.size.height;
}

- (BOOL)isInfoValid {
	if (keyboardEndInfo.origin.y == INFINITY && keyboardEndInfo.origin.y == INFINITY) return NO;
	if (keyboardEndInfo.size.height == 0) return NO;
	return YES;
}

#pragma mark update
- (void)update {
	CGSize size = [[UIScreen mainScreen] bounds].size;
	if (IS_LANDSCAPE) {
		screenWidth = size.height;
		screenHeight = size.width;
	}
	else {
		screenWidth = size.width;
		screenHeight = size.height;
	}
}

- (UIInterfaceOrientation)getOrientation {
	orientation = [UIApplication sharedApplication].statusBarOrientation;
	return orientation;
}

- (BOOL)isLongScreen {
	return [[UIScreen mainScreen] bounds].size.height > 480;
}

- (NSInteger)screenMax {
	return 568;
}

@end
