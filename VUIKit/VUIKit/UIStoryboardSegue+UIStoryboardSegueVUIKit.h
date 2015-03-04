//
//  UIStoryboardSegue+UIStoryboardSegueVUIKit.h
//  VUIKit
//
//  Created by shadow on 14-6-4.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboardSegue (UIStoryboardSegueVUIKit)
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) id sender;

- (void)dismiss;
@end
