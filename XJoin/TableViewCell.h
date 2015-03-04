//
//  TableViewCell.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSUInteger, TableViewCellStyle) {
	TableViewCellStylePlain,
	TableViewCellStyleCard,
};
@interface TableViewCell : UITableViewCell
@property (nonatomic, assign) TableViewCellStyle style;
@property (nonatomic, strong, readwrite) IBOutlet UILabel *textLabel;
@end
