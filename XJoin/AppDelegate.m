//
//  AppDelegate.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "AppDelegate.h"
#import "XJoin.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSLog(@"ffffffffffffff %@", launchOptions);
	// Override point for customization after application launch.
	[XJoin setup];
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
	[[NotificationCenter defaultCenter] addObserver:self selector:@selector(notificatiedLogined:) name:NOTIFICATION_LOGINED object:nil];
	[[NotificationCenter defaultCenter] addObserver:self selector:@selector(notificatiedLogouted:) name:NOTIFICATION_LOGOUTED object:nil];
	[self handleRefreshNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
	return YES;
}

- (void)notificatiedLogined:(NSNotification *)ns {
	UserEntity *user = ns.userInfo[[UserEntity className]];
	[self handleTokenWithUid:user.id type:@"bind" success:NULL failure:NULL];
}

- (void)notificatiedLogouted:(NSNotification *)ns {
	UserEntity *user = ns.userInfo[[UserEntity className]];
	[self handleTokenWithUid:user.id type:@"unbind" success:NULL failure:NULL];
}

- (void)handleTokenWithUid:(NSString *)uid type:(NSString *)type success:(void (^)(void))success failure:(void (^)(void))failure {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:[NETWORK_HOST addString:@"push.php?"] parameters:
	 @{
	     @"action":type,
	     @"uid":uid,
	     @"token":[[StorageDefaults appDefaults] objectForKey:APP_DEFAULT_DEVICE_TOKEN],
                     @"language":[Utils preferredLanguage],
	 }
	     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	        if (success) {
	            success();
			}
		}
	    else {
	        if (failure) {
	            failure();
			}
		}
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    NSLog(@"send devicetoken err %@", error);
	    if (failure) {
	        failure();
		}
	}];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	NSInteger count0 = [[[StorageDefaults appDefaults] objectForKey:APP_DEFAULT_NOTIFICATION_ACTIVITY_COUNT] integerValue];
	NSInteger count1 = [[[StorageDefaults appDefaults] objectForKey:APP_DEFAULT_NOTIFICATION_MESSAGE_COUNT] integerValue];
	NSInteger count2 = [[[StorageDefaults appDefaults] objectForKey:APP_DEFAULT_NOTIFICATION_FRIEND_COUNT] integerValue];
	[UIApplication sharedApplication].applicationIconBadgeNumber = count0 + count1 + count2;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSString *token = [[Format(@"%@", deviceToken) deleteStrings:@"<", @">", nil] trimAll];
	NSLog(@"regisger success:%@", token);
	[[StorageDefaults appDefaults] setObject:token forKey:APP_DEFAULT_DEVICE_TOKEN];
	if (![[[StorageDefaults appDefaults] objectForKey:APP_DEFAULT_IS_TOKEN_SENT] boolValue]) {
		NSString *uid = [UserEntity mainUser].id;
		[self handleTokenWithUid:[uid isMeaningful] ? uid:@"" type:@"bind" success: ^{
		    [[StorageDefaults appDefaults] setObject:@(YES) forKey:APP_DEFAULT_IS_TOKEN_SENT];
		} failure:NULL];
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[self handleRefreshNotification:userInfo];
}

- (void)handleRefreshNotification:(NSDictionary *)userInfo {
	if ([userInfo isMeaningful]) {
		UITabBarController *controller = (UITabBarController *)[UIApplication window].rootViewController;
		NSLog(@"newsssssss");
		NSString *type = userInfo[@"aps"][@"type"];
		if ([type isEqualToString:@"activity"]) {
			NSInteger count = [[[StorageDefaults appDefaults] objectForKey:APP_DEFAULT_NOTIFICATION_ACTIVITY_COUNT] integerValue];
			count++;
			[[StorageDefaults appDefaults] setObject:@(count) forKey:APP_DEFAULT_NOTIFICATION_ACTIVITY_COUNT];
			UITabBarItem *item = [controller.tabBar.items objectAtIndex:0];
			[item setBadgeValue:Format(@"%d", count)];
		}
		else if ([type isEqualToString:@"message"]) {
			NSInteger count = [[[StorageDefaults appDefaults] objectForKey:APP_DEFAULT_NOTIFICATION_MESSAGE_COUNT] integerValue];
			count++;
			[[StorageDefaults appDefaults] setObject:@(count) forKey:APP_DEFAULT_NOTIFICATION_MESSAGE_COUNT];
			UITabBarItem *item = [controller.tabBar.items objectAtIndex:1];
			[item setBadgeValue:Format(@"%d", count)];
		}
		else if ([type isEqualToString:@"friend"]) {
			NSInteger count = [[[StorageDefaults appDefaults] objectForKey:APP_DEFAULT_NOTIFICATION_FRIEND_COUNT] integerValue];
			count++;
			[[StorageDefaults appDefaults] setObject:@(count) forKey:APP_DEFAULT_NOTIFICATION_FRIEND_COUNT];
			UITabBarItem *item = [controller.tabBar.items objectAtIndex:2];
			[item setBadgeValue:Format(@"%d", count)];
		}
	}
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"Regist fail%@", error);
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
	return [ShareSDK handleOpenURL:url
	                    wxDelegate:self];
}

- (BOOL)  application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
	return [ShareSDK handleOpenURL:url
	             sourceApplication:sourceApplication
	                    annotation:annotation
	                    wxDelegate:self];
}

@end
