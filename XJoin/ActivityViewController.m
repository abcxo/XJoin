//
//  ActivityViewController.m
//  XJoin
//
//  Created by shadow on 14-8-20.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "ActivityViewController.h"
#import "XJoin.h"

typedef NS_ENUM (NSUInteger, ListActivityType) {
	ListActivityTypeRecommend,
	ListActivityTypeMe,
};
@interface ActivityViewController () {
	NSInteger _recommendIndex;
	NSInteger _meIndex;
}
@property (nonatomic, strong) UserEntity *mainUser;
@end

@implementation ActivityViewController
- (UserEntity *)mainUser {
	if (![_mainUser isMeaningful]) {
		_mainUser = [UserEntity mainUser];
	}
	return _mainUser;
}

- (void)prepareForData {
	[super prepareForData];
	[[NotificationCenter defaultCenter] addObserver:self selector:@selector(notificatiedLogined:) name:NOTIFICATION_LOGINED object:nil];
	[[NotificationCenter defaultCenter] addObserver:self selector:@selector(notificatiedLogouted:) name:NOTIFICATION_LOGOUTED object:nil];
	self.recommendDataSource = [[NSMutableArray alloc] init];
	self.meDataSource = [[NSMutableArray alloc] init];
}

- (void)notificatiedLogined:(NSNotification *)ns {
	[self prepareForUserView];
}

- (void)notificatiedLogouted:(NSNotification *)ns {
	[self prepareForUserView];
}

- (void)dealloc {
	[[NotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForUserView {
	BOOL isLogined = [[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_IS_LOGINED] boolValue];
	self.meTableView.hidden = !isLogined;
	self.loginBtn.hidden = isLogined;
	_meIndex = 1;
	if (isLogined) {
		[self.meTableView addHeaderWithCallback: ^{
		    NSInteger before = _meIndex;
		    _meIndex = 1;
		    [self handleListActivity:_meIndex type:ListActivityTypeMe success:NULL failure: ^{
		        _meIndex = before;
			}];
		}];

		[self.meTableView addFooterWithCallback: ^{
		    NSInteger before = _meIndex;
		    _meIndex++;
		    [self handleListActivity:_meIndex type:ListActivityTypeMe success:NULL failure: ^{
		        _meIndex = before;
			}];
		}];
		[self.meTableView headerBeginRefreshing];
	}
	else {
		_mainUser = nil;
		self.createBtn.alpha = 0;
		[self.meTableView headerEndRefreshing];
		[self.meTableView footerEndRefreshing];
		[self.meDataSource removeAllObjects];
		[self.meTableView reloadData];
	}
}

- (void)prepareForView {
	[super prepareForView];
	if (IOS_VERSION_LOW_7) {
		self.recommendTableView.contentInset = UIEdgeInsetsZero;
		self.recommendTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
		self.meTableView.contentInset = UIEdgeInsetsZero;
		self.meTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
	}


	if (!IS_LONG_SCREEN) {
		[self.loginBtn setFrameY:160];
		[self.createBtn setFrameY:160];
	}


	[self.segment setFrame:CGRectMake(0, 0, 180, 30) items:
	 @[
	     @{ @"text":LOCALIZED(@"推薦活動"), @"icon":@"" },
	     @{ @"text":LOCALIZED(@"我"), @"icon":@"" },

	 ]

	          iconPosition:IconPositionRight andSelectionBlock: ^(NSUInteger segmentIndex) {
	    [self.scrollView setContentOffset:CGPointMake(segmentIndex * SCREEN_WIDTH, 0) animated:YES];
	} iconSeparation:0.5];
	self.segment.color = COLOR_MAIN_RED_DARK;
	self.segment.borderWidth = 0.1;
	self.segment.borderColor = [UIColor whiteColor];
	self.segment.selectedColor = COLOR_MAIN_GRAY_LIGHT;
	self.segment.textAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],
		                             NSForegroundColorAttributeName:[UIColor whiteColor] };
	self.segment.selectedTextAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:13],
		                                     NSForegroundColorAttributeName:COLOR_MAIN_RED_DARK };

	[self.segment setEnabled:YES forSegmentAtIndex:1];
	[self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];


	[self prepareForUserView];
	[self.recommendTableView addHeaderWithCallback: ^{
	    NSInteger before = _recommendIndex;
	    _recommendIndex = 1;
	    [self handleListActivity:_recommendIndex type:ListActivityTypeRecommend success:NULL failure: ^{
	        _recommendIndex = before;
		}];
	}];
	[self.recommendTableView addFooterWithCallback: ^{
	    NSInteger before = _recommendIndex;
	    _recommendIndex++;
	    [self handleListActivity:_recommendIndex type:ListActivityTypeRecommend success:NULL failure: ^{
	        _recommendIndex = before;
		}];
	}];

	_recommendIndex = 1;
	[self.recommendTableView headerBeginRefreshing];
}

