//
//  UserEntity.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *qrcoder;
@property (nonatomic, assign) int age;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *coverurl;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) bool isfriend;
@property (nonatomic, strong) NSArray *photos;


@property (nonatomic, assign) double createDate;
@property (nonatomic, assign) double updateDate;
+ (UserEntity *)mainUser;
- (NSURL *)avatarURL;
//數據庫不允許使用from
- (void)setFrom:(NSString *)from;
- (NSString *)from;
- (BOOL)isMain;
- (NSString *)avatarFileUrl;


- (NSString *)distance;
- (void)setDistance:(NSString *)distance;
- (NSString *)last_login;
- (void)setLast_login:(NSString *)last_login;


@end
