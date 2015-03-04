//
//  NSMutableOrderedDictionary.h
//  VFoundation
//
//  Created by shadow on 14-7-16.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableOrderedDictionary : NSMutableDictionary
- (id)objectAtIndex:(NSUInteger)index;
- (id)keyAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfKey:(id)akey;
@end
