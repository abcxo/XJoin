//
//  VUtilityDefine.h
//  VFoundation
//
//  Created by shadow on 14-3-11.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
typedef NS_ENUM (NSInteger, NSQueuePriority) {
	NSQueuePriorityMax = 2,
	NSQueuePriorityHigh = 1,
	NSQueuePriorityDefault = 0,
	NSQueuePriorityLow = -1,
};


typedef NS_ENUM (NSInteger, NSDirectionType) {
	NSDirectionTypeLeft,
	NSDirectionTypeUp,
	NSDirectionTypeRight,
	NSDirectionTypeDown,
};

typedef NS_ENUM (NSInteger, NSOperationType) {
	NSOperationTypeNone,
	NSOperationTypeLoad,
	NSOperationTypeGet,
	NSOperationTypeAdd,
	NSOperationTypeEdit,
	NSOperationTypeRemove,
	NSOperationTypeClear,
};



typedef void (^VFailureCallback) (id request, id response, NSError *error);
typedef void (^VPauseCallback) (id request, id response, NSError *error);
typedef void (^VResumeCallback) (id request, id response, NSError *error);
typedef void (^VCancelCallback) (id request, id response, NSError *error);

typedef void (^VProgressCallback) (id request, CGFloat totlaSize, CGFloat progressSize, NSData *data);
typedef void (^VSuccessCallback) (id request, id response);
typedef void (^VCompletionCallback) (id request,  id response, BOOL isSuccess, NSError *error);

@interface VUtilityDefine : NSObject
	bool CLLocationCoordinate2DIsZero(CLLocationCoordinate2D coor);

@end
