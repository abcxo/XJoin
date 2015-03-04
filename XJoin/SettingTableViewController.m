//
//  SettingTableViewController.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "SettingTableViewController.h"
#import "XJoin.h"
@interface SettingTableViewController () {
	BOOL _isLoginPoped;
}

@end

@implementation SettingTableViewController
- (void)prepareForData {
	[super prepareForData];
	[[NotificationCenter defaultCenter] addObserver:self selector:@selector(notificatiedLogined:) name:NOTIFICATION_LOGINED object:nil];
	[[NotificationCenter defaultCenter] addObserver:self selector:@selector(notificatiedLogouted:) name:NOTIFICATION_LOGOUTED object:nil];
}

- (void)notificatiedLogined:(NSNotification *)ns {
	[(UITabBarController *)[UIApplication window].rootViewController setSelectedIndex : 0];
}

- (void)notificatiedLogouted:(NSNotification *)ns {
	_isLoginPoped = NO;
	self.avatarImageView.image = [UIImage imageNamed:@"icon_avatar_default"];
	self.nickNameLabel.text = nil;
	self.userNameLabel.text = nil;
}

- (void)dealloc {
	[[NotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForView {
	[super prepareForView];
	if (IS_LONG_SCREEN) {
		self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
	}

	[self.notificationSwitch addTarget:self action:@selector(handleSwitchNotification:) forControlEvents:UIControlEventValueChanged];
	self.notificationSwitch.onTintColor = COLOR_MAIN_RED;
	self.notificationSwitch.tintColor = COLOR_MAIN_GRAY_LIGHT;
	self.notificationSwitch.on = [[[StorageDefaults appDefaults] objectForKey:APP_DEFAULT_IS_NEED_NOTIFICATION] boolValue];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	BOOL isLogined = [[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_IS_LOGINED] boolValue];
	if (isLogined) {
		[self prepareUserView];
	}
	else if (_isLoginPoped && !isLogined) {
		_isLoginPoped = NO;
		[(UITabBarController *)[UIApplication window].rootViewController setSelectedIndex : 0];
	}
	else {
		_isLoginPoped = YES;
		[self performSegueWithIdentifier:[SignInViewController className] sender:nil];
	}
}

- (void)prepareUserView {
	UserEntity *user = [UserEntity mainUser];
	[self.avatarImageView setImageWithURL:[user avatarURL] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
	self.nickNameLabel.text = user.nickname;
	self.userNameLabel.text = user.username;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[self.notificationSwitch setOn:!self.notificationSwitch.isOn animated:YES];
		[self.notificationSwitch sendActionsForControlEvents:UIControlEventValueChanged];
	}
	else if (indexPath.section == 3) {
		NSString *str = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=915800706";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (IBAction)handleSwitchNotification:(UISwitch *)sender {
	[[StorageDefaults appDefaults] setObject:@(sender.isOn) forKey:APP_DEFAULT_IS_NEED_NOTIFICATION];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:[UserDetailTableViewController className]]) {
		((UserDetailTableViewController *)segue.destinationViewController).type = UserDetailTableViewControllerTypeEdit;
		((UserDetailTableViewController *)segue.destinationViewController).user = [UserEntity mainUser];
	}
}

//#ifndef __IPHONE_7_0

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"   ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

//#endif

@end
