//
//  UITabBarController+UITabBarControllerVUIKit.h
//  VUIKit
//
//  Created by shadow on 14-5-6.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (UITabBarControllerVUIKit)
@property (nonatomic, getter = isTabBarHidden) BOOL tabBarHidden;
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
