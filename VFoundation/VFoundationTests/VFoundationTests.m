//
//  VFoundationTests.m
//  VFoundationTests
//
//  Created by shadow on 14-3-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VFoundation.h"
@interface VFoundationTests : XCTestCase

@end

@implementation VFoundationTests

- (void)setUp {
	[super setUp];
	// Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
	// Put teardown code here. This method is called after the invocation of each test method in the class.
	[super tearDown];
}

- (void)testCategoryString {
	//test utility
	NSString *udid = [NSString UDID];
	NSLog(@"shadow test log UDID :%@", udid);
	XCTAssert(udid, @"shadow assert string udid:%@", udid);
	NSString *uuid = [NSString UUID];
	NSLog(@"shadow test log UUID :%@", uuid);
	XCTAssert(uuid, @"shadow assert string uuid:%@", uuid);
	NSString *trimAll = @"   sha  do w is a handsome gu y ";
	NSLog(@"shadow test log trimAll before:%@ after:%@", trimAll, [trimAll trimAll]);
	XCTAssert(trimAll, @"shadow assert string trimAll:%@", trimAll);
	NSString *trimEdge = @"   sha  do w is a handsome gu y ";
	NSLog(@"shadow test log trimEdge before:%@ after:%@", trimEdge, [trimEdge trimEdge]);
	XCTAssert(trimEdge, @"shadow assert string trimEdge:%@", trimEdge);
	NSString *relace = @"shadow is a handsome guy and shadow is a xx";
	NSLog(@"shadow test log relace before:%@ after:%@", relace, [relace replace:@"jessie" ForTarget:@"shadow"]);
	XCTAssert(relace, @"shadow assert string relace:%@", relace);
	NSString *relaces = @"shadow is a handsome guy and jessie is a xx";
	NSLog(@"shadow test log relaces before:%@ after:%@", relaces, [relaces replace:@"amber" ForTargets:@"shadow", @"jessie", nil]);
	XCTAssert(relaces, @"shadow assert string relaces:%@", relaces);
	NSString *add = @"shadow is a handsome guy and jessie is a xx";
	NSLog(@"shadow test log add before:%@ after:%@", add, [add addString:@"and amber too"]);
	XCTAssert(add, @"shadow assert string add:%@", add);
	NSString *adds = @"shadow is a handsome guy and jessie is a xx";
	NSLog(@"shadow test log adds before:%@ after:%@", adds, [adds addStrings:@"and amber too", @"and tower too", nil]);
	XCTAssert(adds, @"shadow assert string adds:%@", adds);
	NSString *contain = @"shadow is a handsome guy and jessie is a xx";
	NSLog(@"shadow test log contain:%d", [contain containString:@"shadow"]);
	XCTAssert(contain, @"shadow assert string contain:%@", contain);
	NSString *contains = @"shadow is a handsome guy and jessie is a xx";
	NSLog(@"shadow test log contains:%d", [contains containStrings:@"shadow", @"jessie", nil]);
	XCTAssert(contains, @"shadow assert string contains:%@", contains);
	NSString *del = @"shadow is a handsome guy and jessie is a xx";
	NSLog(@"shadow test log del before:%@ after:%@", del, [del deleteString:@"jessie is a xx"]);
	XCTAssert(del, @"shadow assert string del:%@", del);
	NSString *dels = @"shadow is a handsome guy and jessie is a xx";
	NSLog(@"shadow test log dels before:%@ after:%@", dels, [dels deleteStrings:@"jessie is a xx", @"shadow", nil]);
	XCTAssert(dels, @"shadow assert string dels:%@", dels);
	NSString *mean = @"     ";
	NSLog(@"shadow test log mean:%d", [mean isMeaningful]);
	XCTAssert(mean, @"shadow assert string mean:%@", mean);
	//test file
	NSString *fileSize = @"2.5M";
	NSLog(@"shadow test fileSize:%llu", [fileSize fileSize]);
	NSLog(@"shadow test fileSizeString:%@", [NSString fileSizeString:[fileSize fileSize]]);

	//test url
	NSString *url = @"http://www.baidu.com/s?wd=我调你啊&rsv_spt=15#$%&issp=1&rsv_bp=0&ie=utf-8&tn=baiduhome_pg&rsv_sug3=6&rsv_sug=0&rsv_sug1=3&rsv_sug4=478";
	NSString *a = @"!*'();:@&=+$,/?%#[]我草你吗";
	NSLog(@"aa%@", [a stringByAddingPercentEscapesUsingEncoding:DEFAULT_ENCODING]);
	NSString *urla = @"http://www.baidu.com/s?wd=!*'();:@=+$,/?我啊二哥弄你爱过#%&rsv_spt=1&issp=1&rsv_bp=0&ie=utf-8&tn=baiduhome_pg&rsv_sug3=7&rsv_sug=0&rsv_sug1=4&rsv_sug4=5623";
	NSURL *aaa = [NSURL URLWithString:[urla URLEncodeAbsoluteString]];
	NSData *data = [NSData dataWithContentsOfURL:aaa];
	NSLog(@"shadow test scheme:%@", [url
	                                 scheme]);
	NSLog(@"shadow test host:%@", [url
	                               host]);
	NSLog(@"shadow test port:%@", [url
	                               port]);
	NSLog(@"shadow test bin:%@", [url
	                              bin]);
	NSLog(@"shadow test parameters:%@", [url
	                                     parameters]);
	NSLog(@"shadow test parameterForKey:%@", [url
	                                          parameterForKey:@"rsv_sug4"]);
	NSLog(@"shadow test URLEncodeString:%@", [url
	                                          URLEncodeString]);
	NSLog(@"shadow test URLDecodeString:%@", [[url URLEncodeString]
	                                          URLDecodeString]);
	NSLog(@"shadow test URLEncodeAbsoluteString:%@", [url
	                                                  URLEncodeAbsoluteString]);
	NSLog(@"shadow test URLDecodeAbsoluteString:%@", [[url URLEncodeAbsoluteString] URLDecodeAbsoluteString]);

	//test crypto
	NSString *text = @"hello,im shadow";
	NSLog(@"shadow test MD5Sum:%@", [text
	                                 MD5Sum]);
	NSLog(@"shadow test MD516Sum:%@", [text
	                                   MD516Sum]);
	NSLog(@"shadow test SHA1Sum:%@", [text
	                                  SHA1Sum]);
	NSLog(@"shadow test SHA256Sum:%@", [text
	                                    SHA256Sum]);
	NSLog(@"shadow test base64EncodeString:%@", [text
	                                             base64EncodeString]);
	NSLog(@"shadow test base64DecodeString:%@", [[text
	                                              base64EncodeString]base64DecodeString]);
	NSLog(@"shadow test AESEncryptForKey:%@", [text
	                                           AESEncryptForKey:@"123"]);
	NSLog(@"shadow test AESDecryptForKey:%@", [[text
	                                            AESEncryptForKey:@"123"] AESDecryptForKey:@"123"]);
}

