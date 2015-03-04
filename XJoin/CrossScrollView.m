//
//  CrossScrollView.m
//  XJoin
//
//  Created by shadow on 14-8-21.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "CrossScrollView.h"
#import "XJoin.h"
@interface CrossScrollView () {
	NSInteger _count;
	NSUInteger _selectedItemIndex;
}
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *itemViews;

@end

@implementation CrossScrollView
- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	self.containerView.frame = self.bounds;
}

- (void)prepareForView {
	[super prepareForView];
	self.alwaysBounceHorizontal = YES;
	self.itemViews = [[NSMutableArray alloc] init];
	self.containerView = [[UIView alloc] initWithFrame:CGRectMakeWithRect(self.frame)];
	[self addSubview:self.containerView];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self resetView];
	NSUInteger count = [self.dataSource numberOfItems:self];
	_count = count;
	CGFloat offsetX = 0;
	if (count > 0) {
		for (int i = 0; i < count; i++) {
			UIView *view = [self.dataSource crossScrollView:self viewForItemAtIndex:i];
			UIControl *control = [[UIControl alloc] initWithFrame:view.bounds];
			[control addTarget:self action:@selector(handleClickItemView:) forControlEvents:UIControlEventTouchUpInside];
			view.userInteractionEnabled = YES;
			[view insertSubview:control atIndex:0];
			CGFloat width = [self.dataSource crossScrollView:self widthForItemAtIndex:i];
			[view setCenter:CGPointMake(offsetX + width / 2, self.containerView.center.y)];
			offsetX += width;
			[self.containerView addSubview:view];
			[self.itemViews addObject:view];
		}
	}
	[self.containerView setFrameW:offsetX];
	self.contentSize = CGSizeMake(offsetX, CGRectGetHeight(self.containerView.bounds));
}

- (void)handleClickItemView:(id)sender {
	NSUInteger index = [self indexOfItemView:[sender superview]];
	_selectedItemIndex = index;
	[self.delegate crossScrollView:self didSelectItemAtIndex:index];
}

- (void)resetView {
	_selectedItemIndex = NSNotFound;
	_count = 0;
	[self.containerView removeAllSubViews];
	[self.itemViews removeAllObjects];
}

- (UIView *)viewForItemAtIndex:(NSInteger)index {
	return [self.itemViews objectAtIndex:index];
}

- (NSUInteger)indexOfItemView:(UIView *)view {
	return [self.itemViews indexOfObject:view];
}

- (NSInteger)count {
	return _count;
}

- (NSArray *)allItemViews {
	return self.itemViews;
}

- (NSUInteger)indexForSelectedItem {
	return _selectedItemIndex;
}

- (void)reloadData {
	[self setNeedsLayout];
}

@end
