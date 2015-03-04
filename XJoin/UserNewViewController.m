//
//  UserNewViewController.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UserNewViewController.h"
#import "XJoin.h"
@interface UserNewViewController () <ZBarReaderDelegate, UITextFieldDelegate> {
}
@property (nonatomic, strong) UserEntity *mainUser;
@end

@implementation UserNewViewController
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

- (IBAction)handleAdd:(id)sender {
	[self.nameTF resignFirstResponder];
	if ([self.nameTF.text isMeaningful]) {
		[self handleAddFriend:self.nameTF.text];
	}
	else {
		[MRProgressOverlayView showYES:LOCALIZED(@"請輸入好友的電郵！")];
	}
}

- (IBAction)handleQRCoder:(id)sender {
	/*掃描二維碼部分：
	   导入ZBarSDK文件并引入一下框架
	   AVFoundation.framework
	   CoreMedia.framework
	   CoreVideo.framework
	   QuartzCore.framework
	   libiconv.dylib
	   引入头文件#import “ZBarSDK.h” 即可使用
	   当找到条形码时，会执行代理方法

	   - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info

	   最后读取并显示了条形码的图片和内容。*/

	ZBarReaderViewController *reader = [ZBarReaderViewController new];
	reader.readerDelegate = self;
	reader.supportedOrientationsMask = ZBarOrientationMaskAll;

	ZBarImageScanner *scanner = reader.scanner;

	[scanner setSymbology:ZBAR_I25
	               config:ZBAR_CFG_ENABLE
	                   to:0];
	[self presentModalViewController:reader
	                        animated:YES];
}

- (void)handleAddFriend:(NSString *)text {
	if ([text isMeaningful]) {
		MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在添加...")];
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		[manager GET:[NETWORK_HOST addString:@"message_system.php?action=add"] parameters:
		 @{
		     @"type":@"make_friends",
		     @"subject":self.mainUser.nickname,
		     @"content":LOCALIZED(@"申請添加為好友"),
		     @"tousername":[text trimAll],
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
	else {
		[MRProgressOverlayView showNO:LOCALIZED(@"添加失敗！")];
	}
}

- (void)    imagePickerController:(UIImagePickerController *)reader
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
	id <NSFastEnumeration> results =
	    [info objectForKey:ZBarReaderControllerResults];
	ZBarSymbol *symbol = nil;
	for (symbol in results)
		break;
	[reader dismissModalViewControllerAnimated:YES];
	[self handleAddFriend:symbol.data];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self handleAdd:nil];
	return YES;
}

@end
