//
//  VUIKitDefine.h
//  VUIKit
//
//  Created by shadow on 14-4-17.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define V_NAV(__controller__) [[UINavigationController alloc] initWithRootViewController : __controller__]


@interface VUIKitDefine : NSObject
	CG_EXTERN CGFloat CGRectGetLeastX(CGRect rect);
CG_EXTERN CGFloat CGRectGetLeastY(CGRect rect);
CG_EXTERN CGRect CGRectMakeWithSize(CGSize size);
CG_EXTERN CGRect CGRectMakeWithRect(CGRect rect);

@end
