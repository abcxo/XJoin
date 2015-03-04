//
//  NSString+VFoundation.m
//  VFoundation
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "NSString+NSStringVFoundation.h"
#import "VFoundation.h"
#import <CommonCrypto/CommonDigest.h>
#import "AESCrypt.h"
#import "GTMBase64.h"
#import "UIDevice+hardware.h"
#import "KeyChainManager.h"
#import "NSString+HTML.h"
#import "HTMLConverter.h"
#define KEYCHAIN_UDID @"udid"
@implementation NSString (NSStringVFoundation)
__ENABLE_EXCHANGE_METHOD__(SELString(initWithUTF8String :))

- (instancetype)__exchange__initWithUTF8String:(const char *)nullTerminatedCString {
	if (nullTerminatedCString != NULL) {
		return [self __exchange__initWithUTF8String:nullTerminatedCString];
	}
	return nil;
}

+ (NSString *)UUID {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	return (__bridge_transfer NSString *)string;
}

- (NSString *)trimEdge {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimAll {
	return [self replace:nil ForTarget:@" "];
}

- (NSString *)replace:(NSString *)string ForTarget:(NSString *)target {
	if (!string) {
		string = @"";
	}
	if (target) {
		return [[self trimEdge] stringByReplacingOccurrencesOfString:target withString:string];
	}
	return self;
}

- (NSString *)replaceTarget:(NSString *)target string:(NSString *)string, ...{
	NSMutableArray *paramArray = [NSMutableArray arrayWithObject:string];
	va_list argList;
	va_start(argList, string);
	NSString *arg = nil;
	while ((arg = va_arg(argList, NSString *)) != nil) {
		[paramArray addObject:arg];
	}
	va_end(argList);


	NSArray *array = [self componentsSeparatedByString:target];
	NSArray *resultArray = [array arrayWithBlock: ^id (id obj, NSInteger index) {
	    return [obj addString:[paramArray objectAtIndex:index]];
	}];
	return [resultArray componentsJoinedByString:@""];
}

- (NSString *)replace:(NSString *)string ForTargets:(NSString *)target, ...{
	NSString *result = [self replace:string ForTarget:target];
	va_list argList;
	va_start(argList, target);
	NSString *arg = nil;
	while ((arg = va_arg(argList, NSString *)) != nil) {
		result = [result replace:string ForTarget:arg];
	}
	va_end(argList);
	return result;
}
- (BOOL)containString:(NSString *)str {
	return !NSEqualRanges([self rangeOfString:str], NSMakeRange(NSNotFound, 0));
}

- (BOOL)containStrings:(NSString *)str, ...{
	BOOL result = [self containString:str];
	if (!result) {
		va_list argList;
		va_start(argList, str);
		NSString *arg = nil;
		while ((arg = va_arg(argList, NSString *)) != nil) {
			result = [self containString:arg];
			if (result == YES) {
				return result;
			}
		}
		va_end(argList);
	}
	return result;
}
- (NSString *)addString:(NSString *)str {
	if (str) {
		return [self stringByAppendingString:str];
	}
	return self;
}

- (NSString *)addStrings:(NSString *)str, ...{
	if (str) {
		NSMutableString *resultStr = [[NSMutableString alloc] initWithFormat:@"%@%@", self, str];
		va_list argList;
		va_start(argList, str);
		NSString *arg = nil;
		while ((arg = va_arg(argList, NSString *)) != nil) {
			[resultStr appendString:arg];
		}
		va_end(argList);
		return resultStr;
	}
	return self;
}
- (NSString *)addFormat:(NSString *)format, ...{
	if (format) {
		va_list argList;
		va_start(argList, format);
		NSString *resultStr = [self addString:[[NSString alloc] initWithFormat:format arguments:argList]];
		va_end(argList);
		return resultStr;
	}
	return self;
}
- (NSString *)deleteString:(NSString *)str {
	return [self replace:nil ForTarget:str];
}

- (NSString *)deleteStrings:(NSString *)str, ...{
	NSString *result = [self deleteString:str];
	va_list argList;
	va_start(argList, str);
	NSString *arg = nil;
	while ((arg = va_arg(argList, NSString *)) != nil) {
		result = [result deleteString:arg];
	}
	va_end(argList);
	return result;
}



- (BOOL)isEmpty {
	BOOL isEmpty = [super isEmpty];
	if (!isEmpty) {
		NSString *tmp = [self trimAll];
		isEmpty = !(tmp.length > 0);
	}
	return isEmpty;
}

@end
@implementation NSString (NSStringFile)
- (NSString *)prefix {
	return [[self componentsSeparatedByString:@"."] firstObject];
}

- (NSString *)suffix {
	return [[self componentsSeparatedByString:@"."] lastObject];
}

- (NSString *)deletePrefixString {
	NSMutableArray *mArray = [NSMutableArray arrayWithArray:[self componentsSeparatedByString:@"."]];
	[mArray removeFirstObject];
	return [mArray componentsJoinedByString:@"."];
}

- (NSString *)deleteSuffixString {
	NSMutableArray *mArray = [NSMutableArray arrayWithArray:[self componentsSeparatedByString:@"."]];
	[mArray removeLastObject];
	return [mArray componentsJoinedByString:@"."];
}

- (unsigned long long)fileSize {
	NSArray *components = nil;
	NSString *source = [[self lowercaseString] trimAll];
	NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"01234567890. "] invertedSet];
	NSRange range = [source rangeOfCharacterFromSet:cs];
	if (range.location != NSNotFound) {
		components = @[[source substringToIndex:range.location],
		               [source substringFromIndex:range.location]];
		NSArray *units  = @[@"t",  @"tb", @"g", @"gb", @"m", @"mb", @"k", @"kb", @"b"];
		NSArray *values = @[@1.024e12, @1.024e12, @1.024e9, @1.024e9,  @1.024e6, @1.024e6,  @1.024e3, @1.024e3,  @1.024];
		for (int i = 0; i < units.count; ++i) {
			if ([[components lastObject] caseInsensitiveCompare:[units objectAtIndex:i]] == NSOrderedSame) {
				return (unsigned long long)([[components objectAtIndex:0] doubleValue] * [[values objectAtIndex:i] doubleValue]);
			}
		}
	}
	return 0;
}

