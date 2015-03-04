//
//  NSArray+VFoundation.h
//  VFoundation
//
//  Created by JessieYong on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  NSArray' category in VFoundation
 */
@interface NSArray (NSArrayVFoundation)
@property (nonatomic, copy) NSString *objectClassName;
- (NSArray *)arrayWithBlock:(id (^)(id obj, NSInteger index))block;

@end
