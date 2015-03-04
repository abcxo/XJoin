//
//  FriendTableViewController.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "FriendTableViewController.h"
#import "XJoin.h"
@interface FriendTableViewController () <UISearchDisplayDelegate>
@end

@implementation FriendTableViewController

- (void)prepareForData {
	[super prepareForData];
	self.dataSource = [[NSMutableOrderedDictionary alloc] init];
	self.dataSearchSource = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self prepareForUserView];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController.tabBarItem setBadgeValue:nil];
	[[StorageDefaults appDefaults] removeObjectForKey:APP_DEFAULT_NOTIFICATION_FRIEND_COUNT];
}

- (void)prepareForUserView {
	BOOL isLogined = [[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_IS_LOGINED] boolValue];
	self.loginBtn.hidden = isLogined;
	if (isLogined) {
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		[self handleListFriend];
	}
	else {
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		if (!self.loginBtn.superview) {
			CGRect frame = self.loginBtn.frame;
			frame.size.width = IOS_VERSION_LOW_7 ? 285 : 300;
			frame.origin.x = IOS_VERSION_LOW_7 ? 6 : 10;
			frame.origin.y = IS_LONG_SCREEN ? 205 : 160;
			self.loginBtn.frame = frame;

			[self.tableView addSubview:self.loginBtn];
		}
		[self.tableView bringSubviewToFront:self.loginBtn];
		[self.dataSource removeAllObjects];
		[self.tableView reloadData];
	}
}

- (void)handleListFriend {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:[NETWORK_HOST addString:@"user.php?action=get_firends"]  parameters:
	 @{
	     @"uid" : [UserEntity mainUser].id,
                     @"language":[Utils preferredLanguage],
	 }
	     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	        [self.dataSource removeAllObjects];
	        NSDictionary *dict = responseObject[@"resultContent"][@"content"];
	        for (NSString * key in[dict allKeys]) {
	            NSArray *array =  [dict objectForKey:key];
	            NSMutableArray *a = [NSMutableArray array];
	            for (NSDictionary * subDict in array) {
	                NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:subDict];
	                [d setObject:@(YES) forKey:@"isfriend"];
	                [a addObject:d];
				}
	            NSArray *users = [UserEntity toObjects:a];
	            [self.dataSource setObject:users forKey:[key uppercaseString]];
			}

	        [self.tableView reloadData];
		}
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView == self.tableView) {
		return self.dataSource.count;
	}
	else {
		tableView.backgroundColor = COLOR_MAIN_GRAY_LIGHT;
		tableView.separatorColor = COLOR_MAIN_GRAY_MID;
		tableView.rowHeight = 56;

		return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.tableView) {
		return [(NSArray *)[self.dataSource objectAtIndex:section] count];
	}
	else {
		return self.dataSearchSource.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.tableView) {
		FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FriendTableViewCell className]];
		UserEntity *user  = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		cell.nickNameLabel.text = user.nickname;
		[cell.avatarImageView setImageWithURL:[user avatarURL] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
		return cell;
	}
	else {
		FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FriendTableViewCell className]];
		if (!cell) {
			cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FriendTableViewCell className]];
		}
		UserEntity *user = [self.dataSearchSource objectAtIndex:indexPath.row];
		cell.nickNameLabel.text = user.nickname;
		[cell.avatarImageView setImageWithURL:[user avatarURL] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
		return cell;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (tableView == self.tableView) {
		UILabel *view = [[UILabel alloc] init];
		view.backgroundColor = COLOR_MAIN_GRAY_MID;
		view.font = [UIFont boldSystemFontOfSize:15];
//		view.layer.shadowColor = COLOR_MAIN_GRAY.CGColor;
//		view.layer.shadowOffset = CGSizeMake(4, 3);
//		view.layer.shadowOpacity = 0.3; //阴影透明度，默认0
		view.textColor = [UIColor whiteColor];
		view.text = Format(@"      %@", [self.dataSource keyAtIndex:section]);

		return view;
	}

	return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (tableView == self.tableView) {
		return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
		        [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	if (tableView == self.tableView) {
		if (title == UITableViewIndexSearch) {
			[tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
			return NSNotFound;
		}
		else {
			return [self.dataSource indexOfKey:title];
		}
	}
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
		UserEntity *user = nil;
		if (self.searchDisplayController.isActive) {
			user = [[self.dataSearchSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		}
		else {
			user = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		}
		[self.passedDelegate backPassViewController:self pass:@{ @"user" : user }];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		    [self.navigationController dismissModalViewControllerAnimated:YES];
		});
	}
	else {
		if (self.searchDisplayController.isActive) {
			[self performSegueWithIdentifier:[UserDetailTableViewController className] sender:[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath]];
		}
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:[UserDetailTableViewController className]]) {
		if (self.searchDisplayController.isActive) {
			NSIndexPath *selectedIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
			((UserDetailTableViewController *)segue.destinationViewController).type = UserDetailTableViewControllerTypeQuickLook;
			((UserDetailTableViewController *)segue.destinationViewController).user = [self.dataSearchSource objectAtIndex:selectedIndexPath.row];
		}
		else {
			NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
			((UserDetailTableViewController *)segue.destinationViewController).type = UserDetailTableViewControllerTypeQuickLook;
			((UserDetailTableViewController *)segue.destinationViewController).user = [[self.dataSource objectAtIndex:selectedIndexPath.section] objectAtIndex:selectedIndexPath.row];
		}
	}
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	if ([identifier isEqualToString:[UserNewViewController className]]) {
		BOOL isLogined = [[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_IS_LOGINED] boolValue];
		if (!isLogined) {
			[self performSegueWithIdentifier:[SignInViewController className] sender:nil];
			return NO;
		}
	}
	return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	NSArray *allValues = [[self.dataSource allValues] arrayWithBlock: ^id (id obj, NSInteger index) {
	    return obj;
	}];
	NSArray *array = [allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.nickname CONTAINS[cd] %@ OR SELF.username CONTAINS[cd] %@", [searchString trimAll], [searchString trimAll]]];
	[self.dataSearchSource removeAllObjects];
	[self.dataSearchSource addObjectsFromArray:array];
	return YES;
}

@end
