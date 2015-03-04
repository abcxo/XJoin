//
//  NSDate+VFoundation.m
//  VFoundation
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSDate+NSDateVFoundation.h"
#import "VFoundation.h"

@implementation NSDate (NSDateVFoundation)
- (NSDateComponents *)dateComponents {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:self];
	return components;
}

- (NSInteger)year {
	return [[self dateComponents] year];
}

- (NSInteger)month {
	return [[self dateComponents] month];
}

- (NSInteger)day {
	return [[self dateComponents] day];
}

- (NSInteger)hour {
	return [[self dateComponents] hour];
}

- (NSInteger)minute {
	return [[self dateComponents] minute];
}

- (NSInteger)second {
	return [[self dateComponents] second];
}

- (NSInteger)weekDay {
	return [[self dateComponents] weekday];
}

- (NSInteger)weekOfMonth {
	return [[self dateComponents] weekOfMonth];
}

- (NSInteger)weekOfYear {
	return [[self dateComponents] weekOfYear];
}

- (NSDate *)beginningOfDay {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfDay {
	return [[[self beginningOfDay] afterDays:1] afterSeconds:-1];
}

- (NSDate *)beginningOfWeek {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *beginningOfWeek = nil;
	BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
	                       interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	}
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay:0 - ([weekdayComponents weekday] - 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
	                                           fromDate:beginningOfWeek];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
	return [[[self beginningOfWeek] afterDays:7] afterSeconds:-1];
}

- (NSDate *)beginningOfMonth {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfMonth {
	return [[[self beginningOfMonth] afterMonths:1] afterSeconds:-1];
}

- (NSDate *)beginningOfYear {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags = NSYearCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfYear {
	return [[[self beginningOfYear] afterMonths:12] afterSeconds:-1];
}

- (NSDate *)afterDays:(NSInteger)day {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	[componentsToAdd setDay:day];
	NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

	return dateAfterDay;
}

- (NSDate *)afterWeeks:(NSInteger)week {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	[componentsToAdd setDay:7 * week];
	NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	return dateAfterDay;
}

- (NSDate *)afterMonths:(NSInteger)month {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	[componentsToAdd setMonth:month];
	NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	return dateAfterMonth;
}

- (NSDate *)afterDateComponents:(NSDateComponents *)components {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *dateAfterMonth = [calendar dateByAddingComponents:components toDate:self options:0];
	return dateAfterMonth;
}

- (NSDate *)afterSeconds:(double)second {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	[componentsToAdd setSecond:second];
	NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	return dateAfterMonth;
}

- (NSString *)timestampString {
	return [self format:TIMESTAMP_FORMAT];
}

+ (NSString *)timestampString {
	return [[NSDate date] timestampString];
}

+ (NSTimeInterval)timestamp {
	return [[NSDate date] timeIntervalSince1970];
}

- (NSString *)string {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	NSArray *allLanguages = [defaults objectForKey:@"AppleLanguages"];

	NSString *preferredLang = [allLanguages objectAtIndex:0];
	if ([preferredLang containString:@"zh"]) {
		return [self format:DATESTRING_FORMAT];
	}
	return [self format:TIMESTAMP_FORMAT];
}

- (NSString *)format:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *result = [outputFormatter stringFromDate:self];
	return result;
}

- (NSInteger)daysAgo {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
	                                           fromDate:self
	                                             toDate:[NSDate date]
	                                            options:0];
	return [components day];
}

+ (NSDate *)dateFromString:(NSString *)string {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:DATESTRING_FORMAT];
	return [dateFormat dateFromString:string];
}

@end
