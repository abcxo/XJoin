//
//  UserDetailTableViewController.m
//  XJoin
//
//  Created by shadow on 14-8-22.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UserDetailTableViewController.h"
#import "XJoin.h"
@interface UserDetailTableViewController () <CustomImagePickerControllerDelegate, XHImageViewerDelegate, IBActionSheetDelegate> {
}
@property (nonatomic, strong) UserEntity *mainUser;
@end

@implementation UserDetailTableViewController
- (void)prepareForData {
	[super prepareForData];
	[[NotificationCenter defaultCenter] addObserver:self selector:@selector(notificatiedLogouted:) name:NOTIFICATION_LOGOUTED object:nil];
}

- (void)notificatiedLogouted:(NSNotification *)ns {
	_mainUser = nil;
}

- (void)dealloc {
	[[NotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (![self.mainUser isMeaningful]) {
		self.navigationItem.rightBarButtonItem = nil;
	}
	if (self.type == UserDetailTableViewControllerTypeOperate) {
		self.navigationItem.rightBarButtonItem = nil;
		[self.navigationController setToolbarHidden:NO animated:YES];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)prepareForView {
	[super prepareForView];
	if (self.type != UserDetailTableViewControllerTypeEdit) {
		self.tableView.allowsSelection = NO;
		if (self.type == UserDetailTableViewControllerTypeOperate) {
			if (self.message.agree == YES) {
				self.ignoreBarItem.title = LOCALIZED(@"忽略");
				self.agreeBarItem.title = LOCALIZED(@"已同意");
			}
			else {
				self.ignoreBarItem.title = LOCALIZED(@"忽略");
				self.agreeBarItem.title = LOCALIZED(@"同意");
			}
		}
	}
	self.photoScrollView.dataSource = self;
	self.photoScrollView.delegate = self;
	[self prepareForUserView];
}

- (void)prepareForUserView {
	if ([self.user isMeaningful]) {
		[self.avatarImageView setImageWithURL:[self.user avatarURL] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
		self.nickNameLabel.text = self.user.nickname;
		self.genderImageView.image = [UIImage imageNamed:[self.user.gender isEqualToString:@"1"] ? @"icon_gender_male":@"icon_gender_female"];
		self.regionLabel.text = self.user.region;
		self.signatureLabel.text = self.user.signature;
		[self.signatureLabel setFrameX:SCREEN_WIDTH - 20 - CGRectGetWidth(self.signatureLabel.frame)];
		self.photoCountLabel.text = Format(LOCALIZED(@"活動照片(%d)"), (int)self.user.photos.count);
	}
	else {
		[self handleLoadUser:self.uid];
	}
}

- (void)setUser:(UserEntity *)user {
	_user = user;
	if (self.type != UserDetailTableViewControllerTypeEdit && [user isMeaningful] && [_user.id isEqualToString:self.mainUser.id]) {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (UserEntity *)mainUser {
	if (![_mainUser isMeaningful]) {
		_mainUser = [UserEntity mainUser];
	}
	return _mainUser;
}

- (void)handleLoadUser:(NSString *)uid {
	if ([uid isMeaningful]) {
		self.user = [[UserEntity get:Format(@"id = '%@'", uid)] firstObject];
		if ([self.user isMeaningful]) {
			[self prepareForUserView];
		}
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		[manager GET:[NETWORK_HOST addString:@"user.php?action=getinfo"] parameters:[self.mainUser.id isMeaningful] ?
		 @{
		     @"id" : uid,
		     @"uid" : self.mainUser.id,
                         @"language":[Utils preferredLanguage],
		 }
					:
		 @{
		     @"id" : uid,
                         @"language":[Utils preferredLanguage],
		 }
		 success: ^(AFHTTPRequestOperation *operation, id responseObject) {
		    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
		        UserEntity *user = [UserEntity toObject:[responseObject objectForKey:@"resultContent"]];
		        [user put];
		        self.user = user;

		        [self prepareForUserView];
			}
		    else {
		        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
			}
		} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
		    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
		}];
	}
}

- (IBAction)handleChooseAvatar:(id)sender {
	if (self.type == UserDetailTableViewControllerTypeEdit) {
		CustomImagePickerController *picker = [[CustomImagePickerController alloc] init];
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			[picker setSourceType:UIImagePickerControllerSourceTypeCamera];
		}
		else {
			[picker setIsSingle:YES];
			[picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		}
		[picker setCustomDelegate:self];
		if (IOS_VERSION_LOW_7) {
			[picker.navigationBar setBackgroundImage:COLOR_MAIN_RED_DARK.image forBarMetrics:UIBarMetricsDefault];
		}
		else {
			picker.navigationBar.barTintColor = COLOR_MAIN_RED_DARK;
		}

		picker.navigationBar.translucent = NO;
		picker.navigationBar.titleTextAttributes = @{ UITextAttributeTextColor : [UIColor whiteColor] };
		[self presentModalViewController:picker animated:YES];
	}
	else {
		XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
		imageViewer.delegate = self;
		UIImageView *imageView = self.avatarImageView;
		[imageViewer showWithImageViews:@[imageView] selectedView:imageView];
	}
}

- (void)pickedPhoto:(UIImage *)image {
	self.avatarImageView.image = image;
	NSData *imageData = UIImageJPEGRepresentation(self.avatarImageView.image, 0.5);
	[FileManager saveFile:imageData filePath:[[FileManager documentsPath] stringByAppendingPathComponent:@"avatar.jpg"]];
	if ([self.user isMeaningful]) {
		MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在上傳...")];
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		NSDictionary *parameters = @{
			@"action": @"add",
			@"type": @"user",
			@"obj_id": self.user.id,
                        @"language":[Utils preferredLanguage],
		};
		[manager POST:[NETWORK_HOST addString:@"photo.php"] parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
		    [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
		} success: ^(AFHTTPRequestOperation *operation, id responseObject) {
		    self.user.coverurl = responseObject[@"resultContent"][@"url"];
		    [self.user put];
		    [progressView dismiss:YES];
		} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
		    [progressView dismiss:YES];
		    [MRProgressOverlayView showNO:LOCALIZED(@"頭像上傳失敗，請稍後重試！")];
		}];
	}
}

- (void)handleNavBarRight:(id)sender {
	[super handleNavBarRight:sender];
	if (self.type == UserDetailTableViewControllerTypeQuickLook) {
		if (self.user.isfriend) {
			IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZED(@"取消") destructiveButtonTitle:LOCALIZED(@"邀請活動") otherButtonTitles:LOCALIZED(@"發送消息"), LOCALIZED(@"刪除好友"), nil];
			[standardIBAS showInView:[UIApplication window]];
		}
		else {
			IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZED(@"取消") destructiveButtonTitle:LOCALIZED(@"添加好友") otherButtonTitles:nil, nil];
			[standardIBAS showInView:[UIApplication window]];
		}
	}
	if (self.type == UserDetailTableViewControllerTypeNearBy) {
		if (self.user.isfriend) {
			IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZED(@"取消") destructiveButtonTitle:LOCALIZED(@"邀請活動") otherButtonTitles:LOCALIZED(@"發送消息"), LOCALIZED(@"刪除好友"), nil];
			[standardIBAS showInView:[UIApplication window]];
		}
		else {
			IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZED(@"取消") destructiveButtonTitle:LOCALIZED(@"添加好友") otherButtonTitles:LOCALIZED(@"打招呼"), nil];
			[standardIBAS showInView:[UIApplication window]];
		}
	}

	else if (self.type == UserDetailTableViewControllerTypeEdit) {
		IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZED(@"取消") destructiveButtonTitle:LOCALIZED(@"退出登錄") otherButtonTitles:nil, nil];
		[standardIBAS showInView:[UIApplication window]];
	}
}

- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (self.type == UserDetailTableViewControllerTypeQuickLook) {
		if (self.user.isfriend) {
			switch (buttonIndex) {
				case 0:
				{
					[self performSegueWithIdentifier:[ActivityViewController className] sender:nil];
				}

				break;

				case 1:
				{
					[self performSegueWithIdentifier:[MessageNewViewController className] sender:nil];
				}

				break;

				case 2:
				{
					MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在刪除...")];
					AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
					[manager GET:[NETWORK_HOST addString:@"user.php?action=friend"] parameters:
					 @{
					     @"type" : @"remove",
					     @"uid":self.mainUser.id,
					     @"fid":self.user.id,
                                     @"language":[Utils preferredLanguage],
					 }
					     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
					    [progressView dismiss:YES];
					    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
					        self.user.isfriend = NO;
					        [self.user updateDate];
					        [MRProgressOverlayView showYES:LOCALIZED(@"已經刪除該好友！")];
						}
					    else {
					        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
						}
					} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
					    [progressView dismiss:YES];
					    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
					}];
				}

				break;


				default:
					break;
			}
		}
		else {
			if (buttonIndex == 0) {
				MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在添加...")];
				AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
				[manager GET:[NETWORK_HOST addString:@"message_system.php?action=add"] parameters:
				 @{
				     @"type":@"make_friends",
				     @"subject":self.mainUser.nickname,
				     @"content":LOCALIZED(@"申請添加為好友"),
				     @"touser":self.user.id,
				     @"fromuser":self.mainUser.id,
				     @"obj":self.mainUser.id,
                                 @"language":[Utils preferredLanguage],
				 }
				     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
				    [progressView dismiss:YES];
				    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
				        [MRProgressOverlayView showYES:LOCALIZED(@"已經發送添加好友申請消息！")];
					}
				    else {
				        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
					}
				} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
				    [progressView dismiss:YES];
				    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
				}];
			}
		}
	}
	else if (self.type == UserDetailTableViewControllerTypeNearBy) {
		if (self.user.isfriend) {
			switch (buttonIndex) {
				case 0:
				{
					[self performSegueWithIdentifier:[ActivityViewController className] sender:nil];
				}

				break;

				case 1:
				{
					[self performSegueWithIdentifier:[MessageNewViewController className] sender:nil];
				}

				break;

				case 2:
				{
					MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在刪除...")];
					AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
					[manager GET:[NETWORK_HOST addString:@"user.php?action=friend"] parameters:
					 @{
					     @"type" : @"remove",
					     @"uid":self.mainUser.id,
					     @"fid":self.user.id,
                                     @"language":[Utils preferredLanguage],
					 }
					     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
					    [progressView dismiss:YES];
					    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
					        self.user.isfriend = NO;
					        [self.user updateDate];
					        [MRProgressOverlayView showYES:LOCALIZED(@"已經刪除該好友！")];
						}
					    else {
					        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
						}
					} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
					    [progressView dismiss:YES];
					    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
					}];
				}

				break;


				default:
					break;
			}
		}
		else {
			if (buttonIndex == 0) {
				MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在添加...")];
				AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
				[manager GET:[NETWORK_HOST addString:@"message_system.php?action=add"] parameters:
				 @{
				     @"type":@"make_friends",
				     @"subject":self.mainUser.nickname,
				     @"content":LOCALIZED(@"申請添加為好友"),
				     @"touser":self.user.id,
				     @"fromuser":self.mainUser.id,
				     @"obj":self.mainUser.id,
                                 @"language":[Utils preferredLanguage],
				 }
				     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
				    [progressView dismiss:YES];
				    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
				        [MRProgressOverlayView showYES:LOCALIZED(@"已經發送添加好友申請消息！")];
					}
				    else {
				        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
					}
				} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
				    [progressView dismiss:YES];
				    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
				}];
			}
			else if (buttonIndex == 1) {
				MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在打招呼...")];
				AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
				[manager GET:[NETWORK_HOST addString:@"message_system.php?action=add"] parameters:
				 @{
				     @"type":MESSAGE_FRIEND_HELLO_TYPE,
				     @"subject":self.mainUser.nickname,
				     @"content":LOCALIZED(@"附近的人向你打招呼！"),
				     @"touser":self.user.id,
				     @"fromuser":self.mainUser.id,
				     @"obj":self.mainUser.id,
                                 @"language":[Utils preferredLanguage],
				 }
				     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
				    [progressView dismiss:YES];
				    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
				        [MRProgressOverlayView showYES:LOCALIZED(@"已經發送一個招呼！")];
					}
				    else {
				        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
					}
				} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
				    [progressView dismiss:YES];
				    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
				}];
			}
		}
	}

	else if (self.type == UserDetailTableViewControllerTypeEdit) {
		if (buttonIndex == 0) { //退出登錄
			[ShareSDK cancelAuthWithType:ShareTypeFacebook];
			[FileManager removePath:[self.user avatarFileUrl]];
			[self.user del];
			[[StorageDefaults userDefaults] removeObjectForKey:USER_DEFAULT_MAIN_UID];
			[[StorageDefaults userDefaults] removeObjectForKey:USER_DEFAULT_IS_LOGINED];
			[[NotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUTED object:nil userInfo:@{ [UserEntity className]:self.user }];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

- (NSUInteger)numberOfItems:(CrossScrollView *)collectionView {
	return self.user.photos.count;
}

- (CGFloat)crossScrollView:(CrossScrollView *)collectionView widthForItemAtIndex:(NSUInteger)index {
	return CGRectGetHeight(collectionView.bounds);
}

- (UIView *)crossScrollView:(CrossScrollView *)collectionView viewForItemAtIndex:(NSUInteger)index {
	UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 70)];
	view.clipsToBounds = YES;
	view.contentMode = UIViewContentModeScaleAspectFill;
	view.layer.shadowColor = COLOR_MAIN_GRAY.CGColor;
	view.layer.shadowOffset = CGSizeMake(4, 3);
	view.layer.shadowOpacity = 0.3; //阴影透明度，默认0
	[view setImageWithURL:[[self.user.photos objectAtIndex:index] URL] placeholderImage:[UIImage imageNamed:@"icon_cover_default"]];
	return view;
}

- (void)crossScrollView:(CrossScrollView *)collectionView didSelectItemAtIndex:(NSUInteger)index {
	XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
	imageViewer.delegate = self;
	NSMutableArray *imageViews = [NSMutableArray arrayWithArray:[self.photoScrollView allItemViews]];
	[imageViewer showWithImageViews:imageViews selectedView:(UIImageView *)[self.photoScrollView viewForItemAtIndex:index]];
}

- (IBAction)handleIgnore:(id)sender {
	MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在忽略...")];
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:[NETWORK_HOST addString:@"message_system.php?action=remove"] parameters:
	 @{
	     @"id":self.message.id,
                     @"language":[Utils preferredLanguage],
	 }
	     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    [progressView dismiss:YES];
	    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	        [MRProgressOverlayView showYES:LOCALIZED(@"已經忽略")];
	        [self.navigationController popViewControllerAnimated:YES];
		}
	    else {
	        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
		}
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    [progressView dismiss:YES];
	    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
	}];
}