- (void)backPassViewController:(UIViewController *)viewController pass:(id)userInfo {
	ActivityEntity *activity = userInfo[@"activity"];
	if ([activity isMeaningful]) {
		if (self.segment.currentSelected == 0) {
			[self.recommendDataSource replaceObjectAtIndex:[self.recommendTableView indexPathForSelectedRow].section withObject:activity];
		}
		else {
			[self.meDataSource replaceObjectAtIndex:[self.meTableView indexPathForSelectedRow].section withObject:activity];
		}
	}

	if ([userInfo[@"refreshMe"] boolValue]) {
		_meIndex = 1;
		[self.meTableView headerBeginRefreshing];
	}
}

- (void)handleListActivity:(NSInteger)index type:(ListActivityType)type success:(void (^)(void))success failure:(void (^)(void))failure  {
	__block BOOL isSuc = NO;
	NSDictionary *param =     @{
		@"recommend" : @(1),
		@"page":@(index),
		@"pagesize":@(20),
                    @"language":[Utils preferredLanguage],
	};

	if (type == ListActivityTypeMe) {
		param = @{
			@"uid":self.mainUser.id,
			@"page":@(index),
			@"pagesize":@(20),
            @"language":[Utils preferredLanguage],
		};
	}
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:[NETWORK_HOST addString:@"user.php?action=get_activity"] parameters:param
	     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    if (type == ListActivityTypeRecommend) {
	        if (index == 1) {
	            if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	                NSArray *activities = [ActivityEntity toObjects:responseObject[@"resultContent"][@"content"]];
	                [activities put];
	                [self.recommendDataSource removeAllObjects];
	                [self.recommendDataSource addObjectsFromArray:activities];
	                [self.recommendTableView reloadData];
	                isSuc = YES;
	                if (success) {
	                    success();
					}
				}

	            [self.recommendTableView headerEndRefreshing];
			}
	        else {
	            if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	                NSArray *activities = [ActivityEntity toObjects:responseObject[@"resultContent"][@"content"]];
	                if ([activities isMeaningful]) {
	                    [activities put];
	                    [self.recommendDataSource addObjectsFromArray:activities];
	                    [self.recommendTableView reloadData];
	                    isSuc = YES;
	                    if (success) {
	                        success();
						}
					}
				}

	            [self.recommendTableView footerEndRefreshing];
			}
		}
	    else {
	        if (index == 1) {
	            if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	                NSArray *activities = [ActivityEntity toObjects:responseObject[@"resultContent"][@"content"]];
	                [activities put];
	                [self.meDataSource removeAllObjects];
	                [self.meDataSource addObjectsFromArray:activities];
	                [self.meTableView reloadData];
	                isSuc = YES;
	                if (success) {
	                    success();
					}
				}

	            [self.meTableView headerEndRefreshing];
			}
	        else {
	            if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	                NSArray *activities = [ActivityEntity toObjects:responseObject[@"resultContent"][@"content"]];
	                if ([activities isMeaningful]) {
	                    [activities put];
	                    [self.meDataSource addObjectsFromArray:activities];
	                    [self.meTableView reloadData];
	                    isSuc = YES;
	                    if (success) {
	                        success();
						}
					}
				}

	            [self.meTableView footerEndRefreshing];
			}
	        [UIView animateWithDuration:0.2 animations: ^{
	            self.createBtn.alpha = ![self.meDataSource isMeaningful];
			}];
		}

	    if (!isSuc) {
	        if (failure) {
	            failure();
			}
		}
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    if (type == ListActivityTypeRecommend) {
	        if (index == 1) {
	            [self.recommendTableView headerEndRefreshing];
			}
	        else {
	            [self.recommendTableView footerEndRefreshing];
			}
		}
	    else {
	        if (index == 1) {
	            [self.meTableView headerEndRefreshing];
			}
	        else {
	            [self.meTableView footerEndRefreshing];
			}
	        [UIView animateWithDuration:0.2 animations: ^{
	            self.createBtn.alpha = ![self.meDataSource isMeaningful];
			}];
		}
	    if (!isSuc) {
	        if (failure) {
	            failure();
			}
		}
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.recommendTableView deselectRowAtIndexPath:self.recommendTableView.indexPathForSelectedRow animated:YES];
	[self.meTableView deselectRowAtIndexPath:self.meTableView.indexPathForSelectedRow animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController.tabBarItem setBadgeValue:nil];
	[[StorageDefaults appDefaults] removeObjectForKey:APP_DEFAULT_NOTIFICATION_ACTIVITY_COUNT];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView == self.recommendTableView) {
		return self.recommendDataSource.count;
	}
	else {
		return self.meDataSource.count;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.recommendTableView) {
		ActivityRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ActivityRecommendTableViewCell className] forIndexPath:indexPath];
		ActivityEntity *activity = [self.recommendDataSource objectAtIndex:indexPath.section];
		cell.titleLabel.text = activity.subject;
		cell.timeLabel.text = activity.beginDateString;
		cell.locationLabel.text = activity.locationEntity.title;
		cell.tagLabel.text = activity.is_end ? LOCALIZED(@"(已結束)") : @"";
		cell.loveLabel.text = Format(@"%d", activity.inst_num);
		cell.joinLabel.text = Format(@"%d", activity.join_num);
		[cell.coverImageView setImageWithURL:[activity.activitycover URL] placeholderImage:[UIImage imageNamed:@"icon_cover_default"]];
		return cell;
	}
	else {
		ActivityMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ActivityMeTableViewCell className] forIndexPath:indexPath];
		ActivityEntity *activity = [self.meDataSource objectAtIndex:indexPath.section];
		cell.titleLabel.text = activity.subject;
		cell.timeLabel.text = activity.beginDateString;
		cell.locationLabel.text = activity.locationEntity.title;
		cell.tagLabel.text = activity.is_end ? LOCALIZED(@"(已結束)") : @"";
		cell.loveLabel.text = Format(@"%d", activity.inst_num);
		cell.joinLabel.text = Format(@"%d", activity.join_num);
		[cell.coverImageView setImageWithURL:[activity.activitycover URL] placeholderImage:[UIImage imageNamed:@"icon_cover_default"]];
		return cell;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (IOS_VERSION_LOW_6) {
		UIView *view = [[UIView alloc] init];
		view.hidden = YES;
	}
	else {
		UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[UITableViewHeaderFooterView className]];
		if (!view) {
			view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:[UITableViewHeaderFooterView className]];
			view.hidden = YES;
		}
		return view;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
		ActivityEntity *activity = nil;
		if (self.segment.currentSelected == 0) {
			activity = [self.recommendDataSource objectAtIndex:indexPath.section];
			[self.recommendTableView deselectRowAtIndexPath:indexPath animated:YES];
		}
		else {
			activity = [self.meDataSource objectAtIndex:indexPath.section];
			[self.meTableView deselectRowAtIndexPath:indexPath animated:YES];
		}
		[self.passedDelegate backPassViewController:self pass:@{ @"activity":activity }];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		    [self.navigationController dismissModalViewControllerAnimated:YES];
		});
	}
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	if ([identifier isEqualToString:[ActivityNewViewController className]]) {
		BOOL isLogined = [[[StorageDefaults userDefaults] objectForKey:USER_DEFAULT_IS_LOGINED] boolValue];
		if (!isLogined) {
			[self performSegueWithIdentifier:[SignInViewController className] sender:sender];
		}
		return isLogined;
	}
	return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:[ActivityDetailViewController className]]) {
		ActivityDetailViewController *controller = segue.destinationViewController;
		if ([sender isKindOfClass:[ActivityRecommendTableViewCell class]]) {
			ActivityEntity *activity = [self.recommendDataSource objectAtIndex:(int)[self.recommendTableView indexPathForSelectedRow].section];
			controller.activity = activity;
		}
		else {
			ActivityEntity *activity = [self.meDataSource objectAtIndex:(int)[self.meTableView indexPathForSelectedRow].section];
			controller.activity = activity;
		}
		controller.passedDelegate = self;
	}
	else if ([segue.identifier isEqualToString:[ActivityNewViewController className]]) {
		ActivityNewViewController *controller = (ActivityNewViewController *)[segue.destinationViewController topViewController];
		controller.passedDelegate = self;
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self.segment setEnabled:YES forSegmentAtIndex:self.scrollView.contentOffset.x > 0];
}

@end
