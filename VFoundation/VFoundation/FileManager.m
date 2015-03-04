//
//  FileManager.m
//
//  Created by shadowxie on 9/26/13.
//
//

#import "FileManager.h"
#import "VFoundation.h"
@implementation FileManager

#pragma mark - 目录操作
+ (BOOL)createDirectory:(NSString *)dirPath {
	NSError *err = nil;
	BOOL isSuc = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&err];
	return isSuc;
}

#pragma mark - 文件操作
+ (BOOL)copyFile:(NSString *)fromPath toPath:(NSString *)toPath replaced:(BOOL)isReplace deleted:(BOOL)isDelete {
	if ([fromPath isMeaningful] && [toPath isMeaningful]) {
		if ([toPath isEqualToString:fromPath]) { //
			return YES;
		}
		NSError *err = nil;
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL isExist = [self isFileExisted:toPath];
		if (isReplace || isExist == NO) {
			if (isExist) { //如果存在要删除掉
				[self removePath:toPath];
			}
			[fileManager copyItemAtPath:fromPath toPath:toPath error:&err];
			if (err) { //copy错误
				return NO;
			}
		}
		if (isDelete) { //要删除原文件
			return [self removePath:fromPath];
		}
	}
	return NO;
}

+ (BOOL)saveFile:(NSData *)data filePath:(NSString *)filePath {
	if ([data isMeaningful] && [filePath isMeaningful]) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL isDir = NO;
		BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
		if (isDir) {
			return NO;
		}
		if (isExist) {
			[self removePath:filePath];
		}
		//创建文件
		BOOL isCreate = [fileManager createFileAtPath:filePath contents:data attributes:nil];
		return isCreate;
	}
	return NO;
}

+ (BOOL)saveFileProgress:(NSData *)data filePath:(NSString *)filePath {
	if ([data isMeaningful] && [filePath isMeaningful]) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL isDir = NO;
		[fileManager fileExistsAtPath:filePath isDirectory:&isDir];
		if (isDir) {
			return NO;
		}
		NSString *dirPath = [filePath stringByDeletingLastPathComponent];
		BOOL isDirExist = [fileManager fileExistsAtPath:filePath isDirectory:nil];
		if (!isDirExist) {
			[self createDirectory:dirPath];
		}

		NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
		BOOL isSuc = NO;
		if (outFile == nil) {
			isSuc = [data writeToFile:filePath atomically:YES];
		}
		else {
			[outFile seekToEndOfFile];
			[outFile writeData:data];
			isSuc = YES;
		}
		[outFile closeFile];
		return isSuc;
	}
	return NO;
}

+ (NSData *)readFile:(NSString *)filePath {
	if ([filePath isMeaningful]) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL isDir = NO;
		BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
		if (isDir) {
			return NO;
		}
		if (isExist) {
			NSData *data = [NSData dataWithContentsOfFile:filePath];
			return data;
		}
	}

	return nil;
}

#pragma mark - 目录和文件的共性操作
+ (BOOL)removePath:(NSString *)path {
	NSError *err = nil;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir = NO;
	if ([fileManager fileExistsAtPath:path isDirectory:&isDir]) {
		if (isDir) { //如果是文件夹，就删除该文件夹的所有内容，包括该文件夹
			NSArray *array = [fileManager contentsOfDirectoryAtPath:path error:&err];
			if (err) {
				return NO;
			}
			for (NSString *fileName in array) {
				[fileManager removeItemAtPath:[path stringByAppendingPathComponent:fileName] error:&err];
				if (err) {
					return NO;
				}
			}
		}
		else { //如果是文件就删除该文件
			[fileManager removeItemAtPath:path error:&err];
			if (err) {
				return NO;
			}
		}
	}
	return YES;
}

+ (BOOL)isFileExisted:(NSString *)path {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir = NO;
	BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
	return isExist;
}

+ (NSDictionary *)fileDict:(NSString *)path {
	return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
}

+ (NSString *)documentsPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths firstObject];
}

+ (NSString *)cachesPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	return [paths firstObject];
}

+ (NSString *)tmpPath {
	return NSTemporaryDirectory();
}

@end
