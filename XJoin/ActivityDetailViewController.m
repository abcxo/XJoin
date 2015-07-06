//
//  ActivityDetailViewController.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "XJoin.h"
@interface ActivityDetailViewController () <CustomImagePickerControllerDelegate, XHImageViewerDelegate, IBActionSheetDelegate> {
}
@property (nonatomic, strong) UserEntity *mainUser;
@end
@implementation ActivityDetailViewController
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
	[self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (UserEntity *)mainUser {
	if (![_mainUser isMeaningful]) {
		_mainUser = [UserEntity mainUser];
	}
	return _mainUser;
}

- (void)prepareForView {
	[super prepareForView];

	self.parScrollView.dataSource = self;
	self.parScrollView.delegate = self;
	self.photoScrollView.dataSource = self;
	self.photoScrollView.delegate = self;
    self.locationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.locationBtn.titleLabel.numberOfLines=2;
	[self prepareForUserView];
}

- (void)prepareForUserView {
	if ([self.activity isMeaningful]) {
		[self.coverImageView setImageWithURL:[self.activity.activitycover URL]  placeholderImage:[UIImage imageNamed:@"icon_cover_default"]];
		self.titleLabel.text = self.activity.subject;
		self.timeLabel.text = self.activity.beginDateString;
		self.timeEndLabel.text = self.activity.endDateString;
		self.locationBtn.text = self.activity.locationEntity.title;
		self.typeLabel.text = self.activity.type;
		self.creatorLabel.text = self.activity.nickname;
		self.contentTV.text = self.activity.content;
		[self prepareForBarView];
		[self reloadParData];
		[self reloadPhotoData];
	}
	else {
		[self handleLoadActivity:self.aid];
	}
}

- (void)prepareForBarView {
	if ([self.activity.userstate containString:USERSTATE_PARTICIPATOR]) {
		self.joinBarItem.title =LOCALIZED( @"已參加");
	}

	else {
		self.joinBarItem.title = LOCALIZED(@"參加");
	}

	if ([self.activity.userstate containString:USERSTATE_LIKER]) {
		self.loveBarItem.title =LOCALIZED( @"已贊它");
	}
	else {
		self.loveBarItem.title = LOCALIZED(@"贊它");
	}
}

- (void)reloadParData {
	self.parCountLabel.text = Format(LOCALIZED(@"活動參與者(%d)"), (int)self.activity.participators.count);
	[self.parScrollView reloadData];
}

- (void)reloadPhotoData {
	self.photoCountLabel.text = Format(LOCALIZED(@"活動照片(%d)"), (int)self.activity.photos.count);

	[self.photoScrollView reloadData];
}

- (IBAction)handleCover:(id)sender {
	XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
	imageViewer.delegate = self;
	[imageViewer showWithImageViews:@[self.coverImageView] selectedView:self.coverImageView];
}

- (void)handleLoadActivity:(NSString *)aid {
	if ([aid isMeaningful]) {
		self.activity = [[ActivityEntity get:Format(@"id = '%@'", aid)] firstObject];
		if ([self.activity isMeaningful]) {
			[self prepareForUserView];
		}
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		[manager GET:[NETWORK_HOST addString:@"activity.php?action=activity_info"] parameters:
		 @{
		     @"id" : aid,
		     @"uid":self.mainUser.id,
                         @"language":[Utils preferredLanguage],
		 }
		     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
		    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
		        ActivityEntity *activity = [ActivityEntity toObject:[responseObject objectForKey:@"resultContent"]];
		        if ([activity.subject isMeaningful]) {
		            [activity put];
		            self.activity = activity;
		            [self prepareForUserView];
				}
		        else {
		            [MRProgressOverlayView showNO:LOCALIZED(@"該活動已經取消了！")];
		            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		                [self.navigationController popViewControllerAnimated:YES];
					});
				}
			}
		    else {
		        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
			}
		} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
		    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
		}];
	}
	else {
		[MRProgressOverlayView showNO:LOCALIZED(@"該活動已經取消了！")];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)pickedPhoto:(UIImage *)image {
	if ([self.activity isMeaningful]) {
		MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在上傳...")];
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		NSDictionary *parameters = @{
			@"action": @"add",
			@"type": @"activity",
			@"obj_id": self.activity.id,
                        @"language":[Utils preferredLanguage],
		};
		[manager POST:[NETWORK_HOST addString:@"photo.php"] parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
		    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
		    [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
		} success: ^(AFHTTPRequestOperation *operation, id responseObject) {
		    NSMutableArray *array = [NSMutableArray arrayWithArray:self.activity.photos];
		    NSString *photourl = responseObject[@"resultContent"][@"url"];
		    [array addObject:photourl];
		    self.activity.photos = array;
		    [self.activity put];
		    NSMutableArray *uArray = [NSMutableArray arrayWithArray:self.mainUser.photos];
		    [uArray addObject:photourl];
		    self.mainUser.photos = uArray;
		    [self.mainUser put];
		    if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
		        [self.passedDelegate backPassViewController:self pass:@{ @"activity":self.activity }];
			}
		    [self reloadPhotoData];
		    [progressView dismiss:YES];
		} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
		    [progressView dismiss:YES];
		    [MRProgressOverlayView showNO:LOCALIZED(@"活動上傳失敗，請稍後重試！")];
		}];
	}
}

