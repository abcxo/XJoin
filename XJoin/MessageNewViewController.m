//
//  MessageNewViewController.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "MessageNewViewController.h"
#import "XJoin.h"
@interface MessageNewViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UserEntity *mainUser;
@end

@implementation MessageNewViewController
- (void)prepareForData {
	[super prepareForData];
	[[NotificationCenter defaultCenter] addObserver:self selector:@selector(notificatiedLogouted:) name:NOTIFICATION_LOGOUTED object:nil];
	self.dataSource = [[NSMutableArray alloc] init];
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

- (IBAction)handleSendMessage:(id)sender {
	[self.contentTF resignFirstResponder];
	if ([self.contentTF.text isMeaningful]) {
		MessageEntity *message = [[MessageEntity alloc] init];
		message.fromuser = self.mainUser.id;
		message.fromuser_coverurl = self.mainUser.coverurl;
		message.content = self.contentTF.text;
		message.subject = self.mainUser.nickname;
		message.type = MESSAGE_FRIEND_SEND_TYPE;
		message.obj = self.mainUser.id;
		message.createDate = [[NSDate date] timeIntervalSince1970];
		message.updateDate = message.createDate;
		[self.dataSource addObject:message];
		[self.tableView reloadData];
		[self scrollToBottomAnimated:NO];
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		[manager GET:[NETWORK_HOST addString:@"message_system.php?action=add"] parameters:
		 @{
		     @"type":MESSAGE_FRIEND_SEND_TYPE,
		     @"subject":self.mainUser.nickname,
		     @"content":self.contentTF.text,
		     @"touser":self.uid,
		     @"fromuser":self.mainUser.id,
		     @"obj":self.mainUser.id,
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
		self.contentTF.text = nil;
	}
}

- (void)prepareForView {
	[super prepareForView];
	[self handleListMessage];
}

- (void)handleListMessage {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:[NETWORK_HOST addString:@"user.php?action=get_message_list"]  parameters:
	 @{
	     @"type" : MESSAGE_FRIEND_SEND_TYPE,
	     @"fromuser":self.uid,
	     @"touser":self.mainUser.id,
	     @"page":@(1),
	     @"pagesize":@(1000),
                     @"language":[Utils preferredLanguage],
	 }
	     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	        NSArray *toMeMessages = [MessageEntity toObjects:responseObject[@"resultContent"][@"content"]];
	        [self.dataSource removeAllObjects];
	        [self.dataSource addObjectsFromArray:toMeMessages];
	        [manager GET:[NETWORK_HOST addString:@"user.php?action=get_message_list"]  parameters:
	         @{
	             @"type" : MESSAGE_FRIEND_SEND_TYPE,
	             @"fromuser":self.mainUser.id,
	             @"touser":self.uid,
	             @"page":@(1),
	             @"pagesize":@(1000),
                             @"language":[Utils preferredLanguage],
			 }
	             success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	            if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	                NSArray *toItMessages = [MessageEntity toObjects:responseObject[@"resultContent"][@"content"]];
	                [self.dataSource addObjectsFromArray:toItMessages];
	                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES];
	                [self.dataSource sortUsingDescriptors:@[sort]];

	                [self.tableView reloadData];
	                [self scrollToBottomAnimated:NO];
				}
	            else {
	                [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
				}
			} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	            [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
			}];
		}
	    else {
	        [MRProgressOverlayView showNO:[responseObject objectForKey:@"returnMsg"]];
		}
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    [MRProgressOverlayView showNO:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
	}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MessageEntity *message = [self.dataSource objectAtIndex:indexPath.row];
	if ([message.fromuser isEqualToString:self.mainUser.id]) {
		MessageNewRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MessageNewRightTableViewCell className]];
		[cell.avatarImageView setImageWithURL:[message.fromuser_coverurl URL] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
		cell.timeLabel.text = message.timeString;
		cell.titleLabel.text = message.subject;

		cell.contentLabel.text = message.content;
		[cell.contentLabel setFrameX:CGRectGetMinX(cell.avatarImageView.frame) - 10 - CGRectGetWidth(cell.contentLabel.frame)];
		return cell;
	}
	else {
		MessageNewLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MessageNewLeftTableViewCell className]];
		cell.timeLabel.text = message.timeString;
		cell.titleLabel.text = message.subject;

		cell.contentLabel.text = message.content;
		[cell.avatarImageView setImageWithURL:[message.fromuser_coverurl URL] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
		return cell;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self handleSendMessage:nil];
	return YES;
}

- (void)scrollToBottomAnimated:(BOOL)animated {
	NSInteger rows = [self.tableView numberOfRowsInSection:0];
	if (rows > 0) {
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
		                      atScrollPosition:UITableViewScrollPositionBottom
		                              animated:animated];
	}
}

@end
