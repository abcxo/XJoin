//
//  NSPriorityQueue.h
//  VFoundation
//
//  Created by shadow on 14-3-27.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VFoundationDefine.h"
/**
 *  VFoundation Collection NSQueue
 */
@interface NSPriorityQueue : NSObject <NSFastEnumeration>
/**
 *  Return queue count
 *
 *  @return int
 */
- (NSUInteger)count;
/**
 *  En an objedt in the queue with default priority
 *
 *  @param anObject
 */
- (void)enQueue:(id)anObject;
/**
 *  En an objedt in the queue
 *
 *  @param anObject
 *
 *  @param priority
 */
- (void)enQueue:(id)anObject withPriority:(NSQueuePriority)priority;
/**
 *  Jump the queue,rank frist
 *
 *  @param anObject
 */
- (void)jumpQueue:(id)anObject;
/**
 *  De an objedt from the queue
 *
 *  @return object
 */
- (id)deQueue;
/**
 *  Peek an objedt from the queue,but not remove
 *
 *  @return object
 */
- (id)peekQueue;
/**
 *  Clear the queue
 */
- (void)clear;
@end