+ (NSString *)fileSizeString:(unsigned long long)filesize {
	if (filesize < 1024) {
		return [NSString stringWithFormat:@"%lldB", filesize];
	}
	else if (filesize < 10240) {
		return [NSString stringWithFormat:@"%0.1lfK", ceil(filesize / 1024.0f * 10) / 10];
	}
	else if (filesize < 1024 * 1024) {
		return [NSString stringWithFormat:@"%lldK", (unsigned long long)ceil(filesize / 1024.0f)];
	}
	else if (filesize < 1024 * 10240) {
		return [NSString stringWithFormat:@"%0.1lfM", ceil(filesize / 1024.0f / 1024.0f * 10) / 10];
	}
	else if (filesize < 1024 * 1024 * 1024) {
		return [NSString stringWithFormat:@"%lldM", (unsigned long long)ceil(filesize / 1024.0f / 1024.0f)];
	}
	else {
		return [NSString stringWithFormat:@"%0.1lfG", ceil(filesize / 1024.0f / 1024.0f / 1024.0f * 10) / 10];
	}
}

- (NSURL *)fileURL {
	return [NSURL fileURLWithPath:self];
}

@end

@implementation NSString (NSStringURL)
- (NSString *)scheme {
	return [[NSURL URLWithString:[self URLEncodeAbsoluteString]] scheme];
}

- (NSString *)host {
	return [[NSURL URLWithString:[self URLEncodeAbsoluteString]] host];
}

- (NSNumber *)port {
	NSURL *url = [NSURL URLWithString:[self URLEncodeAbsoluteString]];
	NSNumber *port = [url port];
	return port;
}

- (NSString *)bin {
	NSURL *url = [NSURL URLWithString:[self URLEncodeAbsoluteString]];
	return [url lastPathComponent];
}

- (NSString *)parameterForKey:(NSString *)key {
	NSDictionary *parameters = [self parameters];
	return [parameters objectForKey:key];
}

- (NSDictionary *)parameters {
	NSURL *url = [NSURL URLWithString:[self URLEncodeAbsoluteString]];
	NSString *parameters = [url query];
	NSArray *parameterArray = [parameters componentsSeparatedByString:@"&"];
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	for (NSString *kv in parameterArray) {
		NSArray *kvArray = [kv componentsSeparatedByString:@"="];
		[result setObject:kvArray[1] forKey:kvArray[0]];
	}
	return result;
}

