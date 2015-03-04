//
//  UserNearByTableViewCell.h
//  XJoin
//
//  Created by shadow on 14-10-12.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "TableViewCell.h"
@class CircleImageView;
@interface UserNearByTableViewCell : TableViewCell
@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;



@end
