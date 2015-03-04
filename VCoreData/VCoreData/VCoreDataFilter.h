//
//  VCoreDataFilter.h
//  VCoreData
//
//  Created by shadow on 14-4-1.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VCoreDataFilterProtocol <NSObject>
- (NSString *)or:(NSString *)str1 filter:(NSString *)str2;
- (NSString *)and:(NSString *)str1 filter:(NSString *)str2;
- (NSString *)groupBy:(NSString *)str1 filter:(NSString *)str2;
- (NSString *)orderAsc:(NSString *)str1 filter:(NSString *)str2;
- (NSString *)orderDes:(NSString *)str1 filter:(NSString *)str2;
@end
