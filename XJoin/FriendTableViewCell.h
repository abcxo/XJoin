//
//  FriendTableViewCell.h
//  XJoin
//
//  Created by shadow on 14-8-21.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "TableViewCell.h"
@class CircleImageView;
@interface FriendTableViewCell : TableViewCell
@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end