- (IBAction)handleAgree:(id)sender {
	if (!self.message.agree) {
		MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在同意...")];
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		[manager GET:[NETWORK_HOST addString:@"user.php?action=action_message"] parameters:
		 @{
		     @"type":@"agree",
		     @"m_id":self.message.id,
		     @"agree":@(1),
                         @"language":[Utils preferredLanguage],
		 }
		     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
		    [progressView dismiss:YES];
		    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
		        self.agreeBarItem.title = LOCALIZED(@"已同意");
		        [MRProgressOverlayView showYES:LOCALIZED(@"已經成為你的好友！")];
			}
		    else {
		        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
			}
		} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
		    [progressView dismiss:YES];
		    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
		}];
	}
	else {
		[MRProgressOverlayView showYES:LOCALIZED(@"已經成為你的好友！")];
	}
}

- (void)backPassViewController:(UIViewController *)viewController pass:(id)userInfo {
	if ([viewController isKindOfClass:[RegionTableViewController class]]) {
		self.user.region = userInfo[@"region"];
		[self.user put];
		[self prepareForUserView];
		[self handleUploadUserValue:self.user.region forKey:@"region"];
	}
	else if ([viewController isKindOfClass:[UserEditNameViewController class]]) {
		self.user = userInfo[@"user"];
		[self.user put];
		[self prepareForUserView];
		[self handleUploadUserValue:self.user.nickname forKey:@"nickname"];
	}
	else if ([viewController isKindOfClass:[UserEditContentViewController class]]) {
		self.user = userInfo[@"user"];
		[self.user put];
		[self prepareForUserView];
		[self handleUploadUserValue:self.user.signature forKey:@"signature"];
	}
	else if ([viewController isKindOfClass:[UserGenderTableViewController class]]) {
		self.user = userInfo[@"user"];
		[self.user put];
		[self prepareForUserView];
		[self handleUploadUserValue:self.user.gender forKey:@"gender"];
	}

	else if ([viewController isKindOfClass:[ActivityViewController class]]) {
		ActivityEntity *activity = userInfo[@"activity"];
		MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在邀請...")];
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		[manager GET:[NETWORK_HOST addString:@"message_system.php?action=add"] parameters:
		 @{
		     @"type":MESSAGE_ACTIVITY_INVITE_TYPE,
		     @"subject":self.mainUser.nickname,
		     @"content":Format(LOCALIZED(@"%@ 的活動邀請：%@"), self.mainUser.nickname, activity.subject),
		     @"touser":self.user.id,
		     @"fromuser":self.mainUser.id,
		     @"obj":activity.id,
                         @"language":[Utils preferredLanguage],
             
		 }
		     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
		    [progressView dismiss:YES];
		    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
		        [MRProgressOverlayView showYES:LOCALIZED(@"已經發送活动邀请消息！")];
			}
		    else {
		        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
			}
		} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
		    [progressView dismiss:YES];
		    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
		}];
	}
}

