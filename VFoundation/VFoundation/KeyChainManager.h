//
//  KeyChainManager.h
//  VFoundation
//
//  Created by shadow on 14-3-15.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainManager : NSObject
+ (BOOL)setObject:(id)object forKey:(id)key;
+ (id)objectForKey:(id)key;
+ (BOOL)removeObject:(id)key;
+ (BOOL)removeAllObject;
@end
