//
//  NSURL+VFoundation.h
//  VFoundation
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  NSURL' category in VFoundation
 */
@interface NSURL (NSURLVFoundation)
- (NSString *)bin;
/**
 *  URL parameter for key
 *
 *  @param key
 *
 *  @return parameter value
 */
- (NSString *)parameterForKey:(NSString *)key;
/**
 *  URL paramter like @{@"name":@"shadow"} without encoded
 *
 *  @return key-value
 */
- (NSDictionary *)parameters;

@end
