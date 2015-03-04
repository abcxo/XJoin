//
//  CrossScrollView.h
//  XJoin
//
//  Created by shadow on 14-8-21.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CrossScrollView;
@protocol CrossScrollViewDelegate <UIScrollViewDelegate>
- (void)crossScrollView:(CrossScrollView *)collectionView didSelectItemAtIndex:(NSUInteger)index;
@end

@protocol CrossScrollViewDataSource <NSObject>

- (NSUInteger)numberOfItems:(CrossScrollView *)collectionView;
- (UIView *)crossScrollView:(CrossScrollView *)collectionView viewForItemAtIndex:(NSUInteger)index;
- (CGFloat)crossScrollView:(CrossScrollView *)collectionView widthForItemAtIndex:(NSUInteger)index;
@end
@interface CrossScrollView : UIScrollView
@property (nonatomic, weak) id <CrossScrollViewDataSource> dataSource;
@property (nonatomic, weak) id <CrossScrollViewDelegate> delegate;
- (NSInteger)count;
- (UIView *)viewForItemAtIndex:(NSInteger)index;
- (NSUInteger)indexOfItemView:(UIView *)view;
- (NSArray *)allItemViews;
- (NSUInteger)indexForSelectedItem;
- (void)reloadData;
@end
