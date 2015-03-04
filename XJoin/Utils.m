//
//  Utils.m
//  XJoin
//
//  Created by shadow on 14-9-1.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "Utils.h"
#import "XJoin.h"
@implementation Utils
+ (void)saveEvent:(ActivityEntity *)activity {
	NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:activity.begin_date];
	NSDate *endDate  = [NSDate dateWithTimeIntervalSince1970:activity.end_date];

	//事件市场
	EKEventStore *eventStore = [[EKEventStore alloc] init];
	//6.0及以上通过下面方式写入事件
	if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
		// the selector is available, so we must be on iOS 6 or newer
		[eventStore requestAccessToEntityType:EKEntityTypeEvent completion: ^(BOOL granted, NSError *error) {
		    dispatch_async(dispatch_get_main_queue(), ^{
		        if (error) {
		            //错误细心
		            // display error message here
		            //		            [MRProgressOverlayView showNO:error.description];
				}
		        else if (!granted) {
		            //被用户拒绝，不允许访问日历
		            // display access denied error message here
		            [MRProgressOverlayView showNO:LOCALIZED(@"請打開日曆設置允許XJoin訪問")];
				}
		        else {
		            // access granted
		            // ***** do the important stuff here *****

		            //事件保存到日历


		            //创建事件
		            EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
		            event.title     = activity.subject;
		            event.location = activity.locationEntity.title;
		            event.startDate = creatDate;
		            event.endDate   = endDate;
		            //		            //event.allDay = YES;
		            //添加提醒
		            [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
		            [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];

		            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
		            NSError *err;
		            [eventStore saveEvent:event span:EKSpanThisEvent error:&err];

				}
			});
		}];
	}
	else {
		// this code runs in iOS 4 or iOS 5
		// ***** do the important stuff here *****

		//4.0和5.0通过下述方式添加

		//保存日历
		EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
		event.title     = activity.subject;
		event.location = activity.locationEntity.title;
		event.startDate = creatDate;
		event.endDate   = endDate;
		//		//event.allDay = YES;


		[event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
		[event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];

		[event setCalendar:[eventStore defaultCalendarForNewEvents]];
		NSError *err;
		[eventStore saveEvent:event span:EKSpanThisEvent error:&err];

		if (err) {
			//			[MRProgressOverlayView showNO:err.description];
		}

	}
}

+ (void)removeEvent:(ActivityEntity *)activity {
	NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:activity.begin_date];
	NSDate *endDate  = [NSDate dateWithTimeIntervalSince1970:activity.end_date];

	//事件市场
	EKEventStore *eventStore = [[EKEventStore alloc] init];
	//6.0及以上通过下面方式写入事件
	if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
		// the selector is available, so we must be on iOS 6 or newer
		[eventStore requestAccessToEntityType:EKEntityTypeEvent completion: ^(BOOL granted, NSError *error) {
		    dispatch_async(dispatch_get_main_queue(), ^{
		        if (error) {
		            //错误细心
		            // display error message here
		            //		            [MRProgressOverlayView showNO:error.description];
				}
		        else if (!granted) {
		            //被用户拒绝，不允许访问日历
		            // display access denied error message here
		            [MRProgressOverlayView showNO:LOCALIZED(@"請打開日曆設置允許XJoin訪問")];
				}
		        else {
		            NSPredicate *pre = [eventStore predicateForEventsWithStartDate:creatDate endDate:endDate calendars:nil];
		            [eventStore enumerateEventsMatchingPredicate:pre usingBlock: ^(EKEvent *ev, BOOL *stop) {
		                if ([ev.title isEqualToString:activity.subject]) {
		                    NSError *err;
		                    [eventStore removeEvent:ev span:EKSpanThisEvent error:&err];

						}
					}];
				}
			});
		}];
	}
	else {
		// this code runs in iOS 4 or iOS 5
		// ***** do the important stuff here *****

		//4.0和5.0通过下述方式添加

		NSPredicate *pre = [eventStore predicateForEventsWithStartDate:creatDate endDate:endDate calendars:nil];
		[eventStore enumerateEventsMatchingPredicate:pre usingBlock: ^(EKEvent *ev, BOOL *stop) {
		    if ([ev.title isEqualToString:activity.subject]) {
		        NSError *err;
		        [eventStore removeEvent:ev span:EKSpanThisEvent error:&err];

			}
		}];
	}
}

+ (NSString*)preferredLanguage

{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    NSLog(@"当前语言:%@", preferredLang);
    
    return preferredLang;
    
}



@end