- (void)testCategoryBundle {
	//在真实的项目就会生效
	NSLog(@"shadow test buildVersion:%@", [NSBundle buildVersion]);
	NSLog(@"shadow test appVersion:%@", [NSBundle appVersion]);
	NSLog(@"shadow test appName:%@", [NSBundle appName]);
	NSLog(@"shadow test appDisplayName:%@", [NSBundle appDisplayName]);
	NSLog(@"shadow test identifier:%@", [NSBundle identifier]);
	NSLog(@"shadow test executable:%@", [NSBundle executable]);
	NSLog(@"shadow test pathForFile:%@", [NSBundle pathForFile:@"InfoPlist.strings"]);
	NSLog(@"shadow test dataForFile:%@", [NSBundle dataForFile:@"InfoPlist.strings"]);
}

- (void)testCategoryURL {
	NSURL *url = [NSURL URLWithString:@"http://www.baidu.com/s?wd=nsurl&rsv_spt=1&issp=1&rsv_bp=0&ie=utf-8&tn=baiduhome_pg&rsv_sug3=3&rsv_sug=0&rsv_sug1=2&rsv_sug4=141"];
	NSLog(@"shadow test parameters:%@", [url parameters]);
	NSLog(@"shadow test parameterForKey:%@", [url parameterForKey:@"rsv_bp"]);
	NSLog(@"shadow test bin:%@", [url bin]);
}

- (void)testCategoryDate {
	NSDate *date = [NSDate date];
	NSLog(@"shadow test year:%d month:%d day:%d weekday:%d hour:%d min:%d second:%d weekOfMonth:%d weekOfYear:%d", [date year], [date month], [date day], [date weekDay], [date hour], [date minute], [date second], [date weekOfMonth], [date weekOfYear]);
	NSDate *firstD = [date beginningOfDay];
	NSDate *endD = [date endOfDay];
	NSDate *firstW = [date beginningOfWeek];
	NSDate *endW = [date endOfWeek];
	NSDate *firstM = [date beginningOfMonth];
	NSDate *endM = [date endOfMonth];
	NSDate *firstY = [date beginningOfYear];
	NSDate *endY = [date endOfYear];
	NSLog(@"shadow test timestamp:%@", [date timestampString]);
}

- (void)testCategoryNumber {
	NSNumber *num = [NSNumber numberWithX:10 andY:30];
	NSLog(@"shadow test number x:%d", [num x]);
	NSLog(@"shadow test number y:%d", [num y]);
	num = [@([num x])xAndY : 50];
	NSLog(@"shadow test number x:%d", [num x]);
	NSLog(@"shadow test number y:%d", [num y]);
}

- (void)testCategorySet {
	NSMutableSet *mSet = [[NSMutableSet alloc] init];
	[mSet addObject:nil];
}

@end
