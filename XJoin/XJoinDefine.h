//
//  XJoinDefine.h
//  XJoin
//
//  Created by shadow on 14-8-25.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BackPassViewControllerDelegate <NSObject>
- (void)backPassViewController:(UIViewController *)viewController pass:(id)userInfo;

@end



#define NETWORK_HOST @"http://www.ujoinx.net/ujoin/api/"

#define COLOR_MAIN_RED [UIColor colorWithRed:239 / 255.0 green:62 / 255.0 blue:54 / 255.0 alpha:1]
#define COLOR_MAIN_RED_DARK [UIColor colorWithRed:161 / 255.0 green:36 / 255.0 blue:20 / 255.0 alpha:1]
#define COLOR_MAIN_ORANGE [UIColor colorWithRed:254 / 255.0 green:97 / 255.0 blue:66 / 255.0 alpha:1]
#define COLOR_MAIN_ORANGE_DARK [UIColor colorWithRed:205 / 255.0 green:159 / 255.0 blue:128 / 255.0 alpha:1]
#define COLOR_MAIN_GRAY [UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1]
#define COLOR_MAIN_GRAY_MID [UIColor colorWithRed:227 / 255.0 green:227 / 255.0 blue:227 / 255.0 alpha:1]
#define COLOR_MAIN_GRAY_LIGHT [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:242 / 255.0 alpha:1]
#define COLOR_MAIN_BLACK_LIGHT [UIColor colorWithRed:112 / 255.0 green:112 / 255.0 blue:112 / 255.0 alpha:1]


#define COLOR_MAIN_BLACK_DARK [UIColor colorWithRed:32 / 255.0 green:32 / 255.0 blue:32 / 255.0 alpha:1]
#define COLOR_MAIN_BLUE [UIColor colorWithRed:0 / 255.0 green:76 / 255.0 blue:205 / 255.0 alpha:1]



#define MESSAGE_ACTIVITY_INVITE_TYPE @"activity_invite"
#define MESSAGE_ACTIVITY_CANCEL_TYPE @"activity_cancel"
#define MESSAGE_FRIEND_ADD_TYPE @"make_friends"
#define MESSAGE_FRIEND_SEND_TYPE @"send_friends"
#define MESSAGE_FRIEND_HELLO_TYPE @"send_hello"


#define USERSTATE_CREATOR @"creator"
#define USERSTATE_PARTICIPATOR @"participator"
#define USERSTATE_LIKER  @"liker"

#define LOCALIZED(a)    NSLocalizedString(a, nil)

@interface XJoinDefine : NSObject

@end
