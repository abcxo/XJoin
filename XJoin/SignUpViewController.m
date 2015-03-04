//
//  SignUpViewController.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "SignUpViewController.h"
#import "XJoin.h"
@interface SignUpViewController () <CustomImagePickerControllerDelegate, UIGestureRecognizerDelegate> {
	BOOL _isNeedUploadAvatar;
}

@end

@implementation SignUpViewController

- (void)prepareForView {
	[super prepareForView];
	[self.genderSeg setFrame:self.genderSeg.frame items:
	 @[
	     @{ @"text":LOCALIZED(@"男"), @"icon":@"" },
	     @{ @"text":LOCALIZED(@"女"), @"icon":@"" },

	 ]

	            iconPosition:IconPositionRight andSelectionBlock: ^(NSUInteger segmentIndex) {
	    NSLog(@"ff");
	} iconSeparation:0.5];
	self.genderSeg.color = COLOR_MAIN_GRAY_LIGHT;
	self.genderSeg.selectedColor = COLOR_MAIN_RED;
	self.genderSeg.textAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],
		                               NSForegroundColorAttributeName:COLOR_MAIN_RED };
	self.genderSeg.selectedTextAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],
		                                       NSForegroundColorAttributeName:COLOR_MAIN_GRAY_LIGHT };
}

- (IBAction)handleChooseAvatar:(id)sender {
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
	_isNeedUploadAvatar = YES;
	self.avatarImageView.image = image;
}

- (IBAction)handleRegister:(id)sender {
	if ([self.nickNameTF.text isMeaningful] && [self.userNameTF.text isMeaningful] && [self.passwordTF.text isMeaningful] && [self.phoneTF.text isMeaningful]) {
		if ([self.nickNameTF.text isConformNickNameFormat]) {
			if ([self.userNameTF.text isConformEmailAddressFormat]) {
				if ([self.passwordTF.text isConformPasswordFormat]) {
					if ([self.phoneTF.text isConformPhoneNumberFormat]) {
						MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在註冊...")];
						AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
						[manager GET:[NETWORK_HOST addString:@"user.php?action=reg"] parameters:
						 @{
						     @"gender":@(1 + self.genderSeg.currentSelected),
						     @"nickname":self.nickNameTF.text,
						     @"username":self.userNameTF.text,
						     @"password":self.passwordTF.text,
						     @"from":self.regionBtn.titleLabel.text,
						     @"phone":[[self.codeLabel.text deleteString:@"+"] addString:self.phoneTF.text],
                                         @"language":[Utils preferredLanguage],
						 }
						     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
						    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
						        UserEntity *user = [UserEntity toObject:[responseObject objectForKey:@"resultContent"]];
						        [user put];
						        [[StorageDefaults userDefaults] setObject:user.id forKey:USER_DEFAULT_MAIN_UID];
						        [[StorageDefaults userDefaults] setObject:@(YES) forKey:USER_DEFAULT_IS_LOGINED];
						        if (_isNeedUploadAvatar) {
						            NSData *imageData = UIImageJPEGRepresentation(self.avatarImageView.image, 0.5);
						            [FileManager saveFile:imageData filePath:[[FileManager documentsPath] stringByAppendingPathComponent:@"avatar.jpg"]];
						            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
						            NSDictionary *parameters = @{
						                @"action": @"add",
						                @"type": @"user",
						                @"obj_id": user.id,
                                                    @"language":[Utils preferredLanguage],
									};
						            [manager POST:[NETWORK_HOST addString:@"photo.php"] parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
						                [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
									} success: ^(AFHTTPRequestOperation *operation, id responseObject) {
						                user.coverurl = responseObject[@"resultContent"][@"url"];
						                [user put];
						                [self handleDismiss:progressView user:user];
									} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
						                [self handleDismiss:progressView user:user];
						                [MRProgressOverlayView showNO:LOCALIZED(@"頭像上傳失敗，請到個人信息重新設置！")];
									}];
								}
						        else {
						            [self handleDismiss:progressView user:user];
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
						[MRProgressOverlayView showNO:LOCALIZED(@"請輸入有效手機號碼！")];
					}
				}
				else {
					[MRProgressOverlayView showNO:LOCALIZED(@"請輸入6-16位有效密碼！")];
				}
			}
			else {
				[MRProgressOverlayView showNO:LOCALIZED(@"請输入有效電郵地址！")];
			}
		}
		else {
			[MRProgressOverlayView showNO:LOCALIZED(@"請輸入不超過12位有效暱稱！")];
		}
	}
	else {
		[MRProgressOverlayView showNO:LOCALIZED(@"請填寫完整註冊信息！")];
	}
}

- (void)backPassViewController:(UIViewController *)viewController pass:(id)userInfo {
	[self.regionBtn setText:userInfo[@"region"]];
	self.codeLabel.text = userInfo[@"code"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:[RegionTableViewController className]]) {
		((RegionTableViewController *)((UINavigationController *)segue.destinationViewController).topViewController).passedDelegate = self;
	}
}

- (void)handleDismiss:(MRProgressOverlayView *)progressView user:(UserEntity *)user {
	[progressView dismiss:YES];
	[[NotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINED object:nil userInfo:@{ [UserEntity className]:user }];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)handleScrollViewTap:(UITapGestureRecognizer *)sender {
	[sender.view endEditing:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
		CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
		if (CGRectContainsPoint(self.genderSeg.frame, point)) {
			return NO;
		}
	}
	return YES;
}

@end
