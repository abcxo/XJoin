//
//  VFoundationDefine.h
//  VFoundation
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCategoryDefine.h"
#import "VUtilityDefine.h"

#define C_DEFAULT_ENCODING kCFStringEncodingUTF8
#define DEFAULT_ENCODING NSUTF8StringEncoding



#define IOS_VERSION_LOW_7 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)

#define IOS_VERSION_LOW_6 ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)


#define IOS_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]


#define NSLog(format, ...) \
	do { \
		fprintf(stderr, "<%s : %d> %s\n",                                           \
		        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
		        __LINE__, __func__);                                                        \
		(NSLog)((format), ## __VA_ARGS__);                                           \
		fprintf(stderr, "-------\n"); \
	} while (0);


@interface VFoundationDefine : NSObject

@end
