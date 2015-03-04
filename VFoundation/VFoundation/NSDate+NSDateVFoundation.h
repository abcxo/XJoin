//
//  NSDate+VFoundation.h
//  VFoundation
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  NSDate' category in VFoundation
 */
@interface NSDate (NSDateVFoundation)
/**
 *  Get date year like "2014-03-18 15:20:30  the 2014"
 *
 *  @return date year value
 */
- (NSInteger)year;
/**
 *  Get date month like "2014-03-18 15:20:30  the 03"
 *
 *  @return date month value
 */

- (NSInteger)month;
/**
 *  Get date day like "2014-03-18 15:20:30  the 18"
 *
 *  @return date day value
 */
- (NSInteger)day;
/**
 *  Get date hour like "2014-03-18 15:20:30  the 15"
 *
 *  @return date hour value
 */
- (NSInteger)hour;
/**
 *  Get date minute like "2014-03-18 15:20:30  the 20"
 *
 *  @return date minute value
 */
- (NSInteger)minute;
/**
 *  Get date second like "2014-03-18 15:20:30  the 30"
 *
 *  @return date second value
 */
- (NSInteger)second;
/**
 *  Get date weekDay like "2014-03-18 15:20:30 monday ,the value is 2"
 *
 *  @return date weekday number
 */
- (NSInteger)weekDay;
/**
 *  Get date year like "2014-03-18 15:20:30 ,the value is 4"
 *
 *  @return week of month value
 */
- (NSInteger)weekOfMonth;
/**
 *  Get date year like "2014-03-18 15:20:30 ,the value is 12"
 *
 *  @return week of year value
 */
- (NSInteger)weekOfYear;
/**
 *  Get date the day's first date
 *
 *  @return first of day
 */
- (NSDate *)beginningOfDay;
/**
 *  Get date the day's last date
 *
 *  @return last  of day
 */
- (NSDate *)endOfDay;
/**
 *  Get date the week's first date
 *
 *  @return fitst date of week
 */
- (NSDate *)beginningOfWeek;
/**
 *  Get date the week's last date
 *
 *  @return last date of week
 */
- (NSDate *)endOfWeek;
/**
 *  Get date the month's first date
 *
 *  @return first date of month
 */
- (NSDate *)beginningOfMonth;
/**
 *  Get date the month's last date
 *
 *  @return last date of month
 */
- (NSDate *)endOfMonth;
/**
 *  Get date the year's first date
 *
 *  @return first date of year
 */
- (NSDate *)beginningOfYear;
/**
 *  Get date the year's last date
 *
 *  @return last date of year
 */
- (NSDate *)endOfYear;
/**
 *  After custom days date
 *
 *  @param day
 *
 *  @return added date
 */
- (NSDate *)afterDays:(NSInteger)day;
/**
 *  After custom weeks date
 *
 *  @param week
 *
 *  @return added date
 */
- (NSDate *)afterWeeks:(NSInteger)week;
/**
 *  After custom months date
 *
 *  @param month
 *
 *  @return added date
 */
- (NSDate *)afterMonths:(NSInteger)month;
/**
 *  After custom seconds date
 *
 *  @param second
 *
 *  @return added date
 */
- (NSDate *)afterSeconds:(double)second;
/**
 *  After custom components date
 *
 *  @param components
 *
 *  @return added date
 */
- (NSDate *)afterDateComponents:(NSDateComponents *)components;
/**
 *  Get date timestampstring
 *
 *  @return timestamp string
 */
- (NSString *)timestampString;
+ (NSString *)timestampString;
+ (NSTimeInterval)timestamp;
/**
 *  Get date default formated string
 *
 *  @return formated string
 */
- (NSString *)string;
/**
 *  Format nsdate to nsstring base on format
 *
 *  @param format string
 *
 *  @return formated dateString
 */
- (NSString *)format:(NSString *)format;
/**
 *  Get date from now
 *
 *  @return date since now ago
 */
- (NSInteger)daysAgo;

+ (NSDate *)dateFromString:(NSString *)string;

@end
