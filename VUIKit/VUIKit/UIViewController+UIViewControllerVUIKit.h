//
//  UIViewController+UIViewControllerVUIKit.h
//  VUIKit
//
//  Created by shadow on 14-4-17.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VViewModel.h"
@class VViewModel;
@interface UIViewController (UIViewControllerVUIKit) <VViewModelDelegate>
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) UIStoryboardSegue *segue;
@property (nonatomic, strong) VViewModel *viewModel;
@property (nonatomic, assign) BOOL isViewDidAppearOnce;
@property (nonatomic, assign) BOOL isViewVisiable;
@property (nonatomic, assign) BOOL isViewWillLayoutSubviewsOnce;
- (void)viewWillAppearByDismiss:(BOOL)animated;
- (void)viewDidAppearByDismiss:(BOOL)animated;

- (void)prepareForData;
- (void)prepareForView;
- (void)prepareForDelayData;


- (void)viewDidAppearOnce:(BOOL)animated;
- (void)viewWillLayoutSubviewsOnce;
- (void)handleNavBarLeft:(id)sender;
- (void)handleNavBarCenter:(id)sender;
- (void)handleNavBarRight:(id)sender;




- (id)containerViewController;
@end
