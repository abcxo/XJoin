//
//  VCoreDataRequest.h
//  VCoreData
//
//  Created by shadow on 14-3-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "VRequest.h"

@interface VCoreDataRequest : VRequest
@end



@interface VCoreDataQueryRequest : VCoreDataRequest
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *properties;
@property (nonatomic, strong) NSArray *classes;
@property (nonatomic, strong) NSString *resultClass;




@end

@interface VCoreDataAddRequest : VCoreDataRequest
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *properties;
//@property (nonatomic, strong) NSArray *classes;
@property (nonatomic, strong) NSArray *objects;


@end


@interface VCoreDataUpdateRequest : VCoreDataRequest
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *properties;
//@property (nonatomic, strong) NSArray *classes;
@property (nonatomic, strong) NSArray *objects;




@end


@interface VCoreDataDelRequest : VCoreDataRequest

@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSArray *properties;
@property (nonatomic, strong) NSArray *classes;


@end

@interface VCoreDataExecuteRequest : VCoreDataRequest
@property (nonatomic, strong) NSString *command;
@property (nonatomic, strong) NSArray *paramArray;
@end