- (void)handleUploadUserValue:(NSString *)value forKey:(NSString *)key {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:[NETWORK_HOST addString:@"user.php?action=edit"] parameters:
	 @{
	     @"id":self.user.id,
	     key:[value isMeaningful] ? value : @"",
                     @"language":[Utils preferredLanguage],
	 }
	     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    NSLog(@"upload user success");
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:[UserEditNameViewController className]]) {
		UserEditNameViewController *controller = segue.destinationViewController;
		controller.user = self.user;
		controller.passedDelegate = self;
	}
	else if ([segue.identifier isEqualToString:[UserQuickLookQRCoderViewController className]]) {
		UserQuickLookQRCoderViewController *controller = segue.destinationViewController;
		controller.user = self.user;
	}
	else if ([segue.identifier isEqualToString:[UserEditContentViewController className]]) {
		UserEditContentViewController *controller = segue.destinationViewController;
		controller.user = self.user;
		controller.passedDelegate = self;
	}
	else if ([segue.identifier isEqualToString:[UserGenderTableViewController className]]) {
		UserGenderTableViewController *controller = segue.destinationViewController;
		controller.user = self.user;
		controller.passedDelegate = self;
	}
	else if ([segue.identifier isEqualToString:[RegionTableViewController className]]) {
		RegionTableViewController *controller = segue.destinationViewController;
		controller.passedDelegate = self;
	}
	else if ([segue.identifier isEqualToString:[ActivityViewController className]]) {
		ActivityViewController *controller = (ActivityViewController *)[segue.destinationViewController topViewController];
		controller.passedDelegate = self;
	}
	else if ([segue.identifier isEqualToString:[MessageNewViewController className]]) {
		MessageNewViewController *controller = (MessageNewViewController *)[segue.destinationViewController topViewController];
		controller.uid = self.user.id;
	}
}

@end
