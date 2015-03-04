//
//  NSUserDefaults+NSUserDefaultsVFoundation.h
//  VFoundation
//
//  Created by shadow on 14-5-9.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (NSUserDefaultsVFoundation)
+ (id)objectForKey:(id)key;
+ (void)setObject:(id)obj ForKey:(id)key;
@end
