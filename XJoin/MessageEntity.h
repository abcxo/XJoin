//
//  MessageEntity.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageEntity : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *abstract;
@property (nonatomic, strong) NSString *fromuser;
@property (nonatomic, strong) NSString *touser;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *obj;
@property (nonatomic, assign) bool agree;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *touser_coverurl;
@property (nonatomic, strong) NSString *fromuser_coverurl;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) double createDate;
@property (nonatomic, assign) double updateDate;
- (NSString *)timeString;
@end
