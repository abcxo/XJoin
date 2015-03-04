//
//  ActivityEntity.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class LocationEntity;
@interface ActivityEntity : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *abstract;
@property (nonatomic, strong) NSString *activitycover;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *creator;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *participators;
@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userstate;
@property (nonatomic, assign) bool is_end;
@property (nonatomic, assign) int day_num;
@property (nonatomic, assign) int join_num;
@property (nonatomic, assign) int inst_num;

@property (nonatomic, assign) double begin_date;
@property (nonatomic, assign) double end_date;


@property (nonatomic, assign) double createDate;
@property (nonatomic, assign) double updateDate;
- (NSString *)beginDateString;
- (NSString *)endDateString;

- (LocationEntity *)locationEntity;
- (void)setLocationEntity:(LocationEntity *)locationEntity;
- (BOOL)isMain;
@end
