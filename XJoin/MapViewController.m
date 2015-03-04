//
//  MapViewController.m
//  XJoin
//
//  Created by shadow on 14-8-26.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "MapViewController.h"
#import "XJoin.h"
@interface MapViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate> {
	BOOL _isCompleteEnable;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MapViewController
- (void)prepareForData {
	[super prepareForData];
	self.dataSource = [NSMutableArray array];
}

- (void)prepareForView {
	[super prepareForView];
	[self enableMenu:NO animated:NO];
	[self enableTableView:NO animated:NO];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	    if (self.type == MapViewControllerTypeQuickLook) {
	        Annotation *ann = [Annotation annotationWithCoordinate:self.location.coordinate title:self.location.title];
	        [self.mapView addAnnotation:ann];

	        [self handleAnnotation:nil];
		}
	    else {
	        [self handleLocation:nil];
		}
	});
}

- (void)enableMenu:(BOOL)isEnable animated:(BOOL)isAnimated {
	CGFloat duration = isAnimated ? 0.3 : 0;
	CGFloat offsetX = isEnable ? 0 : 100;
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
	    self.locationBtn.transform = CGAffineTransformMakeTranslation(offsetX, 0);
	} completion:NULL];
	[UIView animateWithDuration:duration delay:isAnimated ? 0.1:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
	    self.annotationBtn.transform = CGAffineTransformMakeTranslation(offsetX, 0);
	} completion:NULL];
	[UIView animateWithDuration:duration delay:isAnimated ? 0.2:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
	    self.layerBtn.transform = CGAffineTransformMakeTranslation(offsetX, 0);
	} completion:NULL];

	[UIView animateWithDuration:duration delay:isAnimated ? 0.3:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
	    self.routeBtn.transform = CGAffineTransformMakeTranslation(offsetX, 0);
	} completion:NULL];
}

- (void)handleNavBarRight:(id)sender {
	if (_isCompleteEnable) {
		if ([self.location isMeaningful]) {
			if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
				[self.passedDelegate backPassViewController:self pass:@{ @"location" : self.location }];
				[self.navigationController dismissModalViewControllerAnimated:YES];
			}
		}
		else if (!CLLocationCoordinate2DIsZero(self.location.coordinate) && ![self.location.title isMeaningful]) {
			MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在選擇位置...")];
			CLGeocoder *geocoder = [[CLGeocoder alloc] init];
			[geocoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler: ^(NSArray *placemarks, NSError *error) {
			    [progressView dismiss:YES];
			    if (!error || [placemarks isMeaningful]) {
			        self.location.title = [[placemarks firstObject] name];
			        if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
			            [self.passedDelegate backPassViewController:self pass:@{ @"location" : self.location }];
			            [self.navigationController dismissModalViewControllerAnimated:YES];
					}
				}
			    else {
			        [self enableCompleteNavBarItem:NO];
			        [MRProgressOverlayView showNO:LOCALIZED(@"位置名稱無法查詢，請重新選擇！")];
				}
			}];
		}
		else {
			[MRProgressOverlayView showNO:LOCALIZED(@"位置無效，請重新選擇！")];
			[self enableCompleteNavBarItem:NO];
		}
	}
	else {
		[self.view endEditing:YES];
		[self enableMenu:self.locationBtn.transform.tx > 0 animated:YES];
	}
}

- (IBAction)handleLocation:(id)sender {
	self.mapView.showsUserLocation = YES;
	if (!CLLocationCoordinate2DIsZero(self.mapView.userLocation.location.coordinate)) {
		[self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.location.coordinate, MKCoordinateSpanMake(0, 0)) animated:YES];
	}
}

- (IBAction)handleAnnotation:(id)sender {
	if ([self.location isMeaningful]) {
		[self.mapView setRegion:MKCoordinateRegionMake(self.location.coordinate, MKCoordinateSpanMake(0, 0)) animated:YES];
	}
	else if (self.type == MapViewControllerTypeQuickLook) {
		[MRProgressOverlayView showNO:LOCALIZED(@"位置有誤，請確定位置是否正確！")];
	}
}

- (IBAction)handleLayer:(id)sender {
	self.mapView.mapType == MKMapTypeHybrid ? self.mapView.mapType = MKMapTypeStandard : self.mapView.mapType++;
}

