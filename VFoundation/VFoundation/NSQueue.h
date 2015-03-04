//
//  NSQueue.h
//  VFoundation
//
//  Created by shadow on 14-3-27.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  VFoundation Collection NSQueue
 */
@interface NSQueue : NSObject <NSFastEnumeration>
/**
 *  Return queue count
 *
 *  @return int
 */
- (NSUInteger)count;
/**
 *  En an objedt in the queue
 *
 *  @param anObject
 */
- (void)enQueue:(id)anObject;
/**
 *  De an objedt from the queue
 *
 *  @return object
 */
- (id)deQueue;
/**
 *  Peek the object from queue,but not remove
 *
 *  @return object
 */
- (id)peekQueue;
/**
 *  Clear the queue
 */
- (void)clear;
@end
