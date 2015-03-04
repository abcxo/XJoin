//
//  LocationEntity.m
//  XJoin
//
//  Created by shadow on 14-8-27.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "LocationEntity.h"
#import "XJoin.h"
@implementation LocationEntity
+ (LocationEntity *)entityWithString:(NSString *)string {
	NSArray *array = [string componentsSeparatedByString:@";"];
	LocationEntity *result = [[LocationEntity alloc] init];
	double lat = 0;
	double lng = 0;
	for (NSString *str in array) {
		NSArray *a = [str componentsSeparatedByString:@"="];
		NSString *key = [a firstObject];
		NSString *value = [a lastObject];
		if ([key isEqualToString:@"title"]) {
			result.title = value;
		}
		else if ([key isEqualToString:@"latitude"]) {
			lat = [value doubleValue];
		}
		else if ([key isEqualToString:@"longitude"]) {
			lng = [value doubleValue];
		}
	}
	result.coordinate = CLLocationCoordinate2DMake(lat, lng);
	return result;
}

- (NSString *)locationEntityString {
	return Format(@"title=%@;latitude=%f;longitude=%f", self.title, self.coordinate.latitude, self.coordinate.longitude);
}

- (BOOL)isMeaningful {
	return ([super isMeaningful] && [self.title isMeaningful] && !CLLocationCoordinate2DIsZero(self.coordinate)) || self.isOnlyTitle;
}

@end
