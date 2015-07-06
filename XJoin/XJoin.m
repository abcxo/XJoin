//
//  XJoin.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "XJoin.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>

@implementation XJoin
+ (void)setup {
	[ShareSDK registerApp:@"8e36d520f3cc4e7adec7af7f347179e9"];
	
    [ShareSDK connectWeChatSessionWithAppId:@"wx6623254a485a961c" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatTimelineWithAppId:@"wx6623254a485a961c" wechatCls:[WXApi class]];


	//Initialize SinaWeibo Application
	[ShareSDK connectSinaWeiboWithAppKey:@"3683435285"
	                           appSecret:@"0567242cc2fe1f5215ff2c948f8c9ba7"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"
                            weiboSDKCls:[WeiboSDK class]];
    

//	Initialize QZone Application
	[ShareSDK connectQZoneWithAppKey:@"1102322271"
	                       appSecret:@"06QFVtks9NPre9An"];

	//添加QQ应用  注册网址  http://mobile.qq.com/api/
	[ShareSDK connectQQWithQZoneAppKey:@"1102322271"
	                 qqApiInterfaceCls:[QQApiInterface class]
	                   tencentOAuthCls:[TencentOAuth class]];

	//Initialize Facebook Application
	[ShareSDK connectFacebookWithAppKey:@"357492681065572"
	                          appSecret:@"2f6b4f82c310ec3cbecf04294d3ee410"];
//	[ShareSDK connectFacebookWithAppKey:@"357492681065572"
//	                          appSecret:@"2f6b4f82c310ec3cbecf04294d3ee410"];

	//Initialize Twitter Application
	[ShareSDK connectTwitterWithConsumerKey:@"2L0XA3NKQx0siF4z4N6wKNSmc"
	                         consumerSecret:@"7PMssjohPrKr9RcryjVHft9fLshe9Ke7CZvqBUumMIDbUPEFXP"
	                            redirectUri:@"http://www.upnovate.com"];

//
//	//Initialize Evernote Application
//	[ShareSDK connectEvernoteWithType:SSEverNoteTypeSandbox
//	                      consumerKey:@"norman"
//	                   consumerSecret:@"92b428ab314438d3"];
	[ShareSDK connectLine];
	[ShareSDK connectWhatsApp];

	if (!IOS_VERSION_LOW_7) {
		[UIApplication window].tintColor = COLOR_MAIN_ORANGE;
	}

	BOOL isWelcomed = [[[StorageDefaults appDefaults] objectForKey:APP_DEFAULT_IS_WELCOMED] boolValue];
	if (!isWelcomed) {
		[[StorageDefaults appDefaults] setObject:@(YES) forKey:APP_DEFAULT_IS_NEED_NOTIFICATION];
		[[StorageDefaults appDefaults] setObject:@(YES) forKey:APP_DEFAULT_IS_WELCOMED];
	}
}



@end
