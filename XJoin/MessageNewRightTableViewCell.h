//
//  MessageNewRightTableViewCell.h
//  XJoin
//
//  Created by shadow on 14-8-26.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "TableViewCell.h"
@class CircleImageView, FitLabel;
@interface MessageNewRightTableViewCell : TableViewCell

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet FitLabel *contentLabel;
@end
