//
//  VUtilityDefine.m
//  VFoundation
//
//  Created by shadow on 14-3-11.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "VUtilityDefine.h"

@implementation VUtilityDefine
bool CLLocationCoordinate2DIsZero(CLLocationCoordinate2D coor) {
	return coor.latitude == 0 && coor.longitude == 0;
}

@end