- (void)handleNavBarRight:(id)sender {
	[super handleNavBarRight:sender];
	if (self.contentTV.isEditable) { //完成编辑
		if ([self.contentTV.text isMeaningful]) {
			[self enableCompleteNavBarItem:NO];
			if (![self.activity.content isEqualToString:self.contentTV.text]) {
				MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在修改...")];
				AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
				[manager GET:[NETWORK_HOST addString:@"activity.php?action=edit"] parameters:
				 @{
				     @"id" : self.activity.id,
				     @"content" : self.contentTV.text,
                                 @"language":[Utils preferredLanguage],
				 }
				     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
				    [progressView dismiss:YES];
				    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
				        self.activity.content = self.contentTV.text;
				        if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
				            [self.passedDelegate backPassViewController:self pass:@{ @"activity":self.activity }];
						}
				        [MRProgressOverlayView showYES:LOCALIZED(@"活動修改成功！")];
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
		else {
			[MRProgressOverlayView showNO:LOCALIZED(@"請輸入活動內容！")];
		}
	}
	else {
		if (self.activity.isMain) {
			IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZED(@"取消") destructiveButtonTitle:nil otherButtonTitles:LOCALIZED(@"分享活動"), LOCALIZED(@"複製活動"), LOCALIZED(@"編輯活動"), LOCALIZED(@"取消活動"), nil];
			[standardIBAS showInView:[UIApplication window]];
		}
		else {
			IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZED(@"取消") destructiveButtonTitle:nil otherButtonTitles:LOCALIZED(@"分享活動"), LOCALIZED(@"複製活動"), nil];
			[standardIBAS showInView:[UIApplication window]];
		}
	}
}

- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (self.activity.isMain) {
		if (actionSheet.tag == 2000) {
			if (buttonIndex == 0) { //確定刪除活動
				MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在取消...")];
				AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
				[manager GET:[NETWORK_HOST addString:@"activity.php?action=remove"] parameters:
				 @{
				     @"id":self.activity.id,
                                 @"language":[Utils preferredLanguage],
				 }
				     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
				    [progressView dismiss:YES];
				    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
				        NSMutableArray *parUids = [NSMutableArray array];
				        [self.activity.participators enumerateObjectsUsingBlock: ^(ParticipatorEntity *obj, NSUInteger idx, BOOL *stop) {
				            if (![obj.uid isEqualToString:self.mainUser.id]) {
				                [parUids addObject:obj.uid];
							}
						}];

				        NSMutableArray *mutableOperations = [NSMutableArray array];
				        for (NSString * uid in parUids) {
				            AFHTTPRequestOperation *op = [manager GETOperation:[NETWORK_HOST addString:@"message_system.php?action=add"] parameters:
				                                          @{
				                                              @"type":MESSAGE_ACTIVITY_CANCEL_TYPE,
				                                              @"subject":self.mainUser.nickname,
				                                              @"content":Format(LOCALIZED(@"%@ 的活動取消：%@"), self.mainUser.nickname, self.titleLabel.text),
				                                              @"touser":uid,
				                                              @"fromuser":self.mainUser.id,
				                                              @"obj":self.activity.id,
                                                                          @"language":[Utils preferredLanguage],
														  }
				                                                       success: ^(AFHTTPRequestOperation *operation, id responseObject) {
				               
							} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
				               
							}];
				            [mutableOperations addObject:op];
						}

				        NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock: ^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
						} completionBlock: ^(NSArray *operations) {
				            NSLog(@"All operations in batch complete");
						}];
				        [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];

				        if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
				            [self.passedDelegate backPassViewController:self pass:@{ @"activity":self.activity, @"refreshMe":@(YES) }];
						}
				        [MRProgressOverlayView showYES:LOCALIZED(@"已經取消活動！")];
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
		}
		else {
			switch (buttonIndex) {
				case 0: //分享活動
					[self handleShare];
					break;

				case 1: //複製活動
				{
					BOOL isLogined = [[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_IS_LOGINED] boolValue];
					if (!isLogined) {
						[self performSegueWithIdentifier:[SignInViewController className] sender:nil];
					}
					else {
						[self performSegueWithIdentifier:[ActivityNewViewController className] sender:nil];
					}
				}
				break;

				case 2: //編輯活動
					[self enableCompleteNavBarItem:YES];
					break;

				case 3: //取消活動
				{
					IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:LOCALIZED(@"取消後將無法恢復") delegate:self cancelButtonTitle:LOCALIZED(@"取消") destructiveButtonTitle:LOCALIZED(@"確定取消") otherButtonTitles:nil, nil];
					standardIBAS.tag = 2000;
					[standardIBAS showInView:[UIApplication window]];
				}


				break;

				default:
					break;
			}
		}
	}


	else {
		switch (buttonIndex) {
			case 0:         //分享活動
				[self handleShare];

				break;

			case 1:         //複製活動
			{
				BOOL isLogined = [[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_IS_LOGINED] boolValue];
				if (!isLogined) {
					[self performSegueWithIdentifier:[SignInViewController className] sender:nil];
				}
				else {
					[self performSegueWithIdentifier:[ActivityNewViewController className] sender:nil];
				}
			}


			break;

			default:
				break;
		}
	}
}

- (void)handleShare {
    NSString *content = self.contentTV.text;
    if (content.length+self.titleLabel.text.length>140) {
        content = [content substringToIndex:139-self.titleLabel.text.length];
    }
    

    __block MRProgressOverlayView *progressView  = nil;
	id <ISSContent> publishContent = [ShareSDK  content:content
	                                     defaultContent:LOCALIZED(@"請輸入活動內容")
	                                              image:[ShareSDK jpegImageWithImage:self.coverImageView.image quality:1]
	                                              title:self.titleLabel.text
	                                                url:@"http://itunes.apple.com/hk/app/xjoin/id915800706?mt=8"
	                                        description:LOCALIZED(@"這是XJoin，一起參加活動吧！")
	                                          mediaType:SSPublishContentMediaTypeNews];

	[ShareSDK showShareActionSheet:nil
	                     shareList:nil
	                       content:publishContent
	                 statusBarTips:NO
	                   authOptions:nil
	                  shareOptions:nil
	                        result: ^(ShareType type, SSResponseState state, id < ISSPlatformShareInfo > statusInfo, id < ICMErrorInfo > error, BOOL end) {

                                if (state == SSResponseStateBegan) {
                                             [self.view endEditing:YES];
                                              progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在分享...")];
                                }
	    else if (state == SSResponseStateSuccess) {
            [progressView dismiss:YES];
	        [MRProgressOverlayView showYES:LOCALIZED(@"分享成功！")];
		}
	    else if (state == SSResponseStateFail) {
            [progressView dismiss:YES];
	        [MRProgressOverlayView showNO:LOCALIZED(@"分享失敗！")];
	        NSLog(@"Share Fail,Error code:%d,Error description:%@", (int)[error errorCode], [error errorDescription]);
		}
	}];
}

- (NSUInteger)numberOfItems:(CrossScrollView *)collectionView {
	if (collectionView == self.parScrollView) {
		return self.activity.participators.count;
	}
	else {
		return self.activity.photos.count + 1;
	}
}

- (CGFloat)crossScrollView:(CrossScrollView *)collectionView widthForItemAtIndex:(NSUInteger)index {
	return CGRectGetHeight(collectionView.bounds);
}