- (NSString *)URLEncodeString {
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
	                                                                                         (CFStringRef)self, nil,
	                                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]", C_DEFAULT_ENCODING));

	return result;
}

- (NSString *)URLDecodeString {
	NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString : @"+" withString : @" "];
	result = [result stringByReplacingPercentEscapesUsingEncoding:DEFAULT_ENCODING];
	return result;
}

- (NSString *)URLEncodeAbsoluteString {
	if ([self containString:@"://"]) {
		NSURL *url = [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:DEFAULT_ENCODING]];
		NSString *scheme = [[[url scheme] URLEncodeString] addString:@"://"];
		NSString *host = [[url host] URLEncodeString];
		NSString *port = [[url port] stringValue];
		NSString *hostAndPort = port ? [host addFormat:@":%@", port] : host;
		NSArray *binTmpArray = [url pathComponents];
		NSMutableArray *mBinArray = [[NSMutableArray alloc] init];
		for (NSString *str in binTmpArray) {
			NSString *strEncoded = str;
			if (![str isEqualToString:@"/"]) {
				strEncoded = [str URLEncodeString];
			}
			else {
				strEncoded = @"";
			}
			[mBinArray addObject:strEncoded];
		}
		NSArray *parameterTmpArray = [[url query] componentsSeparatedByString:@"&"];
		NSMutableArray *mParameterArray = [[NSMutableArray alloc] init];
		for (NSString *kv in parameterTmpArray) {
			NSArray *kvArray = [kv componentsSeparatedByString:@"="];
			[mParameterArray addObject:[[kvArray[0] URLEncodeString] addStrings:@"=", [kvArray[1] URLEncodeString], nil]];
		}
		return [scheme addStrings:hostAndPort, mParameterArray.count > 0 ? [[mBinArray componentsJoinedByString:@"/"] addString:@"?"]:[mBinArray componentsJoinedByString:@"/"], [mParameterArray componentsJoinedByString:@"&"], nil];
	}
	return self;
}

- (NSString *)URLDecodeAbsoluteString {
	if ([self containString:@"://"]) {
		NSURL *url = [NSURL URLWithString:[self stringByReplacingPercentEscapesUsingEncoding:DEFAULT_ENCODING]];
		NSString *scheme = [[[url scheme] URLDecodeString] addString:@"://"];
		NSString *host = [[url host] URLDecodeString];
		NSArray *binTmpArray = [url pathComponents];
		NSMutableArray *mBinArray = [[NSMutableArray alloc] init];
		for (NSString *str in binTmpArray) {
			NSString *strEncoded = str;
			if (![str isEqualToString:@"/"]) {
				strEncoded = [str URLDecodeString];
			}
			[mBinArray addObject:strEncoded];
		}
		NSArray *parameterTmpArray = [[url query] componentsSeparatedByString:@"&"];
		NSMutableArray *mParameterArray = [[NSMutableArray alloc] init];
		for (NSString *kv in parameterTmpArray) {
			NSArray *kvArray = [kv componentsSeparatedByString:@"="];
			[mParameterArray addObject:[[kvArray[0] URLDecodeString] addStrings:@"=", [kvArray[1] URLDecodeString], nil]];
		}
		return [scheme addStrings:host, [[mBinArray componentsJoinedByString:@""] addString:@"?"], [mParameterArray componentsJoinedByString:@"&"], nil];
	}
	return self;
}

- (NSURL *)URL {
	return [NSURL URLWithString:[self URLEncodeAbsoluteString]];
}

@end

@implementation NSString (NSStringCrypto)
- (NSString *)MD5Sum {
	const char *cStr = [self UTF8String];
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
	NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[result appendFormat:@"%02x", digest[i]];
	return result;
}

- (NSString *)MD516Sum {
	NSString *md5_32Bit_String = [self MD5Sum];
	NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];
	return result;
}

- (NSString *)SHA1Sum {
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
	NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		[result appendFormat:@"%02x", digest[i]];
	}
	return result;
}

- (NSString *)SHA256Sum {
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	uint8_t digest[CC_SHA256_DIGEST_LENGTH];
	CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
	NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
		[result appendFormat:@"%02x", digest[i]];
	}
	return result;
}

