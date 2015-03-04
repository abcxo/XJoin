//
//  SignInViewController.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "SignInViewController.h"
#import "XJoin.h"
@interface SignInViewController () <UITextFieldDelegate> {
	BOOL _isFBLogin;
	UserEntity *_user;
}

@end

@implementation SignInViewController
- (IBAction)handleForgetPassword:(id)sender {
	if ([self.userNameTF.text isMeaningful]) {
		MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在發送郵件...")];
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		[manager GET:[NETWORK_HOST addString:@"get_password.php?"] parameters:
		 @{
		     @"username":self.userNameTF.text,
                         @"language":[Utils preferredLanguage],
		 }
		     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
		    [progressView dismiss:YES];
		    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
		        [MRProgressOverlayView showYES:LOCALIZED(@"郵件已經發送到您的郵箱！")];
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
		[MRProgressOverlayView showNO:LOCALIZED(@"請輸入你的電郵，以方便我們通知您！")];
	}
}

- (IBAction)handleLogin:(id)sender {
	[self.userNameTF resignFirstResponder];
	[self.passwordTF resignFirstResponder];
	if ([self.userNameTF.text isMeaningful] && [self.passwordTF.text isMeaningful]) {
		if ([self.userNameTF.text isConformEmailAddressFormat]) {
			if ([self.passwordTF.text isConformPasswordFormat]) {
				MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在登錄...")];
				AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
				[manager GET:[NETWORK_HOST addString:@"login.php?"] parameters:@{ @"username":self.userNameTF.text, @"password":self.passwordTF.text,            @"language":[Utils preferredLanguage], } success: ^(AFHTTPRequestOperation *operation, id responseObject) {
				    [progressView dismiss:YES];
				    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
				        UserEntity *user = [UserEntity toObject:[responseObject objectForKey:@"resultContent"]];
				        [user put];
				        [[StorageDefaults userDefaults] setObject:user.id forKey:USER_DEFAULT_MAIN_UID];
				        [[StorageDefaults userDefaults] setObject:@(YES) forKey:USER_DEFAULT_IS_LOGINED];
				        [[NotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINED object:nil userInfo:@{ [UserEntity className]:user }];
				        [self.navigationController dismissModalViewControllerAnimated:YES];
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
				[MRProgressOverlayView showNO:LOCALIZED(@"請輸入6-16位有效密碼！")];
			}
		}
		else {
			[MRProgressOverlayView showNO:LOCALIZED(@"請输入有效電郵地址！")];
		}
	}
	else {
		[MRProgressOverlayView showNO:LOCALIZED(@"請輸入電郵和密碼！")];
	}
}

- (IBAction)handleFBLogin:(id)sender {
	[ShareSDK authWithType:ShareTypeFacebook                                              //需要授权的平台类型
	               options:nil                                          //授权选项，包括视图定制，自动授权
	                result: ^(SSAuthState state, id < ICMErrorInfo > error) {   //授权返回后的回调方法
	    id <ISSPlatformCredential> cred = [ShareSDK getCredentialWithType:ShareTypeFacebook];
	    if ([[cred token] isMeaningful]) {
	        MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在登錄...")];
	        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	        [manager GET:[NETWORK_HOST addString:@"login_facebook.php?"] parameters:
	         @{
	             @"token":[cred token],
	             @"expires":@([[cred expired] timeIntervalSince1970]),
	             @"agent":@"facebook",
	             @"appId":@"667148623381434",
	             @"secret":@"f9937d55dc7ba24841702755305e9035",
                             @"language":[Utils preferredLanguage],
			 }
	             success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	            [progressView dismiss:YES];
	            if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	                _user = [UserEntity toObject:[responseObject objectForKey:@"resultContent"]];
	                self.FBuserNameTF.text = _user.username;
	                self.FBpasswordTF.text = _user.password;
	                if (_user.password.length > 6) { //代表已经登录过
	                    [_user put];
	                    [[StorageDefaults userDefaults] setObject:_user.id forKey:USER_DEFAULT_MAIN_UID];
	                    [[StorageDefaults userDefaults] setObject:@(YES) forKey:USER_DEFAULT_IS_LOGINED];
	                    [[NotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINED object:nil userInfo:@{ [UserEntity className]:_user }];
	                    [self.navigationController dismissModalViewControllerAnimated:YES];
					}
	                else {
	                    [self enableFBLogin:YES];
					}
				}
	            else {
	                [self cancelFBLogin];
	                [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
				}
			} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	            [self cancelFBLogin];
	            [progressView dismiss:YES];
	            [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
			}];
		}
	    else {
	        [MRProgressOverlayView showNO:LOCALIZED(@"授權登錄失敗！")];
		}
	}];
}

- (void)cancelFBLogin {
	self.FBuserNameTF.text = nil;
	self.FBpasswordTF.text = nil;
	[ShareSDK cancelAuthWithType:ShareTypeFacebook];
	[_user del];
	_user = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.userNameTF) {
		[self.passwordTF becomeFirstResponder];
	}
	else if (textField == self.passwordTF) {
		[self handleLogin:self.loginBtn];
	}
	else if (textField == self.FBuserNameTF) {
		[self.FBpasswordTF becomeFirstResponder];
	}
	else if (textField == self.FBpasswordTF) {
		[self handleEdit:self.editBtn];
	}

	return YES;
}

- (void)enableFBLogin:(BOOL)isEnable {
	_isFBLogin = isEnable;
	self.containerView.layer.cornerRadius = 3;
	self.containerView.transform = CGAffineTransformMakeScale(!isEnable, !isEnable);
	[UIView animateWithDuration:0.3 animations: ^{
	    self.bgView.alpha = isEnable;
	    self.containerView.transform = CGAffineTransformMakeScale(isEnable, isEnable);
	}];
}

- (IBAction)handleEdit:(id)sender {
	[self.FBuserNameTF resignFirstResponder];
	[self.FBpasswordTF resignFirstResponder];
	if ([self.FBuserNameTF.text isMeaningful] && [self.FBpasswordTF.text isMeaningful]) {
		if ([self.FBuserNameTF.text isConformEmailAddressFormat]) {
			if ([self.FBpasswordTF.text isConformPasswordFormat]) {
				MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在登錄...")];
				AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
				[manager GET:[NETWORK_HOST addString:@"user.php?action=edit"] parameters:
				 @{
				     @"id":_user.id,
				     @"password":self.FBpasswordTF.text,
                                 @"language":[Utils preferredLanguage],
				 }
				     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
				    [progressView dismiss:YES];
				    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
				        UserEntity *user = [UserEntity toObject:[responseObject objectForKey:@"resultContent"]];
				        [user put];
				        [[StorageDefaults userDefaults] setObject:user.id forKey:USER_DEFAULT_MAIN_UID];
				        [[StorageDefaults userDefaults] setObject:@(YES) forKey:USER_DEFAULT_IS_LOGINED];
				        [[NotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINED object:nil userInfo:@{ [UserEntity className]:user }];
				        [self.navigationController dismissModalViewControllerAnimated:YES];
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
				[MRProgressOverlayView showNO:LOCALIZED(@"請輸入6-16位有效密碼！")];
			}
		}
		else {
			[MRProgressOverlayView showNO:LOCALIZED(@"請输入有效電郵地址！")];
		}
	}
	else {
		[MRProgressOverlayView showNO:LOCALIZED(@"請輸入電郵和密碼！")];
	}
}

- (IBAction)handleBack:(id)sender {
	[self cancelFBLogin];
	[self enableFBLogin:NO];
}

@end
