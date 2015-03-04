//
//  UIViewController+UIViewControllerVUIKit.m
//  VUIKit
//
//  Created by shadow on 14-4-17.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UIViewController+UIViewControllerVUIKit.h"
#import "VUIKit.h"
static const void *userInfoKey = &userInfoKey;
static const void *segueKey = &segueKey;
static const void *viewModelKey = &viewModelKey;
static const void *isViewDidAppearOnceKey = &isViewDidAppearOnceKey;
static const void *isViewVisiableKey = &isViewVisiableKey;
static const void *isViewWillLayoutSubviewsOnceKey = &isViewWillLayoutSubviewsOnceKey;
@implementation UIViewController (UIViewControllerVUIKit)
@dynamic userInfo;
@dynamic segue;
@dynamic viewModel;
@dynamic isViewDidAppearOnce;
@dynamic isViewWillLayoutSubviewsOnce;

#pragma mark - Exchange methods
__ENABLE_EXCHANGE_METHOD__(SELString(init), SELString(initWithCoder :), SELString(initWithNibName : bundle :), SELString(viewDidLoad), SELString(viewWillAppear :), SELString(viewDidAppear :), SELString(viewWillDisappear :), SELString(viewDidDisappear :), SELString(viewWillLayoutSubviews), SELString(prepareForSegue : sender :))

- (id)__exchange__init {
	id result = [self __exchange__init];
	[self prepareForData];
	return result;
}

- (id)__exchange__initWithCoder:(NSCoder *)aDecoder {
	id result = [self __exchange__initWithCoder:aDecoder];
	[self prepareForData];
	return result;
}

- (id)__exchange__initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	id result = [self __exchange__initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	[self prepareForData];
	return result;
}

- (void)__exchange__viewDidLoad {
	[self __exchange__viewDidLoad];
	[self prepareForView];
}

- (void)__exchange__viewWillAppear:(BOOL)animated {
	[self __exchange__viewDidAppear:animated];
	if (self.isViewDidAppearOnce) {
		[self viewWillAppearByDismiss:animated];
	}
}

- (void)__exchange__viewDidAppear:(BOOL)animated {
	self.isViewVisiable = YES;
	[self __exchange__viewDidAppear:animated];
	if (self.isViewDidAppearOnce) {
		[self viewDidAppearByDismiss:animated];
	}
	if (self.isViewDidAppearOnce == NO) {
		self.isViewDidAppearOnce = YES;
		[self viewDidAppearOnce:animated];
		[self prepareForDelayData];
	}
	if (!IOS_VERSION_LOW_7) {
		self.navigationController.interactivePopGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate> )self;
	}
}

- (void)__exchange__viewWillDisAppear:(BOOL)animated {
	[self __exchange__viewWillDisAppear:animated];
}

- (void)__exchange__viewDidDisappear:(BOOL)animated {
	self.isViewVisiable = NO;
	[self __exchange__viewDidDisappear:animated];
}

- (void)__exchange__viewWillLayoutSubviews {
	[self __exchange__viewWillLayoutSubviews];
	if (self.isViewWillLayoutSubviewsOnce == NO) {
		self.isViewWillLayoutSubviewsOnce = YES;
		[self viewWillLayoutSubviewsOnce];
	}
}

- (void)__exchange__prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	segue.sender = sender;
	((UIViewController *)segue.destinationViewController).segue = segue;
	[self __exchange__prepareForSegue:segue sender:sender];
}

