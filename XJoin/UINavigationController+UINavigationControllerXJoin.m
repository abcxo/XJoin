//
//  UINavigationController+UINavigationControllerXJoin.m
//  XJoin
//
//  Created by shadow on 14-8-29.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UINavigationController+UINavigationControllerXJoin.h"
#import "XJoin.h"
@implementation UINavigationController (UINavigationControllerXJoin)
__ENABLE_EXCHANGE_METHOD__(SELString(pushViewController : animated :))
- (void)__exchange__pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (IOS_VERSION_LOW_7 && !viewController.navigationItem.leftBarButtonItem) {
		viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_back"] style:UIBarButtonItemStylePlain target:viewController action:@selector(handleNavBarLeft:)];
	}
	[self __exchange__pushViewController:viewController animated:animated];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
