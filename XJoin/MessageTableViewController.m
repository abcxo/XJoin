//
//  MessageTableViewController.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "MessageTableViewController.h"
#import "XJoin.h"
@interface MessageTableViewController () <IBActionSheetDelegate>

@end

@implementation MessageTableViewController

- (void)prepareForData {
	[super prepareForData];
	self.dataSource = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self prepareForUserView];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController.tabBarItem setBadgeValue:nil];
    	[[StorageDefaults appDefaults] removeObjectForKey:APP_DEFAULT_NOTIFICATION_MESSAGE_COUNT];
}

- (void)prepareForUserView {
	BOOL isLogined = [[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_IS_LOGINED] boolValue];
	self.loginBtn.hidden = isLogined;
	if (isLogined) {
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		[self handleListMessage];
	}
	else {
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		if (!self.loginBtn.superview) {
			[self.loginBtn setFrameX:10];
			[self.loginBtn setFrameY:IS_LONG_SCREEN ? 205:160];
			[self.tableView addSubview:self.loginBtn];
		}
		[self.tableView bringSubviewToFront:self.loginBtn];
		[self.dataSource removeAllObjects];
		[self.tableView reloadData];
	}
}

- (void)prepareForView {
	[super prepareForView];
	[self prepareForUserView];
}

- (void)handleListMessage {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:[NETWORK_HOST addString:@"user.php?action=get_message_list"]  parameters:
	 @{
	     @"uid" : [UserEntity mainUser].id,
	     @"page":@(1),
	     @"pagesize":@(1000),
                     @"language":[Utils preferredLanguage],
	 }
	     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	        NSArray *messages = [MessageEntity toObjects:responseObject[@"resultContent"][@"content"]];
	        [self.dataSource removeAllObjects];
	        [self.dataSource addObjectsFromArray:messages];
	        [self.tableView reloadData];
		}
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MessageTableViewCell className] forIndexPath:indexPath];
	MessageEntity *message = [self.dataSource objectAtIndex:indexPath.row];
	cell.titleLabel.text = message.subject;
	cell.contentLabel.text = message.content;
	if ([message.type isEqualToString:MESSAGE_ACTIVITY_INVITE_TYPE]) { //活动邀请
		cell.contentLabel.textColor = COLOR_MAIN_BLUE;
	}
	else if ([message.type isEqualToString:MESSAGE_ACTIVITY_CANCEL_TYPE]) {  //活动取消
		cell.contentLabel.textColor = COLOR_MAIN_RED_DARK;
	}
	else if ([message.type isEqualToString:MESSAGE_FRIEND_HELLO_TYPE]) {  //活动取消
		cell.contentLabel.textColor = COLOR_MAIN_ORANGE;
	}
	else {
		cell.contentLabel.textColor = COLOR_MAIN_BLACK_LIGHT;
	}
	cell.timeLabel.text = message.timeString;
	[cell.avatarImageView setImageWithURL:[message.fromuser_coverurl URL] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MessageEntity *message = [self.dataSource objectAtIndex:indexPath.row];
	if ([message.type isEqualToString:MESSAGE_ACTIVITY_INVITE_TYPE]) { //活动邀请
		[self performSegueWithIdentifier:[ActivityDetailViewController className] sender:[self.tableView cellForRowAtIndexPath:indexPath]];
	}
	else if ([message.type isEqualToString:MESSAGE_ACTIVITY_CANCEL_TYPE]) {  //活动取消
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		if ([message.obj isMeaningful]) {
			MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在從你的活動日曆中移除該活動...")];
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			[manager GET:[NETWORK_HOST addString:@"activity.php?action=activity_info"] parameters:
			 @{
			     @"id" : message.obj,
			     @"uid":[UserEntity mainUser].id,
                             @"language":[Utils preferredLanguage],
			 }
			     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
			    [progressView dismiss:YES];
			    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
			        ActivityEntity *activity = [ActivityEntity toObject:[responseObject objectForKey:@"resultContent"]];
			        [Utils removeEvent:activity];
			        [MRProgressOverlayView showYES:LOCALIZED(@"已經從活動日曆中移除！")];
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
	}
	else if ([message.type isEqualToString:MESSAGE_FRIEND_ADD_TYPE]) {  //添加好友
		[self performSegueWithIdentifier:[UserDetailTableViewController className] sender:[self.tableView cellForRowAtIndexPath:indexPath]];
	}
	else if ([message.type isEqualToString:MESSAGE_FRIEND_SEND_TYPE]) {  //聊天消息
		[self performSegueWithIdentifier:[MessageNewViewController className] sender:[self.tableView cellForRowAtIndexPath:indexPath]];
	}

	else if ([message.type isEqualToString:MESSAGE_FRIEND_HELLO_TYPE]) {  //打招呼
		[self performSegueWithIdentifier:[UserDetailTableViewController className] sender:[self.tableView cellForRowAtIndexPath:indexPath]];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		MessageEntity *message = [self.dataSource objectAtIndex:indexPath.row];
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		[manager GET:[NETWORK_HOST addString:@"message_system.php?action=remove"] parameters:
		 @{
		     @"id":message.id,
                         @"language":[Utils preferredLanguage],
		 }
		     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
		    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {

			}
		    else {
		        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
			}
		} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
		    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
		}];
		[self.dataSource removeObjectAtIndex:indexPath.row];
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([sender isKindOfClass:[MessageTableViewCell class]]) {
		MessageEntity *message = [self.dataSource objectAtIndex:self.tableView.indexPathForSelectedRow.row];
		if ([segue.identifier isEqualToString:[ActivityDetailViewController className]]) {
			((ActivityDetailViewController *)segue.destinationViewController).aid = message.obj;
		}
		else if ([segue.identifier isEqualToString:[UserDetailTableViewController className]]) {
			((UserDetailTableViewController *)segue.destinationViewController).type = [message.type isEqualToString:MESSAGE_FRIEND_HELLO_TYPE] ? UserDetailTableViewControllerTypeNearBy : UserDetailTableViewControllerTypeOperate;
			((UserDetailTableViewController *)segue.destinationViewController).uid = message.obj;

			((UserDetailTableViewController *)segue.destinationViewController).message = message;
		}
		else if ([segue.identifier isEqualToString:[MessageNewViewController className]]) {
			MessageNewViewController *controller = segue.destinationViewController;
			controller.uid = message.fromuser;
		}
	}
}

- (void)handleNavBarRight:(id)sender {
	[super handleNavBarRight:sender];
	BOOL isLogined = [[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_IS_LOGINED] boolValue];
	if (isLogined) {
		IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:LOCALIZED(@"刪除後將無法恢復") delegate:self cancelButtonTitle:LOCALIZED(@"取消") destructiveButtonTitle:LOCALIZED(@"全部刪除") otherButtonTitles:nil, nil];
		[standardIBAS showInView:[UIApplication window]];
	}
	else {
		[self performSegueWithIdentifier:[SignInViewController className] sender:nil];
	}
}

- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在刪除...")];
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		[manager GET:[NETWORK_HOST addString:@"message_system.php?action=remove"] parameters:
		 @{
		     @"touser":[UserEntity mainUser].id,
                         @"language":[Utils preferredLanguage],
		 }
		     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
		    [progressView dismiss:YES];
		    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
		        [self.dataSource removeAllObjects];
		        [self.tableView reloadData];
		        [MRProgressOverlayView showYES:LOCALIZED(@"已經全部刪除！")];
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

@end