#pragma mark - UserInfo property
- (void)setViewModel:(id)viewModel {
	objc_setAssociatedObject(self, viewModelKey, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)viewModel {
	return objc_getAssociatedObject(self, viewModelKey);
}

- (void)setUserInfo:(id)userInfo {
	objc_setAssociatedObject(self, userInfoKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)userInfo {
	return objc_getAssociatedObject(self, userInfoKey);
}

- (void)setSegue:(UIStoryboardSegue *)segue {
	objc_setAssociatedObject(self, segueKey, segue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIStoryboardSegue *)segue {
	return objc_getAssociatedObject(self, segueKey);
}

- (void)setIsViewDidAppearOnce:(BOOL)isViewDidAppearOnce {
	objc_setAssociatedObject(self, isViewDidAppearOnceKey, @(isViewDidAppearOnce), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isViewDidAppearOnce {
	return [objc_getAssociatedObject(self, isViewDidAppearOnceKey) boolValue];
}

- (void)setIsViewVisiable:(BOOL)isViewVisiable {
	objc_setAssociatedObject(self, isViewVisiableKey, @(isViewVisiable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isViewVisiable {
	return [objc_getAssociatedObject(self, isViewVisiableKey) boolValue];
}

- (void)setIsViewWillLayoutSubviewsOnce:(BOOL)isViewWillLayoutSubviewsOnce {
	objc_setAssociatedObject(self, isViewWillLayoutSubviewsOnceKey, @(isViewWillLayoutSubviewsOnce), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isViewWillLayoutSubviewsOnce {
	return [objc_getAssociatedObject(self, isViewWillLayoutSubviewsOnceKey) boolValue];
}

#pragma mark - Utility methods
- (void)prepareForData {
	Class viewModelClass = ClassClass([[[self className] deleteString:@"ViewController"] addString:@"ViewModel"]);
	self.viewModel = [[viewModelClass alloc] init];
}

- (void)prepareForView {
	((VViewModel *)self.viewModel).delegate = self;

	if (self.navigationController) {
		if (self.navigationItem.leftBarButtonItem && self.navigationItem.leftBarButtonItem.target == nil && self.navigationItem.leftBarButtonItem.action == NULL) {
			if ([self.navigationItem.leftBarButtonItem.customView isKindOfClass:[UIButton class]]) {
				[(UIButton *)self.navigationItem.leftBarButtonItem.customView addTarget : self action : @selector(handleNavBarLeft:) forControlEvents : UIControlEventTouchUpInside];
			}
			self.navigationItem.leftBarButtonItem.target = self;
			self.navigationItem.leftBarButtonItem.action = @selector(handleNavBarLeft:);
		}
		if (self.navigationItem.title) {
			//			self.navigationItem.titleView.target = self;
			//			self.navigationItem.titleView.action = @selector(handleNavBarLeft:);
		}
		if (self.navigationItem.rightBarButtonItem && self.navigationItem.rightBarButtonItem.target == nil && self.navigationItem.rightBarButtonItem.action == NULL) {
			if ([self.navigationItem.rightBarButtonItem.customView isKindOfClass:[UIButton class]]) {
				[(UIButton *)self.navigationItem.rightBarButtonItem.customView addTarget : self action : @selector(handleNavBarRight:) forControlEvents : UIControlEventTouchUpInside];
			}
			self.navigationItem.rightBarButtonItem.target = self;
			self.navigationItem.rightBarButtonItem.action = @selector(handleNavBarRight:);
		}
	}
}

- (void)prepareForDelayData {
}

- (void)viewDidAppearOnce:(BOOL)animated {
}

- (void)viewWillLayoutSubviewsOnce {
}

#pragma mark - Navigation bar item selector
- (void)handleNavBarLeft:(id)sender {
	if (self.navigationController.viewControllers.count == 1) {
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
	else {
		[self.navigationController popViewControllerAnimated:YES];
	}
	self.segue = nil;
}

- (void)handleNavBarCenter:(id)sender {
}

- (void)handleNavBarRight:(id)sender {
}

- (id)containerViewController {
	UIViewController *result = self;
	if (result.navigationController) {
		result = result.navigationController;
	}
	if (result.tabBarController) {
		result = result.tabBarController;
	}
	return result;
}

- (void)viewWillAppearByDismiss:(BOOL)animated {
}

- (void)viewDidAppearByDismiss:(BOOL)animated {
}

@end