- (NSString *)base64EncodeString {
//	NSData *data = [self dataUsingEncoding:DEFAULT_ENCODING];
//	return [GTMBase64 stringByEncodingData:data];
	return nil;
}

- (NSString *)base64DecodeString {
//	NSString *result = [[NSString alloc] initWithData:[GTMBase64 decodeString:self] encoding:DEFAULT_ENCODING];
//	return result;
	return nil;
}

- (NSString *)AESEncryptForKey:(NSString *)key {
//	return [AESCrypt encrypt:self password:key];
	return nil;
}

- (NSString *)AESDecryptForKey:(NSString *)key {
//	return [AESCrypt decrypt:self password:key];
	return nil;
}

@end
@implementation NSString (NSStringHTML)
- (NSString *)toText {
	return [self stringByConvertingHTMLToPlainText];
}

- (NSString *)toHTML {
	return [[[HTMLConverter alloc] init] toHTML:self];
}

- (NSString *)escapeHTML {
	NSMutableString *result = [NSMutableString string];
	NSUInteger start = 0;
	NSUInteger len = [self length];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\"…"];

	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len - start)];
		if (r.location == NSNotFound) {
			[result appendString:[self substringFromIndex:start]];
			break;
		}

		if (start < r.location) {
			[result appendString:[self substringWithRange:NSMakeRange(start, r.location - start)]];
		}
		unichar c = [self characterAtIndex:r.location];
		if (c == '<') {
			[result appendString:@"&lt;"];
		}
		else if (c == '>') {
			[result appendString:@"&gt;"];
		}
		else if (c == '"') {
			[result appendString:@"&quot;"];
		}
		else if (c == [NSString quote:@"…"]) {
			[result appendString:@"&hellip;"];
		}
		else if (c == '&') {
			[result appendString:@"&amp;"];
		}
		start = r.location + 1;
	}

	return result;
}

- (NSString *)unEscapeHTML {
	NSMutableString *result = [NSMutableString string];
	NSMutableString *target = [self mutableCopy];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];

	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[result appendString:target];
			break;
		}

		if (r.location > 0) {
			[result appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}

		if ([target hasPrefix:@"&lt;"]) {
			[result appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		}
		else if ([target hasPrefix:@"&gt;"]) {
			[result appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		}
		else if ([target hasPrefix:@"&quot;"]) {
			[result appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		}
		else if ([target hasPrefix:@"&#39;"]) {
			[result appendString:@"'"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		}
		else if ([target hasPrefix:@"&amp;"]) {
			[result appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		}
		else if ([target hasPrefix:@"&hellip;"]) {
			[result appendString:@"…"];
			[target deleteCharactersInRange:NSMakeRange(0, 8)];
		}
		else {
			[result appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}

	return result;
}

+ (unichar)quote:(NSString *)string {
	if ([string isMeaningful]) {
		return [string characterAtIndex:0];
	}
	return '0';
}

- (CGSize)stringSize:(NSString *)aString {
	NSAttributedString *atrString = [[NSAttributedString alloc] initWithString:aString];
	NSRange range = NSMakeRange(0, atrString.length);
	NSDictionary *dic = [atrString attributesAtIndex:0 effectiveRange:&range];
	CGSize size = [aString boundingRectWithSize:CGSizeMake(237, 200)  options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
	return size;
}

//  获取字符串的大小  ios6
- (CGSize)getStringRect_:(NSString *)aString {
	CGSize size;

	UIFont *nameFont = [UIFont fontWithName:@"Helvetica" size:13];
	size = [aString sizeWithFont:nameFont constrainedToSize:CGSizeMake(237, 200) lineBreakMode:NSLineBreakByCharWrapping];
	return size;
}

@end


@implementation NSString (NSStringEstimate)

- (BOOL)isConformNickNameFormat {
	if ([self isMeaningful]) {
		return self.length <= 12;
	}
	return NO;
}

- (BOOL)isConformEmailAddressFormat {
	if ([self isMeaningful]) {
		NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
		NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
		return [emailTest evaluateWithObject:self];
	}
	return NO;
}

- (BOOL)isConformPasswordFormat {
	if ([self isMeaningful]) {
		return self.length >= 6 && self.length <= 16;
	}
	return NO;
}

- (BOOL)isConformPhoneNumberFormat {
	if ([self isMeaningful]) {
		return self.length >= 6 && self.length <= 16;
	}
	return NO;
}

@end
