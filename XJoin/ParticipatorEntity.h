//
//  ParticipatorEntity.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParticipatorEntity : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *coverurl;
@property (nonatomic, assign) double createDate;
@property (nonatomic, assign) double updateDate;
@end
