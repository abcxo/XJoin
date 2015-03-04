//
//  VViewModel.m
//  VViewModel
//
//  Created by shadow on 14-3-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "VViewModel.h"
#import "VModel.h"

@interface VViewModel ()

@end
@implementation VViewModel
- (id)initDelegate:(id)delegate {
	self = [self init];
	self.delegate = delegate;

	return self;
}

@end
@implementation VViewModelUI



@end
