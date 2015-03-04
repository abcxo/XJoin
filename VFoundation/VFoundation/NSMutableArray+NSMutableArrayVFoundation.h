//
//  NSMutableArray+VFoundation.h
//  VFoundation
//
//  Created by JessieYong on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  NSMutableArray' category in VFoundation
 */
@interface NSMutableArray (NSMutableArrayVFoundation)
- (void)removeFirstObject;
- (id)objectAtIndex:(NSUInteger)index class:(Class)resultClass;
- (id)firstObjectWithClass:(Class)resultClass;
@end