- (UIView *)crossScrollView:(CrossScrollView *)collectionView viewForItemAtIndex:(NSUInteger)index {
	if (collectionView == self.parScrollView) {
		CircleImageView *view = [[CircleImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
		ParticipatorEntity *par = [self.activity.participators objectAtIndex:index];
		[view setImageWithURL:[par.coverurl URL] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
		return view;
	}
	else { //圖片
		UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 70)];
		view.clipsToBounds = YES;
		view.contentMode = UIViewContentModeScaleAspectFill;
		view.layer.shadowColor = COLOR_MAIN_GRAY.CGColor;
		view.layer.shadowOffset = CGSizeMake(4, 3);
		view.layer.shadowOpacity = 0.3; //阴影透明度，默认0

		if (index == self.photoScrollView.count - 1) {
			[view setImage:[UIImage imageNamed:@"icon_cover_new"]];
		}
		else {
			[view setImageWithURL:[[self.activity.photos objectAtIndex:index] URL] placeholderImage:[UIImage imageNamed:@"icon_cover_default"]];
		}
		return view;
	}
}

- (void)crossScrollView:(CrossScrollView *)collectionView didSelectItemAtIndex:(NSUInteger)index {
	if (collectionView == self.parScrollView) {
		[self performSegueWithIdentifier:[UserDetailTableViewController className] sender:@(index)];
	}
	else {
		if (index == self.photoScrollView.count - 1) { //添加圖片
			if ([self.activity.userstate containString:USERSTATE_PARTICIPATOR]) {
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
				[MRProgressOverlayView showNO:LOCALIZED(@"請先參加活動後再上傳照片！")];
			}
		}
		else {
			XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
			imageViewer.delegate = self;
			NSMutableArray *imageViews = [NSMutableArray arrayWithArray:[self.photoScrollView allItemViews]];
			[imageViews removeLastObject];
			[imageViewer showWithImageViews:imageViews selectedView:(UIImageView *)[self.photoScrollView viewForItemAtIndex:index]];
		}
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:[UserDetailTableViewController className]]) {
		ParticipatorEntity *par = [self.activity.participators objectAtIndex:[sender integerValue]];
		UserDetailTableViewController *controller = segue.destinationViewController;
		controller.type = UserDetailTableViewControllerTypeQuickLook;
		controller.uid = par.uid;
	}
	else if ([segue.identifier isEqualToString:[MapViewController className]]) {
		MapViewController *controller = segue.destinationViewController;
		controller.type = MapViewControllerTypeQuickLook;
		controller.location = self.activity.locationEntity;
	}
	else if ([segue.identifier isEqualToString:[ActivityNewViewController className]]) {
		ActivityNewViewController *controller = (ActivityNewViewController *)[segue.destinationViewController topViewController];
		controller.activity = self.activity;
	}
}

