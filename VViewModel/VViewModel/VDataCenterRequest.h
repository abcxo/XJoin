//
//  VDataCenterRequest.h
//  VViewModel
//
//  Created by shadow on 14-5-10.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "VRequest.h"
@class VCoreDataRequest;
@class VNetworkRequest;
@class VViewModel;

typedef NS_ENUM (NSInteger, VDataCenterRequestType) {
	VDataCenterRequestTypeBoth,
	VDataCenterRequestTypeOnlyLocal,
	VDataCenterRequestTypeOnlyNetwork,
};

@interface VDataCenterRequest : VRequest
@property (nonatomic, strong) VCoreDataRequest *coreDataRequest;
@property (nonatomic, strong) VNetworkRequest *networkRequest;
@property (nonatomic, strong) VViewModel *viewModel;
@property (nonatomic, assign) VDataCenterRequestType type;
@end
