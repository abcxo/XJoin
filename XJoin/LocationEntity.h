//
//  LocationEntity.h
//  XJoin
//
//  Created by shadow on 14-8-27.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface LocationEntity : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) BOOL isOnlyTitle;
+ (LocationEntity *)entityWithString:(NSString *)string;
- (NSString *)locationEntityString;
@end