- (IBAction)handleLove:(id)sender {
	BOOL isLogined = [[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_IS_LOGINED] boolValue];
	if (!isLogined) {
		[self performSegueWithIdentifier:[SignInViewController className] sender:sender];
	}
	else {
		if ([self.activity.userstate containString:USERSTATE_LIKER]) {
			MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在取消...")];
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			[manager GET:[NETWORK_HOST addString:@"user.php?action=remove_activity"] parameters:
			 @{
			     @"type":@"interested",
			     @"uid":self.mainUser.id,
			     @"aid":self.activity.id,
                             @"language":[Utils preferredLanguage],
			 }                  success: ^(AFHTTPRequestOperation *operation, id responseObject) {
			    [progressView dismiss:YES];
			    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
			        self.activity.userstate = [self.activity.userstate deleteString:USERSTATE_LIKER];
			        self.activity.userstate = [self.activity.userstate deleteString:Format(@";%@", USERSTATE_LIKER)];
			        [self.activity put];
			        [self prepareForBarView];
			        if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
			            [self.passedDelegate backPassViewController:self pass:@{ @"activity":self.activity, @"refreshMe":@(YES) }];
					}

			        [MRProgressOverlayView showYES:LOCALIZED(@"已經從喜歡的活動中移除！")];
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
			MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在贊...")];
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			[manager GET:[NETWORK_HOST addString:@"user.php?action=activity"] parameters:
			 @{
			     @"type":@"interested",
			     @"uid":self.mainUser.id,
			     @"aid":self.activity.id,
                             @"language":[Utils preferredLanguage],
			 }                  success: ^(AFHTTPRequestOperation *operation, id responseObject) {
			    [progressView dismiss:YES];
			    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
			        self.activity.userstate = [self.activity.userstate isMeaningful] ? [self.activity.userstate addFormat:@";%@", USERSTATE_LIKER] : [self.activity.userstate addString:USERSTATE_LIKER];
			        [self.activity put];
			        [self prepareForBarView];
			        if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
			            [self.passedDelegate backPassViewController:self pass:@{ @"activity":self.activity, @"refreshMe":@(YES) }];
					}
			        [MRProgressOverlayView showYES:LOCALIZED(@"已經添加到你的喜歡的活動中！")];
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

- (IBAction)handleJoin:(id)sender {
	BOOL isLogined = [[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_IS_LOGINED] boolValue];
	if (!isLogined) {
		[self performSegueWithIdentifier:[SignInViewController className] sender:sender];
	}
	else {
		if ([self.activity.userstate containString:USERSTATE_PARTICIPATOR]) {
			MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在取消...")];
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			[manager GET:[NETWORK_HOST addString:@"user.php?action=remove_activity"] parameters:
			 @{
			     @"type":@"join",
			     @"uid":self.mainUser.id,
			     @"aid":self.activity.id,
                             @"language":[Utils preferredLanguage],
			 }
			     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
			    [progressView dismiss:YES];
			    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
			        [Utils removeEvent:self.activity];

			        NSArray *filterArray = [self.activity.participators filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.uid != %@", self.mainUser.id]];
			        self.activity.participators = filterArray;

			        self.activity.userstate = [self.activity.userstate deleteString:USERSTATE_PARTICIPATOR];
			        self.activity.userstate = [self.activity.userstate deleteString:Format(@";%@", USERSTATE_PARTICIPATOR)];

			        [self.activity put];
			        [self prepareForBarView];
			        [self.parScrollView reloadData];
			        if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
			            [self.passedDelegate backPassViewController:self pass:@{ @"activity":self.activity, @"refreshMe":@(YES) }];
					}

			        [MRProgressOverlayView showYES:LOCALIZED(@"已經從參加的活動中移除！")];
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
			MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在參加...")];
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			[manager GET:[NETWORK_HOST addString:@"user.php?action=activity"] parameters:
			 @{
			     @"type":@"join",
			     @"uid":self.mainUser.id,
			     @"aid":self.activity.id,
                             @"language":[Utils preferredLanguage],
			 }
			     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
			    [progressView dismiss:YES];
			    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
			        [Utils saveEvent:self.activity];

			        ParticipatorEntity *par = [[ParticipatorEntity alloc] init];
			        par.uid = self.mainUser.id;
			        par.nickname = self.mainUser.nickname;
			        par.coverurl = self.mainUser.coverurl;
			        NSMutableArray *array = [NSMutableArray arrayWithArray:self.activity.participators];
			        [array addObject:par];
			        self.activity.participators = array;
			        self.activity.userstate = [self.activity.userstate isMeaningful] ? [self.activity.userstate addFormat:@";%@", USERSTATE_PARTICIPATOR] : [self.activity.userstate addString:USERSTATE_PARTICIPATOR];
			        [self.activity put];
			        [self prepareForBarView];
			        [self.parScrollView reloadData];
			        if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
			            [self.passedDelegate backPassViewController:self pass:@{ @"activity" : self.activity, @"refreshMe":@(YES) }];
					}

			        [MRProgressOverlayView showYES:LOCALIZED(@"已經添加到你的參加的活動中！")];
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

- (void)enableCompleteNavBarItem:(BOOL)isEnable {
	self.contentTV.backgroundColor = isEnable ? COLOR_MAIN_GRAY_MID : [UIColor clearColor];
	self.contentTV.editable = isEnable;
	if (isEnable) {
		self.navigationItem.rightBarButtonItem.image = nil;
		self.navigationItem.rightBarButtonItem.title = LOCALIZED(@"完成");

		[self.contentTV becomeFirstResponder];
	}
	else {
		self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"icon_nav_more"];
		self.navigationItem.rightBarButtonItem.title = nil;
		[self.contentTV resignFirstResponder];
	}
}

@end
