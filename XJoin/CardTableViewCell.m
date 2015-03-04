//
//  CardTableViewCell.m
//  XJoin
//
//  Created by shadow on 14-8-29.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "CardTableViewCell.h"
#import "XJoin.h"
@implementation CardTableViewCell

- (TableViewCellStyle)style {
	return TableViewCellStyleCard;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self setFrameW:SCREEN_WIDTH - 20];
	self.backgroundColor = [UIColor whiteColor];
}

@end
