//
//  TableViewCell.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "TableViewCell.h"
#import "XJoin.h"
@implementation TableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void)prepareForView {
	[super prepareForView];
	if (self.style == TableViewCellStyleCard) {
		self.layer.shadowColor = COLOR_MAIN_GRAY.CGColor;
		self.layer.shadowOffset = CGSizeMake(4, 3);
		self.layer.shadowOpacity = 0.3; //阴影透明度，默认0
	}
}

- (void)setFrame:(CGRect)frame {
	if (self.style == TableViewCellStyleCard && self.superview) {
		float cellWidth = SCREEN_WIDTH - 20;
		frame.origin.x = 10;
		frame.size.width = cellWidth;
	}
	[super setFrame:frame];
}

@end
