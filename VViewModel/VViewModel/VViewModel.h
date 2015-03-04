//
//  VViewModel.h
//  VViewModel
//
//  Created by shadow on 14-3-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VViewModel;

@protocol VViewModelDelegate <NSObject>
@optional
- (void)viewModel:(VViewModel *)viewModel load:(id)data error:(NSError *)err;
- (void)viewModel:(VViewModel *)viewModel get:(id)data error:(NSError *)err;
- (void)viewModel:(VViewModel *)viewModel add:(id)change error:(NSError *)err;
- (void)viewModel:(VViewModel *)viewModel edit:(id)change error:(NSError *)err;
- (void)viewModel:(VViewModel *)viewModel remove:(id)change error:(NSError *)err;
- (void)viewModel:(VViewModel *)viewModel clear:(id)change error:(NSError *)err;
@end

@interface VViewModel : NSObject
@property (nonatomic, weak) id <VViewModelDelegate> delegate;
@property (nonatomic, strong) id dataSource; //viewModel层使用
@property (nonatomic, strong) id dataSourceUI; //是给UI层使用的
- (id)initDelegate:(id)delegate;
@end


@interface  VViewModelUI : NSObject
@property (nonatomic, strong) id userInfo;
@end
