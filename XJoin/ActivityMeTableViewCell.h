//
//  ActivityMeTableViewCell.h
//  XJoin
//
//  Created by shadow on 14-8-25.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "TableViewCell.h"

@interface ActivityMeTableViewCell : TableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *loveLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;

@end
