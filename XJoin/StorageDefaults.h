//
//  StorageDefaults.h
//  HighCBar
//
//  Created by shadow on 14-7-16.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserDefaults, AppDefaults;

@interface StorageDefaults : NSObject
+ (UserDefaults *)userDefaults;
+ (AppDefaults *)appDefaults;
@end




@interface Defaults : NSObject
@property (nonatomic, strong) NSUserDefaults *defaults;
- (void)setObject:(id)obj forKey:(id)aKey;
- (id)objectForKey:(id)key;
- (void)removeObjectForKey:(id)aKey;

@end



#define USER_DEFAULT_IS_LOGINED @"USER_DEFAULT_IS_LOGINED"
#define USER_DEFAULT_MAIN_UID @"USER_DEFAULT_MAIN_UID"
@interface UserDefaults : Defaults
@end


#define APP_DEFAULT_IS_WELCOMED @"APP_DEFAULT_IS_WELCOMED"
#define APP_DEFAULT_IS_NEED_NOTIFICATION @"APP_DEFAULT_IS_NEED_NOTIFICATION"
#define APP_DEFAULT_DEVICE_TOKEN @"APP_DEFAULT_DEVICE_TOKEN"
#define APP_DEFAULT_IS_TOKEN_SENT @"APP_DEFAULT_IS_TOKEN_SENT"
#define APP_DEFAULT_NOTIFICATION_ACTIVITY_COUNT @"APP_DEFAULT_NOTIFICATION_ACTIVITY_COUNT"
#define APP_DEFAULT_NOTIFICATION_MESSAGE_COUNT @"APP_DEFAULT_NOTIFICATION_MESSAGE_COUNT"
#define APP_DEFAULT_NOTIFICATION_FRIEND_COUNT @"APP_DEFAULT_NOTIFICATION_FRIEND_COUNT"

@interface AppDefaults : Defaults
@end
