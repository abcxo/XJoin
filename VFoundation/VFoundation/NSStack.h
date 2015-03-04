//
//  NSStack.h
//  VFoundation
//
//  Created by shadow on 14-3-27.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  VFoundation Collection NSStack
 */
@interface NSStack : NSObject <NSFastEnumeration>
/**
 *  Return stack count
 *
 *  @return int
 */
- (NSUInteger)count;
/**
 *  Push an object in the stack
 *
 *  @param anObject
 */
- (void)push:(id)anObject;
/**
 *  Pop an object from the stack
 *
 *  @return object
 */
- (id)pop;
/**
 *  Peek the object from stack,but not remove
 *
 *  @return object
 */
- (id)peek;
/**
 *  Clear the stack
 */
- (void)clear;
@end
