//
//  UserGenderTableViewController.m
//  XJoin
//
//  Created by shadow on 14/11/8.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UserGenderTableViewController.h"
#import "XJoin.h"
@interface UserGenderTableViewController ()

@end

@implementation UserGenderTableViewController


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([self.user.gender isEqualToString:@"1"]) {
		[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
	}
	else if ([self.user.gender isEqualToString:@"2"]) {
		[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (![[self.user.signature trimEdge] isEqualToString:[self.contentTV.text trimEdge]]) {
		NSInteger index = [self.tableView indexPathForSelectedRow].row + 1;
		self.user.gender = Format(@"%d", index);
		if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
			[self.passedDelegate backPassViewController:self pass:@{ @"user":self.user }];
		}
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
