//
//  NSMutableDictionary+VFoundation.h
//  VFoundation
//
//  Created by JessieYong on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  NSMutableDictionary' category in VFoundation
 */
@interface NSMutableDictionary (NSMutableDictionaryVFoundation)
- (void)removeFirstObject;
- (void)removeLastObject;
- (void)removeDictionary:(NSDictionary *)dict;

- (id)objectForKey:(id)aKey class:(Class)resultClass;
@end
