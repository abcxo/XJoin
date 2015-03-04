//
//  Utils.h
//  XJoin
//
//  Created by shadow on 14-9-1.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ActivityEntity;
@interface Utils : NSObject
+ (void)saveEvent:(ActivityEntity *)activity;
+ (void)removeEvent:(ActivityEntity *)activity;
+ (NSString*)preferredLanguage;
@end
