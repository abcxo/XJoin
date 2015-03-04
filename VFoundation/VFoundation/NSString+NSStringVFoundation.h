//
//  NSString+VFoundation.h
//  VFoundation
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  NSString' category in VFoundation
 */
@interface NSString (NSStringVFoundation)
/**
 *  UUID get unique string
 *
 *  @return string
 */
+ (NSString *)UUID;
/**
 *  trimAll the entire string default
 *
 *  @return string
 */
- (NSString *)trimAll;
/**
 *  trimAll only string edge
 *
 *  @return string
 */
- (NSString *)trimEdge;
/**
 *  Replace with the specified string
 *
 *  @param string
 *  @param target
 *
 *  @return replaced string
 */
- (NSString *)replace:(NSString *)string ForTarget:(NSString *)target;
/**
 *  Replace with the specified string
 *
 *  @param target
 *  @param string
 *
 *  @return replaced string
 */
- (NSString *)replaceTarget:(NSString *)target string:(NSString *)string, ...NS_REQUIRES_NIL_TERMINATION;
/**
 *  Replace with the specified strings
 *
 *  @param string
 *  @param target ...
 *
 *  @return replaced string
 */
- (NSString *)replace:(NSString *)string ForTargets:(NSString *)target, ...NS_REQUIRES_NIL_TERMINATION;
/**
 *  Is contain the specified string
 *
 *  @param str
 *
 *  @return bool
 */
- (BOOL)containString:(NSString *)str;
/**
 *  Is contain the specified strings
 *
 *  @param str ...
 *
 *  @return bool
 */
- (BOOL)containStrings:(NSString *)str, ...NS_REQUIRES_NIL_TERMINATION;
/**
 *  Append the specified string rearmost
 *
 *  @param str
 *
 *  @return appended string
 */
- (NSString *)addString:(NSString *)str;
/**
 *  Append the specified strings rearmost
 *
 *  @param str
 *
 *  @return appended string
 */
- (NSString *)addStrings:(NSString *)str, ...NS_REQUIRES_NIL_TERMINATION;
/**
 *  Append the specified string with format rearmost
 *
 *  @param format
 *
 *  @return appended string
 */
- (NSString *)addFormat:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2);
/**
 *  Delete the specified string
 *
 *  @param str
 *
 *  @return deleted string
 */
- (NSString *)deleteString:(NSString *)str;
/**
 *  Delete the specified strings
 *
 *  @param str
 *
 *  @return deleted string
 */
- (NSString *)deleteStrings:(NSString *)str, ...NS_REQUIRES_NIL_TERMINATION;
@end
@interface NSString (NSStringFile)
/**
 *  Get string prefix like "readMe.txt" will return readMe
 *
 *  @return string
 */
- (NSString *)prefix;
/**
 *  Get string suffix like "readMe.txt" will return txt
 *
 *  @return string
 */
- (NSString *)suffix;
/**
 *  Get string by deleted prefix like "readMe.t.txt" will return t.txt
 *
 *  @return deleted string
 */
- (NSString *)deletePrefixString;
/**
 *  Get string by deleted prefix like "readMe.t.txt" will return readMe.t
 *
 *  @return deleted string
 */
- (NSString *)deleteSuffixString;
/**
 *  Transform kb,k,b,m,g to size like "1kb=1024"
 *
 *  @return longlong value
 */
- (unsigned long long)fileSize;
/**
 *  Transform size to units like "1024=1kb"
 *
 *  @param filesize
 *
 *  @return filesize units
 */
+ (NSString *)fileSizeString:(unsigned long long)filesize;
/**
 *  Get NSURL of File
 *
 *  @return fileurl
 */
- (NSURL *)fileURL;

@end
@interface NSString (NSStringURL)
/**
 *  URL scheme like "http"
 *
 *  @return scheme
 */
- (NSString *)scheme;
/**
 *  URL host like "www.baidu.com"
 *
 *  @return host
 */
- (NSString *)host;
/**
 *  URL port lke "8080"
 *
 *  @return port
 */
- (NSNumber *)port;
/**
 *  URL bin like "www.baidu.com/search?txt=VFoundation" inside the "search"
 *
 *  @return bin
 */
- (NSString *)bin;
/**
 *  URL parameter for key
 *
 *  @param key
 *
 *  @return parameter value
 */
- (NSString *)parameterForKey:(NSString *)key;
/**
 *  URL paramter like @{@"name":@"shadow"} without encoded
 *
 *  @return key-value
 */
- (NSDictionary *)parameters;
/**
 *  URL encode if you want to auto encode like http:www.baidu.com/search?txt=VFoundation,you can use [NSString URLEncodeAbsoluteString]
 *
 *  @return urlString
 */
- (NSString *)URLEncodeString;
/**
 *  URL decode  if you want to auto decode like http:www.baidu.com/search?txt=VFoundation,you can use [NSString URLDecodeAbsoluteString]
 *
 *  @return string
 */
- (NSString *)URLDecodeString;
/**
 *  URL auto encode url,Recommend,except value has &
 *
 *  @return encoded absoluteString
 */
- (NSString *)URLEncodeAbsoluteString;
/**
 *  URL auto decode url,Recommend
 *
 *  @return decoded absoluteString
 */
- (NSString *)URLDecodeAbsoluteString;
/**
 *  URL with URLEncodeAbsoluteString
 *
 *  @return NSURL
 */
- (NSURL *)URL;

@end
@interface NSString (NSStringCrypto)
/**
 *  MD5 summarise 32 string
 *
 *  @return string
 */
- (NSString *)MD5Sum;
/**
 *  MD5 summarise 16 string
 *
 *  @return string
 */
- (NSString *)MD516Sum;
/**
 *  SHA1 summarise 32 bit string
 *
 *  @return string
 */
- (NSString *)SHA1Sum;
/**
 *  SHA256 summarise 32 bit string
 *
 *  @return string
 */
- (NSString *)SHA256Sum;
/**
 *  Base64 encode string
 *
 *  @return string
 */
- (NSString *)base64EncodeString;
/**
 *  Base64 decode string
 *
 *  @return string
 */
- (NSString *)base64DecodeString;
/**
 *  AES encrypt string
 *
 *  @param key encrypt key
 *
 *  @return encrypted string
 */
- (NSString *)AESEncryptForKey:(NSString *)key;
/**
 *  AES decrypt string
 *
 *  @param key decrypt key
 *
 *  @return origin string
 */
- (NSString *)AESDecryptForKey:(NSString *)key;

@end
@interface NSString (NSStringHTML)
/**
 *  Remove all about html tag,style that only plain text
 *
 *  @return plain string
 */
- (NSString *)toText;
/**
 *  Add the html tag to the plain text,generate the html string
 *
 *  @return html string
 */
- (NSString *)toHTML;
/**
 *  Escape the specified string like &amps;->&
 *
 *  @return escaped string
 */
- (NSString *)escapeHTML;
/**
 *  Unescape the  specified string like &->&amps;
 *
 *  @return unescaped string
 */
- (NSString *)unEscapeHTML;
/**
 *  Quote to unichar for "Character too large for enclosing character literal type"
 *
 *  @param string
 *
 *  @return unichar
 */
+ (unichar)quote:(NSString *)string;
@end

@interface NSString (NSStringEstimate)
- (BOOL)isConformNickNameFormat;
- (BOOL)isConformEmailAddressFormat;
- (BOOL)isConformPasswordFormat;
- (BOOL)isConformPhoneNumberFormat;
@end
