//
//  ActivityNewViewController.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "ActivityNewViewController.h"
#import "XJoin.h"
@interface ActivityNewViewController () <UITextFieldDelegate, CustomImagePickerControllerDelegate, IBActionSheetDelegate, UIGestureRecognizerDelegate> {
	BOOL _isSetedCover;
}
@property (nonatomic, strong) UserEntity *mainUser;
@end

@implementation ActivityNewViewController
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
    self.locationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.locationBtn.titleLabel.numberOfLines=2;
	self.datePicker.backgroundColor = COLOR_MAIN_GRAY_MID;
	[self enablePick:NO time:0];

	[self prepareForUserView];
}

- (void)prepareForUserView {
	if ([self.activity isMeaningful]) {
		[self.coverImageView setImageWithURL:[self.activity.activitycover URL]  placeholderImage:[UIImage imageNamed:@"icon_cover_default"]];
		self.titleTF.text = self.activity.subject;
		self.timeBtn.text = self.activity.beginDateString;
		self.timeEndBtn.text = self.activity.endDateString;
		self.locationBtn.text = self.activity.locationEntity.title;
		self.typeTF.text = self.activity.type;
		self.creatorLabel.text = self.mainUser.nickname;
		self.contentTV.text = self.activity.content;
		self.activity.participators = [self.activity.participators filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.uid != %@", self.mainUser.id]];
		_isSetedCover = YES;
		[self reloadParData];
	}
	else {
		self.activity = [[ActivityEntity alloc] init];
		NSDate *now = [NSDate date];
		self.activity.begin_date = [now timeIntervalSince1970];
		self.activity.end_date = self.activity.begin_date;
		self.activity.creator = self.mainUser.id;
		self.timeBtn.text = self.activity.beginDateString;
		self.timeEndBtn.text = self.activity.endDateString;
		self.creatorLabel.text = self.mainUser.nickname;
	}
}

- (void)reloadParData {
	self.parCountLabel.text = Format(LOCALIZED(@"活動參與者(%d)"), (int)self.activity.participators.count);
	[self.parScrollView reloadData];
}

- (NSUInteger)numberOfItems:(CrossScrollView *)collectionView {
	return self.activity.participators.count + 1;
}

- (CGFloat)crossScrollView:(CrossScrollView *)collectionView widthForItemAtIndex:(NSUInteger)index {
	return CGRectGetHeight(collectionView.bounds);
}

- (UIView *)crossScrollView:(CrossScrollView *)collectionView viewForItemAtIndex:(NSUInteger)index {
	CircleImageView *view = [[CircleImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
	if (index == self.parScrollView.count - 1) {
		[view setImage:[UIImage imageNamed:@"icon_cover_new"]];
	}
	else {
		ParticipatorEntity *par = [self.activity.participators objectAtIndex:index];

		[view setImageWithURL:[par.coverurl URL] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
	}

	return view;
}

- (void)crossScrollView:(CrossScrollView *)collectionView didSelectItemAtIndex:(NSUInteger)index {
	if (index == self.parScrollView.count - 1) {
		[self performSegueWithIdentifier:[FriendTableViewController className] sender:@(index)];
	}
	else {
		IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZED(@"取消") destructiveButtonTitle:LOCALIZED(@"取消邀請") otherButtonTitles:nil, nil];
		[standardIBAS showInView:[UIApplication window]];
	}
}

- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {     //退出登錄
		NSMutableArray *array = [NSMutableArray arrayWithArray:self.activity.participators];
		[array removeObjectAtIndex:self.parScrollView.indexForSelectedItem];
		self.activity.participators = array;
		[self reloadParData];
	}
}

- (IBAction)handleChooseTime:(id)sender {
	self.timeBtn.selected = YES;
	self.timeEndBtn.selected = NO;
	[self enablePick:YES time:self.activity.begin_date];
}

- (IBAction)handleChooseTimeEnd:(id)sender {
	self.timeBtn.selected = NO;
	self.timeEndBtn.selected = YES;
	[self enablePick:YES time:self.activity.end_date];
}

- (IBAction)handleChooseLocation:(id)sender {
}

- (IBAction)handleChooseCover:(id)sender {
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
	picker.navigationBar.titleTextAttributes = @{ UITextAttributeTextColor:[UIColor whiteColor] };
	[self presentModalViewController:picker animated:YES];
}

- (void)pickedPhoto:(UIImage *)image {
	_isSetedCover = YES;
	self.coverImageView.image = image;
}

- (IBAction)handlePickTime:(UIDatePicker *)sender {
	if (self.timeBtn.isSelected) {
		self.activity.begin_date = [sender.date timeIntervalSince1970];
		self.timeBtn.text = self.activity.beginDateString;
	}
	else if (self.timeEndBtn.isSelected) {
		self.activity.end_date = [sender.date timeIntervalSince1970];
		self.timeEndBtn.text = self.activity.endDateString;
	}
}

- (BOOL)isConformTitleFormat:(NSString *)text {
	if ([text isMeaningful]) {
		return text.length <= 30;
	}
	return NO;
}

- (BOOL)isConformTypeFormat:(NSString *)text {
	if ([text isMeaningful]) {
		return text.length <= 12;
	}
	return NO;
}

- (IBAction)handleCreate:(id)sender {
	[self.scrollView endEditing:YES];
	if ([self.titleTF.text isMeaningful] && [self.typeTF.text isMeaningful] && [self.contentTV.text isMeaningful]) {
		if ([self isConformTitleFormat:self.titleTF.text]) {
			if (self.typeTF) {
				double now = [[NSDate date] timeIntervalSince1970];
				if (self.activity.begin_date < self.activity.end_date && self.activity.end_date > now) {
					if (_isSetedCover) {
						if ([self.activity.locationEntity isMeaningful]) {
							MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在創建...")];
							AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
							NSMutableArray *parUids = [NSMutableArray arrayWithObject:self.mainUser.id];
							[parUids addObjectsFromArray:[self.activity.participators arrayWithBlock: ^id (ParticipatorEntity *obj, NSInteger index) {
							    return obj.uid;
							}]];

							self.activity.subject = self.titleTF.text;
							self.activity.type = self.typeTF.text;
							self.activity.content = self.contentTV.text;

							NSString *parUidsStr = [parUids componentsJoinedByString:@","];

							[manager GET:[NETWORK_HOST addString:@"activity.php?action=add"] parameters:
							 @{
							     @"subject":self.titleTF.text,
							     @"creator":self.mainUser.id,
							     @"begin_date":@(self.activity.begin_date),
							     @"end_date":@(self.activity.end_date),
							     @"location":[self.activity.locationEntity locationEntityString],
							     @"type":self.typeTF.text,
							     @"content":self.contentTV.text,
							     @"participators":parUidsStr,
                                             @"language":[Utils preferredLanguage],
							 }                                  success: ^(AFHTTPRequestOperation *operation, id responseObject) {
							    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
							        NSString *aid = responseObject[@"resultContent"][@"id"];
							        if ([aid isMeaningful]) {
							            [Utils saveEvent:self.activity];

							            //發送消息
							            [parUids removeFirstObject];

							            NSMutableArray *mutableOperations = [NSMutableArray array];
							            for (NSString * uid in parUids) {
							                AFHTTPRequestOperation *op = [manager GETOperation:[NETWORK_HOST addString:@"message_system.php?action=add"] parameters:
							                                              @{
							                                                  @"type":MESSAGE_ACTIVITY_INVITE_TYPE,
							                                                  @"subject":self.mainUser.nickname,
							                                                  @"content":Format(LOCALIZED(@"%@ 的活動邀請：%@"), self.mainUser.nickname, self.titleTF.text),
							                                                  @"touser":uid,
							                                                  @"fromuser":self.mainUser.id,
							                                                  @"obj":aid,
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

							            //上傳圖片
							            NSDictionary *parameters = @{
							                @"action": @"add",
							                @"type": @"activitycover",
							                @"obj_id": aid,
                                                        @"language":[Utils preferredLanguage],
										};
							            [manager POST:[NETWORK_HOST addString:@"photo.php"] parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
							                NSData *imageData = UIImageJPEGRepresentation(self.coverImageView.image, 0.5);
							                [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
										} success: ^(AFHTTPRequestOperation *operation, id responseObject) {
							                if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
							                    [self.passedDelegate backPassViewController:self pass:@{  @"refreshMe":@(YES) }];
											}

							                [progressView dismiss:YES];
							                [MRProgressOverlayView showYES:LOCALIZED(@"活動創建成功！")];

							                [self.navigationController dismissModalViewControllerAnimated:YES];
										} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
							                if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
							                    [self.passedDelegate backPassViewController:self pass:@{ @"refreshMe":@(YES) }];
											}
							                [progressView dismiss:YES];
							                [MRProgressOverlayView showNO:LOCALIZED(@"封面圖片上傳失敗！")];
							                [self.navigationController dismissModalViewControllerAnimated:YES];
										}];
									}
							        else {
							            [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
									}
								}
							    else {
							        [progressView dismiss:YES];
							        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
								}
							} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
							    [progressView dismiss:YES];
							    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
							}];
						}
						else {
							[MRProgressOverlayView showNO:LOCALIZED(@"請選擇活動地點！")];
						}
					}
					else {
						[MRProgressOverlayView showNO:LOCALIZED(@"請選擇活動封面照片！")];
					}
				}
				else {
					[MRProgressOverlayView showNO:LOCALIZED(@"活動結束時間必須晚於開始時間且晚於現在時間！")];
				}
			}
			else {
				[MRProgressOverlayView showNO:LOCALIZED(@"請輸入不超過12位有效活動類型！")];
			}
		}
		else {
			[MRProgressOverlayView showNO:LOCALIZED(@"請輸入不超過30位有效活動主題！")];
		}
	}
	else {
		[MRProgressOverlayView showNO:LOCALIZED(@"請輸入完整活動信息！")];
	}
}

- (void)enablePick:(BOOL)isEnable time:(double)time {
	[self.scrollView endEditing:YES];
	if (time > 0) {
		[self.datePicker setDate:[NSDate dateWithTimeIntervalSince1970:time] animated:YES];
	}
	else {
		[self.datePicker setDate:[NSDate date] animated:YES];
	}

	CGFloat offsetY = isEnable ? 0 : CGRectGetHeight(self.datePicker.frame);
	[UIView animateWithDuration:0.3 animations: ^{
	    self.datePicker.transform = CGAffineTransformMakeTranslation(0, offsetY);
	}];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self enablePick:NO time:0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)handleScrollViewTap:(UITapGestureRecognizer *)sender {
	[sender.view endEditing:YES];
	[self enablePick:NO time:0];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
		CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
		if (CGRectContainsPoint(self.parScrollView.frame, point)) {
			return NO;
		}
	}
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:[FriendTableViewController className]]) {
		FriendTableViewController *controller = (FriendTableViewController *)[segue.destinationViewController topViewController];
		controller.passedDelegate = self;
	}
	else if ([segue.identifier isEqualToString:[MapViewController className]]) {
		MapViewController *controller = (MapViewController *)[segue.destinationViewController topViewController];
		controller.type = MapViewControllerTypeEdit;
		controller.passedDelegate = self;
	}
}

- (void)backPassViewController:(UIViewController *)viewController pass:(id)userInfo {
	if ([viewController isKindOfClass:[FriendTableViewController class]]) {
		UserEntity *user = userInfo[@"user"];
		ParticipatorEntity *par = [[ParticipatorEntity alloc] init];
		par.uid = user.id;
		par.nickname = user.nickname;
		par.coverurl = user.coverurl;
		NSMutableArray *array = [NSMutableArray arrayWithArray:self.activity.participators];
		NSArray *filterArray = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.uid == %@", user.id]];
		if (![filterArray isMeaningful]) {
			[array addObject:par];
			self.activity.participators = array;
			[self reloadParData];
		}
	}
	else if ([viewController isKindOfClass:[MapViewController class]]) {
		self.activity.locationEntity = userInfo[@"location"];
		self.locationBtn.text = self.activity.locationEntity.title;
	}
}

@end