- (IBAction)handleRoute:(id)sender {
	CLLocationCoordinate2D startCoor = self.mapView.userLocation.location.coordinate;
	CLLocationCoordinate2D endCoor = self.location.coordinate;

	if (!CLLocationCoordinate2DIsZero(startCoor) && !CLLocationCoordinate2DIsZero(endCoor)) {
		if (IOS_VERSION < 6) {
			NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d", startCoor.latitude, startCoor.longitude, endCoor.latitude, endCoor.longitude];
			urlString =  [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			NSURL *aURL = [NSURL URLWithString:urlString];
			[[UIApplication sharedApplication] openURL:aURL];
		}
		else {
			MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
			MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil]];
			toLocation.name = self.location.title;
			[MKMapItem openMapsWithItems:@[currentLocation, toLocation]
			               launchOptions:@{ MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey : [NSNumber numberWithBool:YES] }];
		}
	}
	else {
		[MRProgressOverlayView showNO:LOCALIZED(@"位置有誤，請確定位置是否正確！")];
	}
}

- (void)handleSearch {
	if ([self.addressTF.text isMeaningful]) {
		MRProgressOverlayView *progressView = [MRProgressOverlayView showLoading:LOCALIZED(@"正在查找位置...")];
		CLGeocoder *geocoder = [[CLGeocoder alloc] init];
		[geocoder geocodeAddressString:self.addressTF.text completionHandler: ^(NSArray *placemarks, NSError *error) {
		    [progressView dismiss:YES];
		    [self.dataSource removeAllObjects];
		    [self.dataSource addObjectsFromArray:placemarks];
		    [self.tableView reloadData];
		    if (error || ![placemarks isMeaningful]) {
		        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:LOCALIZED(@"位置無法查詢，是否繼續添加？")];
		        [alertView addButtonWithTitle:LOCALIZED(@"取消")
		                                 type:SIAlertViewButtonTypeCancel
		                              handler: ^(SIAlertView *alertView) {
		            NSLog(@"Cancel Clicked");
				}];
		        [alertView addButtonWithTitle:LOCALIZED(@"確定")
		                                 type:SIAlertViewButtonTypeDestructive
		                              handler: ^(SIAlertView *alertView) {
		            LocationEntity *location = [[LocationEntity alloc] init];
		            location.title = self.addressTF.text;
		            location.isOnlyTitle = YES;
		            self.location = location;
		            [self enableCompleteNavBarItem:YES];
		            [self handleNavBarRight:nil];
				}];
		        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
		        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
		        [alertView show];
			}
		    else {
		        [self enableTableView:YES animated:YES];
			}
		}];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[self handleSearch];
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[self enableMenu:NO animated:YES];
	[self enableCompleteNavBarItem:NO];
	return YES;
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TableViewCell className] forIndexPath:indexPath];
	CLPlacemark *mark = [self.dataSource objectAtIndex:indexPath.row];
	cell.textLabel.text = mark.name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CLPlacemark *mark = [self.dataSource objectAtIndex:indexPath.row];

	LocationEntity *location = [[LocationEntity alloc] init];
	location.coordinate = mark.location.coordinate;
	location.title = mark.name;
	self.location = location;

	Annotation *ann = [Annotation annotationWithCoordinate:self.location.coordinate title:self.location.title];
	[self.mapView setRegion:MKCoordinateRegionMake(ann.coordinate, MKCoordinateSpanMake(0, 0)) animated:YES];
	[self.mapView addAnnotation:ann];
	[self enableCompleteNavBarItem:YES];


	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self enableTableView:NO animated:YES];
}

