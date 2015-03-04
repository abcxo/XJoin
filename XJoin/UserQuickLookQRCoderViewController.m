//
//  UserQuickLookQRCoderViewController.m
//  XJoin
//
//  Created by shadow on 14-8-26.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UserQuickLookQRCoderViewController.h"
#import "XJoin.h"
@interface UserQuickLookQRCoderViewController ()

@end

@implementation UserQuickLookQRCoderViewController
- (void)prepareForView {
	[super prepareForView];
	self.QRCoderImageView.image = [QRCodeGenerator qrImageForString:self.user.username imageSize:300];
}

@end
