//
//  NSBundle+VFoundation.h
//  VFoundation
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  NSBundle' category in VFoundation
 */
@interface NSBundle (NSBundleVFoundation)
/**
 *  Get app build version,like "3.0.3464646",internal version
 *
 *  @return string
 */
+ (NSString *)buildVersion;
/**
 *  Get app short version,like "3.0.3",public app version
 *
 *  @return string
 */
+ (NSString *)appVersion;
/**
 *  Get app name ,like @"facebook",don't need to internationalize
 *
 *  @return string
 */
+ (NSString *)appName;
/**
 *  Get the app displayName ,like@"facebook" ,in Chinese @"脸书"
 *
 *  @return string
 */
+ (NSString *)appDisplayName;
/**
 *  Get app bundel identifier like ,"com.facebook.xx"
 *
 *  @return string
 */
+ (NSString *)identifier;
/**
 *  Get app executable path
 *
 *  @return string
 */
+ (NSString *)executable;
/**
 *  Get app info.plist
 *
 *  @return dict
 */
+ (NSDictionary *)infoDictionary;
/**
 *  Get mainbundle file path
 *
 *  @param fileName
 *
 *  @return path
 */
+ (NSString *)pathForFile:(NSString *)fileName;
/**
 *  Get mainbundle file path and return data
 *
 *  @param fileName
 *
 *  @return file data
 */
+ (NSData *)dataForFile:(NSString *)fileName;



@end
