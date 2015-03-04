//
//  FileManager.h
//
//  Created by shadowxie on 9/26/13.
//
//  专门负责文件存储功能，主要有附件的读写功能

#import <Foundation/Foundation.h>

@interface FileManager : NSObject


//目录操作
+ (BOOL)createDirectory:(NSString *)dirPath;


//文件操作
+ (BOOL)copyFile:(NSString *)fromPath toPath:(NSString *)toPath replaced:(BOOL)isReplace deleted:(BOOL)isDelete;
+ (BOOL)saveFile:(NSData *)data filePath:(NSString *)filePath;
+ (BOOL)saveFileProgress:(NSData *)data filePath:(NSString *)filePath;
+ (NSData *)readFile:(NSString *)filePath;


//共性操作
//进行删除，就是传进来的路径，如果是文件夹，就该文件夹都删除，如果是文件就删除文件
+ (BOOL)removePath:(NSString *)path;
+ (BOOL)isFileExisted:(NSString *)path;
+ (NSDictionary *)fileDict:(NSString *)path;


+ (NSString *)documentsPath;
+ (NSString *)cachesPath;
+ (NSString *)tmpPath;
@end