- (void)enableTableView:(BOOL)isEnable animated:(BOOL)isAnimated {
	[self.view endEditing:YES];
	CGFloat duration = isAnimated ? 0.5 : 0;
	CGFloat offsetY = isEnable ? 0 : SCREEN_HEIGHT;
	[UIView animateWithDuration:duration animations: ^{
	    self.tableView.transform = CGAffineTransformMakeTranslation(0, offsetY);
	}];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation> )annotation {
	static NSString *placemarkIdentifier = @"AnnotationView";
	if ([annotation isKindOfClass:[Annotation class]]) {
		AnnotationView *view = (AnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:placemarkIdentifier];
		if (!view) {
			view = [[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placemarkIdentifier];
		}
		view.imageView.image = [UIImage imageNamed:@"icon_annotation_fill"];
		view.titleLabel.text = [annotation title];
		[view.titleLabel sizeToFit];
		view.titleLabel.center = CGPointMake(view.imageView.center.x, view.imageView.center.y - 25);
		return view;
	}
	return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	[mapView deselectAnnotation:[[mapView selectedAnnotations] firstObject] animated:NO];
	if (self.type == MapViewControllerTypeEdit) {
		if ([view.annotation isKindOfClass:[Annotation class]]) {
			Annotation *ann = (Annotation *)view.annotation;
			LocationEntity *location = [[LocationEntity alloc] init];
			location.title = ann.title;
			location.coordinate = ann.coordinate;
			self.location = location;
		}
		else if ([view.annotation isKindOfClass:[MKUserLocation class]]) { //代表点击的是定位
			LocationEntity *location = [[LocationEntity alloc] init];
			location.coordinate = self.mapView.userLocation.location.coordinate;
			self.location = location;
			CLGeocoder *geocoder = [[CLGeocoder alloc] init];
			[geocoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler: ^(NSArray *placemarks, NSError *error) {
			    if (!error || [placemarks isMeaningful]) {
			        self.location.title = [[placemarks firstObject] name];
				}
			}];
		}

		[self enableCompleteNavBarItem:YES];
	}
}

- (void)enableCompleteNavBarItem:(BOOL)isEnable {
	_isCompleteEnable = isEnable;
	if (isEnable) {
		self.navigationItem.rightBarButtonItem.image = nil;
		self.navigationItem.rightBarButtonItem.title = LOCALIZED(@"完成");
	}
	else {
		[self.mapView removeAnnotations:self.mapView.annotations];
		self.location = nil;
		self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"icon_nav_more"];
		self.navigationItem.rightBarButtonItem.title = nil;
	}
}

- (IBAction)handleLongTap:(UILongPressGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateBegan) {
		CLLocationCoordinate2D coor = [self.mapView convertPoint:[sender locationInView:self.view] toCoordinateFromView:self.view];
		CLGeocoder *geocoder = [[CLGeocoder alloc] init];
		[geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude] completionHandler: ^(NSArray *placemarks, NSError *error) {
		    if (!error || [placemarks isMeaningful]) {
		        [self enableCompleteNavBarItem:NO];
		        LocationEntity *location = [[LocationEntity alloc] init];
		        location.coordinate = coor;
		        self.location = location;
		        self.location.title = [[placemarks firstObject] name];

		        Annotation *ann = [Annotation annotationWithCoordinate:coor title:self.location.title];
		        [self.mapView addAnnotation:ann];
		        [self enableCompleteNavBarItem:YES];
			}
		    else {
		        [MRProgressOverlayView showNO:LOCALIZED(@"位置名稱無法查詢，請重新選擇！")];
			}
		}];
	}
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
	[self.view endEditing:YES];
	[self enableMenu:NO animated:YES];
	[self enableCompleteNavBarItem:NO];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] || [gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
		if (self.type == MapViewControllerTypeQuickLook) {
			return NO;
		}

		CGPoint point = [gestureRecognizer locationInView:self.view];
		if (CGRectContainsPoint(self.tableView.frame, point)) {
			return NO;
		}

		for (id <MKAnnotation> ann in self.mapView.annotations) {
			CGPoint p = [self.mapView convertCoordinate:[ann coordinate] toPointToView:self.view];
			CGRect frame = CGRectMake(p.x - 40, p.y - 40, 80, 80);
			if (CGRectContainsPoint(frame, point)) {
				return NO;
			}
		}
	}
	return YES;
}

@end

@implementation AnnotationView
- (id)initWithAnnotation:(id <MKAnnotation> )annotation reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
		self.titleLabel = [[UILabel alloc] init];
		self.titleLabel.font = [UIFont systemFontOfSize:13];
		self.titleLabel.textColor = COLOR_MAIN_ORANGE;
		self.titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-15, -15, 30, 30)];
		self.imageView.contentMode = UIViewContentModeScaleAspectFill;
		[self addSubview:self.titleLabel];
		[self addSubview:self.imageView];
	}
	return self;
}

@end

@implementation Annotation
@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
+ (Annotation *)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
	Annotation *result = [[Annotation alloc] init];
	result.coordinate = coordinate;
	result.title = title;

	return result;
}

@end
