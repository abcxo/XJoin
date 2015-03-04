//
//  UserNearByTableViewController.m
//  XJoin
//
//  Created by shadow on 14-10-12.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "UserNearByTableViewController.h"
#import "XJoin.h"
@interface UserNearByTableViewController () <CLLocationManagerDelegate, IBActionSheetDelegate> {
	NSString *_type;
}
@property (nonatomic, strong) UserEntity *mainUser;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation UserNearByTableViewController


//协议中的方法，作用是每当位置发生更新时会调用的委托方法
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	//结构体，存储位置坐标
	CLLocationCoordinate2D loc = [newLocation coordinate];
	self.longitude = loc.longitude;
	self.latitude = loc.latitude;
	[self.tableView headerBeginRefreshing];
}

//当位置获取或更新失败会调用的方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSString *errorMsg = nil;
	if ([error code] == kCLErrorDenied) {
		errorMsg = LOCALIZED(@"請在設置-隱私打開定位，並且允許XJoin訪問！");
	}
	if ([error code] == kCLErrorLocationUnknown) {
		errorMsg = LOCALIZED(@"獲取位置信息失敗！");
	}
	[MRProgressOverlayView showNO:errorMsg];
}

- (void)handleNavBarRight:(id)sender {
	IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZED(@"取消")destructiveButtonTitle:nil otherButtonTitles:LOCALIZED(@"查看全部"), LOCALIZED(@"僅看女生"), LOCALIZED(@"僅看男生"), LOCALIZED(@"僅看好友"), nil];
	[standardIBAS showInView:[UIApplication window]];
}

- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			self.title = LOCALIZED(@"附近的人(全部)");
			_type = @"all";
			[self.tableView headerBeginRefreshing];
			break;

		case 1:
			self.title = LOCALIZED(@"附近的人(女生)");
			_type = @"female";
			[self.tableView headerBeginRefreshing];
			break;

		case 2:
			self.title = LOCALIZED(@"附近的人(男生)");
			_type = @"male";
			[self.tableView headerBeginRefreshing];
			break;

		case 3:
			self.title = LOCALIZED(@"附近的人(好友)");
			_type = @"friend";
			[self.tableView headerBeginRefreshing];
			break;


		default:
			break;
	}
}

- (UserEntity *)mainUser {
	if (![_mainUser isMeaningful]) {
		_mainUser = [UserEntity mainUser];
	}
	return _mainUser;
}

- (void)prepareForData {
	[super prepareForData];
	self.dataSource = [NSMutableArray array];
	_type = @"all";
	self.locationManager = [[CLLocationManager alloc]init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.distanceFilter = 100;
	[self.locationManager startUpdatingLocation];
}

- (void)prepareForView {
	[super prepareForView];
	[self prepareForUserView];
}

- (void)prepareForUserView {
	__weak typeof(self) __self = self;

	[self.tableView addHeaderWithCallback: ^{
	    if (__self.longitude > 0 && __self.latitude > 0) {
	        NSInteger before = __self.index;
	        __self.index = 1;
	        [__self handleListUser:__self.index success:NULL failure: ^{
	            __self.index = before;
			}];
		}
	    else {
	        [__self.tableView headerEndRefreshing];
	        [MRProgressOverlayView showNO:LOCALIZED(@"獲取位置信息失敗！")];
		}
	}];

	[self.tableView addFooterWithCallback: ^{
	    if (__self.longitude > 0 && __self.latitude > 0) {
	        NSInteger before = __self.index;
	        __self.index++;
	        [__self handleListUser:__self.index success:NULL failure: ^{
	            __self.index = before;
			}];
		}
	    else {
	        [__self.tableView footerEndRefreshing];
	        [MRProgressOverlayView showNO:LOCALIZED(@"獲取位置信息失敗！")];
		}
	}];
}

- (void)handleListUser:(NSInteger)index success:(void (^)(void))success failure:(void (^)(void))failure {
	__block BOOL isSuc = NO;
	NSDictionary *param =     @{
		@"uid":self.mainUser.id,
		@"page":@(index),
		@"pagesize":@(20),
		@"type" :_type,
		@"longitude" : @(self.longitude),
		@"latitude" : @(self.latitude),
                    @"language":[Utils preferredLanguage],
	};
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:[NETWORK_HOST addString:@"user.php?user.php&action=nearby_members"] parameters:param
	     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    if (index == 1) {
	        if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	            NSArray *users = [UserEntity toObjects:responseObject[@"resultContent"]];
	            [self.dataSource removeAllObjects];
	            [self.dataSource addObjectsFromArray:users];
	            [self.tableView reloadData];
	            isSuc = YES;
	            if (success) {
	                success();
				}
			}

	        [self.tableView headerEndRefreshing];
		}
	    else {
	        if ([[responseObject objectForKey:@"returnCode"] boolValue] == YES) {
	            NSArray *users = [UserEntity toObjects:responseObject[@"resultContent"]];
	            if ([users isMeaningful]) {
	                [self.dataSource addObjectsFromArray:users];
	                [self.tableView reloadData];
	                isSuc = YES;
	                if (success) {
	                    success();
					}
				}
			}

	        [self.tableView footerEndRefreshing];
		}

	    if (!isSuc) {
	        if (failure) {
	            failure();
			}
		}
	}

	     failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    if (index == 1) {
	        [self.tableView headerEndRefreshing];
		}
	    else {
	        [self.tableView footerEndRefreshing];
		}

	    if (!isSuc) {
	        if (failure) {
	            failure();
			}
		}
	}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UserNearByTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserNearByTableViewCell className]];
	UserEntity *user  = [self.dataSource objectAtIndex:indexPath.row];
	cell.nickNameLabel.text = user.nickname;
	cell.signatureLabel.text = user.signature;
	cell.distanceLabel.text = Format(@"%@ | %@", user.distance, user.last_login);
	cell.genderImageView.image = [UIImage imageNamed:[user.gender isEqualToString:@"1"] ? @"icon_tag_gender_male":@"icon_tag_gender_female"];
	[cell.avatarImageView setImageWithURL:[user avatarURL] placeholderImage:[UIImage imageNamed:@"icon_avatar_default"]];
	return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:[UserDetailTableViewController className]]) {
		NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
		((UserDetailTableViewController *)segue.destinationViewController).type = UserDetailTableViewControllerTypeNearBy;
		((UserDetailTableViewController *)segue.destinationViewController).user = [self.dataSource objectAtIndex:selectedIndexPath.row];
	}
}

@end
