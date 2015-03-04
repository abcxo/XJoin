//
//  XJoin.h
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "VUIKit.h"
#import "VFoundation.h"
#import "VCoreData.h"
#import "VModel.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "XJoinDefine.h"
//基础层
#import "StorageDefaults.h"
#import "NotificationCenter.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"
#import "Utils.h"
#import <ShareSDK/ShareSDK.h>
//模型层
#import "UserEntity.h"
#import "ActivityEntity.h"
#import "MessageEntity.h"
#import "ParticipatorEntity.h"
#import "LocationEntity.h"

//控制层
#import "ActivityViewController.h"
#import "ActivityDetailViewController.h"
#import "ActivityNewViewController.h"
#import "MapViewController.h"
#import "MessageTableViewController.h"
#import "MessageNewViewController.h"
#import "FriendTableViewController.h"
#import "UserDetailTableViewController.h"
#import "UserNearByTableViewController.h"
#import "UserEditNameViewController.h"
#import "UserEditContentViewController.h"
#import "UserQuickLookQRCoderViewController.h"
#import "UserGenderTableViewController.h"
#import "UserNewViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "RegionTableViewController.h"
#import "SettingTableViewController.h"
#import "PrivacyPolicyViewController.h"

//视图层
#import "TableViewCell.h"
#import "ActivityRecommendTableViewCell.h"
#import "ActivityMeTableViewCell.h"
#import "MessageTableViewCell.h"
#import "FriendTableViewCell.h"
#import "UserNearByTableViewCell.h"
#import "RegionTableViewCell.h"
#import "MessageNewLeftTableViewCell.h"
#import "MessageNewRightTableViewCell.h"
#import "CardTableViewCell.h"
#import "CircleImageView.h"
#import "CrossScrollView.h"
#import "FitLabel.h"
#import "RoundButton.h"
#import "CustomImagePickerController.h"
#import "ImageFilterProcessViewController.h"
#import "XHImageViewer/XHImageViewer.h"
#import "MJRefresh.h"
#import "MRProgress.h"
#import "IBActionSheet.h"
#import "PPiFlatSegmentedControl.h"
#import "ZJSwitch.h"
#import "SIAlertView.h"

#import "UINavigationBar+UINavigationBarXJoin.h"
#import "UIToolbar+UIToolbarXJoin.h"
#import "UITabBar+UITabBarXJoin.h"
#import "UISearchBar+UISearchBarXJoin.h"
#import "UIBarButtonItem+UIBarButtonItemXJoin.h"
@interface XJoin : NSObject
+ (void)setup;
@end
