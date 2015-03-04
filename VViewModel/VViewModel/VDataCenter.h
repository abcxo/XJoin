//
//  VDataCenter.h
//  VViewModel
//
//  Created by shadow on 14-3-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VUtilityDefine.h"
@class VDataCenterRequest;
@class VDataCenter;
@class NSMutableAtomicDictionary;
@protocol VDataCenterDelegate <NSObject>
@optional
- (void)dataCenter:(VDataCenter *)dataCenter load:(id)change error:(NSError *)err;
- (void)dataCenter:(VDataCenter *)dataCenter get:(id)change error:(NSError *)err;
- (void)dataCenter:(VDataCenter *)dataCenter add:(id)change error:(NSError *)err;
- (void)dataCenter:(VDataCenter *)dataCenter edit:(id)change error:(NSError *)err;
- (void)dataCenter:(VDataCenter *)dataCenter remove:(id)change error:(NSError *)err;
- (void)dataCenter:(VDataCenter *)dataCenter clear:(id)change error:(NSError *)err;
@end


@interface VDataCenter : NSObject

@property (nonatomic, strong, readonly) NSMutableAtomicDictionary *dataSource;
@property (nonatomic, strong) NSMutableArray *observers;
- (void)addObserver:(id <VDataCenterDelegate> )observer;
- (void)removeObserver:(id <VDataCenterDelegate> )observer;
- (void)removeObserverAtIndex:(NSInteger)index;



@end
