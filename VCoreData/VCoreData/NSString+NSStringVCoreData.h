//
//  NSString+NSStringVCoreData.h
//  VCoreData
//
//  Created by shadow on 14-3-31.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (NSStringVCoreData)
- (NSString *)or:(NSString *)str;
- (NSString *)and:(NSString *)str;
- (NSString *)groupBy:(NSString *)str;
- (NSString *)orderAsc:(NSString *)str;
- (NSString *)orderDes:(NSString *)str;
@end
