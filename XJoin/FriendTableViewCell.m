//
//  FriendTableViewCell.m
//  XJoin
//
//  Created by shadow on 14-8-21.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "XJoin.h"
@implementation FriendTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CircleImageView *avatarImageView = [[CircleImageView alloc] initWithFrame:CGRectMake(10, 6, 44, 44)];
		self.avatarImageView = avatarImageView;
		[self.contentView addSubview:avatarImageView];
		UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 0, 200, 56)];
		nickNameLabel.backgroundColor = [UIColor clearColor];
		nickNameLabel.font = [UIFont boldSystemFontOfSize:15];
		nickNameLabel.textColor = COLOR_MAIN_BLACK_DARK;
		self.nickNameLabel = nickNameLabel;

		[self.contentView addSubview:nickNameLabel];
		self.backgroundColor = [UIColor clearColor];
		UIView *view = [[UIView alloc] init];
		view.backgroundColor = [UIColor colorWithRed:254 / 255.0 green:97 / 255.0 blue:66 / 255.0 alpha:0.5];
		self.selectedBackgroundView = view;
	}
	return self;
}

@end
